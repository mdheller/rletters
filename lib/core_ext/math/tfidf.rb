# frozen_string_literal: true

# Ruby's standard Math module
module Math
  # Compute the term frequency-inverse document frequency for a term
  #
  # @param [Integer] tf The frequency of this term in the document
  # @param [Integer] df The number of documents containing this term
  # @param [Integer] num_docs The number of documents in the corpus
  # @return [Float] The term frequency-inverse document frequency
  # rubocop:disable UncommunicativeMethodParamName
  def self.tfidf(tf, df, num_docs)
    # Bail out with zero if there's any funny business
    return 0 unless tf&.>(0) && df&.>(0) && num_docs&.>(0)

    tf * Math.log10(num_docs.to_f / df.to_f)
  end
  # rubocop:enable UncommunicativeMethodParamName
end
