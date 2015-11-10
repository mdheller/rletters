
module RLetters
  module Analysis
    module Network
      # A network graph
      #
      # This class allows for creating a network from a body of plain text.
      # The nodes are constructed from the text, and the edges from the
      # adjacency information.
      #
      # @!attribute dataset
      #   @return [Dataset] the text to analyze
      # @!attribute focal_word
      #   @return [String] if set, place this word at the center of the network
      # @!attribute gaps
      #   @return [Array<Integer>] the word window sizes to use to create the
      #     network.
      #
      #   The network is created by taking all adjacency information using
      #   sliding windows of the sizes specified in this parameter.  For
      #   example, the default value, which is `[2, 5]`, will result in the
      #   network being created from a two-word sliding window and a
      #   five-word sliding window.
      # @!attribute language
      #   @return [String] the language from which to take stop words
      # @!attribute progress
      #   @return [Proc] if set, a function to call with percentage of
      #     completion (one integer parameter)
      # @!attribute [r] nodes
      #   @return [Array<Node>] all nodes in the graph
      # @!attribute [r] edges
      #   @return [Array<Edge>] all edges in the graph
      class Graph
        include Virtus.model(strict: true, required: false, nullify_blank: true)

        attribute :dataset, Dataset, required: true
        attribute :focal_word, String
        attribute :gaps, Array[Integer], default: [2, 5]
        attribute :language, String, default: 'en'
        attribute :progress, Proc

        attribute :nodes, Array[Node], writer: :private
        attribute :edges, Array[Edge], writer: :private

        attribute :words, Array[String],
                  reader: :private, writer: :private
        attribute :words_stem, Array[String],
                  reader: :private, writer: :private
        attribute :focal_word_stem, String,
                  reader: :private, writer: :private
        attribute :stop_words, Array[String],
                  reader: :private, writer: :private

        # Create a network of adjacency information from the text.
        def initialize(*args)
          super(*args)

          # Save parameters
          if focal_word
            self.focal_word = focal_word.mb_chars.downcase.to_s
            self.focal_word_stem = focal_word.stem
          end

          # Extract the stop list if provided
          self.stop_words = []
          if language
            stop_list = ::Documents::StopList.find_by!(language: language)
            self.stop_words = stop_list.list.split
          end

          # Clear final attributes
          self.nodes = []
          self.edges = []

          # Create the word list from the provided dataset and stop words
          create_word_list

          # Run the analysis for each of the gaps
          gaps.each do |g|
            add_nodes_for_gap(g)
          end

          # Final progress tick
          progress && progress.call(100)
        end

        # Find a word by its id or its word coverage
        #
        # @param [Hash] options the find options
        # @option options [String] :id if set, find a node based on this value
        #   of its id
        # @option options [String] :stem synonym for `:id`
        # @option options [String] :word if set, find a node based on this
        #   unstemmed word
        # @return [Node] the requested node, or `nil` if not found
        def find_node(options)
          options[:id] = options.delete(:stem) if options[:stem]

          unless options[:word] || options[:id]
            fail ArgumentError, 'no find option specified'
          end

          if options[:word]
            word = options[:word].mb_chars.downcase.to_s
            nodes.find do |n|
              n.words.include?(word)
            end
          else
            id = options[:id].mb_chars.downcase.to_s
            nodes.find do |n|
              n.id == id
            end
          end
        end

        # Find the edge connecting the two specified nodes, if it exists
        #
        # Note that our edges are undirected, so the order of the parameters
        # `one` and `two` is not meaningful.
        #
        # @param [String] one the first node ID
        # @param [String] two the second node ID
        # @return [Edge] the edge connecting the two nodes, or `nil`
        def find_edge(one, two)
          edges.find do |e|
            (e.one == one && e.two == two) || (e.two == one && e.one == two)
          end
        end

        # Return the maximum edge weight in the graph
        #
        # @return [Integer] the maximum edge weight
        def max_edge_weight
          edges.map(&:weight).max
        end

        private

        # Create a list of words from the provided dataset
        #
        # This function fills in the `words` attributes and scrubs out any
        # words listed in `stop_words`.
        #
        # @return [void]
        def create_word_list
          # Create a list of lowercase, stemmed words
          progress && progress.call(1)
          enum = RLetters::Datasets::DocumentEnumerator.new(dataset: dataset,
                                                            fulltext: true)
          doc_words = enum.map do |doc|
            doc.fulltext.gsub(/[^A-Za-z ]/, '').mb_chars.downcase.to_s.split
          end

          # Remove stop words and stem
          progress && progress.call(17)
          self.words = doc_words.flatten - stop_words
          self.words_stem = words.map(&:stem)
        end

        # Add nodes and edges for a given gap
        #
        # This function adds nodes and edges to the graph for a given size of
        # sliding window.
        #
        # @param [Integer] gap the gap size to use
        # @return [void]
        def add_nodes_for_gap(gap)
          words.each_cons(gap).each_with_index do |gap_words, i|
            # Get the stemmed words to go with the un-stemmed words
            gap_words_stem = words_stem[i, gap]

            # Update progress meter
            if progress
              val = (i.to_f / (words.size - 1).to_f) * (66.0 / gaps.size)
              progress.call(val.to_i + 33)
            end

            # Cull based on focal word (stemmed) if present
            next if focal_word && !gap_words_stem.include?(focal_word_stem)

            # Find or create nodes for all of these words
            nodes = gap_words_stem.zip(gap_words).map do |w|
              find_or_add_node(*w)
            end

            nodes.combination(2).each do |pair|
              find_or_add_edge(pair[0].id, pair[1].id)
            end
          end
        end

        # Find a node and return it, or add it if needed
        #
        # @param [String] id the node id to add for
        # @param [String] word the word to add a node for
        # @return [Node] the new or existing node
        def find_or_add_node(id, word)
          node = find_node(id: id)
          if node
            node.words << word unless node.words.include?(word)
            node
          else
            nodes << Node.new(id: id, words: [word])
            nodes.last
          end
        end

        # Find an edge and increment its weight, or add it if needed
        #
        # @param [String] one the first node on the edge
        # @param [String] two the second node on the edge
        # @return [Edge] the new or existing edge
        def find_or_add_edge(one, two)
          edge = find_edge(one, two)
          if edge
            edge.weight += 1
            edge
          else
            edges << Edge.new(one: one, two: two, weight: 1)
            edges.last
          end
        end
      end
    end
  end
end
