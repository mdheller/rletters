require 'active_record'

class Document  
  attr_reader :shasum, :doi, :authors, :title, :journal
  attr_reader :year, :volume, :number, :pages, :fulltext
  attr_reader :term_vectors, :term_list
  
  def doi_url
    "http://dx.doi.org/" + doi
  end
  
  
  
  def self.all
    search("*:*", true)
  end
  
  # Look up an individual document with the given shasum.  If the fulltext
  # parameter is set to true, we will retrieve it, otherwise we will not.
  #
  # If a matching document cannot be found, then this function will raise a 
  # RecordNotFound exception.  Other, worse exceptions may be thrown out of
  # RSolr.
  def self.find(shasum, fulltext = false)
    solr = RSolr.connect :url => APP_CONFIG['solr_server_url']
    
    # This is the only method here that can fail -- if we get no response,
    # a bad response, or something that cannot be evaluated, then we have
    # trouble.  But we'll just let that exception percolate up and cause a
    # 500 error.
    query_type = fulltext ? "fulltext" : "precise"
    solr_response = solr.get('select', :params => { :qt => query_type, :q => "shasum:#{shasum}" })
    
    # See if we have a document.  We only need to check == 0, because Solr
    # has the 'shasum' field set as a unique key.  (Non-symbolized string hash
    # keys?)
    raise ActiveRecord::RecordNotFound unless solr_response.has_key? "response"
    raise ActiveRecord::RecordNotFound unless solr_response["response"].has_key? "numFound"
    raise ActiveRecord::RecordNotFound if solr_response["response"]["numFound"] == 0
    raise ActiveRecord::RecordNotFound unless solr_response["response"].has_key? "docs"
    
    # Get term vectors, if we're full-text
    term_vectors = term_list = nil
    if fulltext and solr_response.has_key? "termVectors"
      # The response format here is incredibly arcane and nearly useless,
      # turn it into something worthwhile
      tvec_array = solr_response["termVectors"][1][3]
      term_vectors = {}
      
      1.step(tvec_array.length, 2) do |i|
        term = tvec_array[i-1]
        attr_array = tvec_array[i]
        hash = {}
        
        1.step(attr_array.length, 2) do |j|
          key = attr_array[j-1]
          val = attr_array[j]
          
          case key
          when 'tf'
            hash[:tf] = Integer(val)
          when 'offsets'
            hash[:offsets] = []
            3.step(val.length, 4) do |k|
              s = Integer(val[k-2])
              e = Integer(val[k])
              hash[:offsets] << (s...e)
            end
          when 'positions'
            hash[:positions] = []
            1.step(val.length, 2) do |k|
              p = Integer(val[k])
              hash[:positions] << p
            end
          when 'df'
            hash[:df] = Float(val)
          when 'tf-idf'
            hash[:tfidf] = Float(val)
          end
        end
        
        term_vectors[term] = hash
      end
    end
    
    { :document => Document.new(solr_response["response"]["docs"][0], term_vectors),
      :query_time => Float(solr_response["responseHeader"]["QTime"]) / 1000.0 }
  end
  
  # Look up an array of documents from the given parameters structure.
  # Recognized here are the following:
  #
  #   params[:q] => Solr query string
  #   params[:fq][] => Solr faceted query (an array)
  #   params[:precise] => If true, send query through Solr syntax, else
  #     the Dismax parser
  #   params[:authors] => Search query for authors
  #   params[:title] => Search query for title{,_search}
  #   params[:title_type] => (exact|fuzzy) Search on title, or title_search?
  #   params[:journal] => Search query for journal{,_search}
  #   params[:journal_type] => (exact|fuzzy) Search on journal, or 
  #     journal_search?
  #   params[:year_start] => Start year for year range
  #   params[:year_end] => End year for year range
  #   params[:volume] => Search query for volume
  #   params[:number] => Search query for number
  #   params[:pages] => Search query for pages
  #   params[:fulltext] => Search query for fulltext{,search}
  #   params[:fulltext_type] => (exact|fuzzy) Search on fulltext, or
  #     fulltext_search?
  #
  # This returns an empty array on failure, and will not throw except in 
  # dire circumstances.
  def self.search(params)
    solr = RSolr.connect :url => APP_CONFIG['solr_server_url']
    
    params.delete_if { |k, v| v.blank? }
    query_params = { :fq => params[:fq] }
    
    if params.has_key? :precise
      query_params[:qt] = "precise"
      query_params[:q] = "#{params[:q]} "
      
      %W(authors volume number pages).each do |f|
        query_params[:q] += " #{f}:(#{params[f.to_sym]})" if params[f.to_sym]
      end
      
      %W(title journal fulltext).each do |f|
        field = f
        field += "_search" if params[(f + "_type").to_sym] and params[(f + "_type").to_sym] == "fuzzy"
        query_params[:q] += " #{field}:(#{params[f.to_sym]})" if params[f.to_sym]
      end
      
      # Year has to be handled separately for range support
      if params[:year_start] or params[:year_end]
        year = params[:year_start]
        year ||= params[:year_end]
        if params[:year_start] and params[:year_end]
          year = "[#{params[:year_start]} TO #{params[:year_end]}]"
        end
        
        query_params[:q] += " year:(#{year})"
      end
      
      # If there's still no query, return all documents
      query_params[:q].strip!
      if query_params[:q].empty?
        query_params[:q] = "*:*"
      end
    else
      if not params.has_key? :q
        query_params[:q] = "*:*"
        query_params[:qt] = "precise"
      else
        query_params[:q] = params[:q]
      end
    end
    
    # See the note on solr.get in self.find
    solr_response = solr.get('select', :params => query_params)
    if solr_response["response"] or solr_response["response"]["docs"]
      return []
    end
    
    # Process the facet information
    facets = nil
    if solr_response["facet_counts"]
      facets = {}
      solr_facets = solr_response["facet_counts"]
      
      # The "year" facets are handled as separate queries
      if solr_facets["facet_queries"]
        facets[:year] = {}
        solr_facets["facet_queries"].each do |k, v|
          decade = k.slice(6..-1).split[0]
          decade = "1790" if decade == "*"
          facets[:year][decade] = v
        end
      end
      
      # The other fields are easier
      if solr_facets["facet_fields"]
        { "authors_facet" => :author, "journal_facet" => :journal }.each do |s, f|
          if solr_facets["facet_fields"][s]
            facets[f] = {}
            1.step(solr_facets["facet_fields"][s].length, 2) do |i|
              facets[f][solr_facets["facet_fields"][s][i-1]] = solr_facets["facet_fields"][s][i]
            end
          end
        end
      end
    end
    
    { :documents => solr_response["response"]["docs"].collect { |doc| Document.new doc },
      :query_time => Float(solr_response["responseHeader"]["QTime"]) / 1000.0,
      :facets => facets }
  end
  
  # Initialize a new document from the provided Solr document result.
  #
  #   doc = Document.new(solr_response["response"]["docs"][0])
  #
  # If you want the document to contain term vectors, you
  # can pass those in, otherwise they will be nil by default.
  def initialize(solr_doc, term_vectors = nil)
    %W(shasum doi authors title journal year volume number pages fulltext).each do |k|
      if solr_doc[k]
        instance_variable_set("@#{k}", solr_doc[k])
      else
        instance_variable_set("@#{k}", "")
      end
    end
    
    @term_vectors = term_vectors
  end
  
  # Return the document's SHA-1 sum, which will function as a URL parameter.
  # It's pre-sanitized for our convenience, all characters can appear in
  # URLs.
  def to_param
    shasum
  end  
  
  

  # Glue for making us act like an ActiveModel object
  extend ActiveModel::Naming
  
  def to_model
    self
  end
  
  def valid?()      true end
  def new_record?() true end
  def destroyed?()  true end
  
  def errors
    obj = Object.new
    def obj.[](key) [] end
    def obj.full_messages() [] end
    obj
  end
end

