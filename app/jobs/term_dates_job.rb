
# Plot occurrences of a term in a dataset by year
class TermDatesJob < CSVJob
  # Export the date format data
  #
  # Like all view/multiexport jobs, this job saves its data out as a JSON
  # file and then sends it to the user in various formats depending on
  # user selectons.
  #
  # @param [String] user_id the user whose dataset we are to work on
  # @param [String] dataset_id the dataset to operate on
  # @param [String] task_id the task we're working from
  # @param [Hash] options parameters for this job
  # @option options [String] :term the focal word to analyze
  # @return [void]
  def perform(user_id, dataset_id, task_id, options)
    standard_options(user_id, dataset_id, task_id)

    # Get the counts and normalize if requested
    options.symbolize_keys!
    fail ArgumentError, 'Term for plotting not specified' unless options[:term]
    term = options[:term]
    analyzer = RLetters::Analysis::CountTermsByField.new(
      term,
      get_dataset(task_id),
      ->(p) { get_task(task_id).at(p, 100, t('.progress_computing')) })
    dates = analyzer.counts_for(:year)

    dates = dates.to_a
    dates.each { |d| d[0] = Integer(d[0]) }

    # Fill in zeroes for any years that are missing
    dates = Range.new(*(dates.map { |d| d[0] }.minmax)).each.map do |y|
      dates.assoc(y) || [y, 0]
    end

    csv = write_csv(task_id, nil, t('.subheader', term: term)) do |out|
      out << [Document.human_attribute_name(:year), t('.number_column')]
      dates.each do |d|
        out << d
      end
    end

    # Save out the data
    output = {
      data: dates,
      term: term,
      csv: csv,
      year_header: Document.human_attribute_name(:year),
      value_header: t('.number_column') }

    # Serialize out to JSON
    ios = StringIO.new(output.to_json)
    file = Paperclip.io_adapters.for(ios)
    file.original_filename = 'term_dates.json'
    file.content_type = 'application/json'

    task = get_task(task_id)
    task.result = file
    task.mark_completed
  end

  # We don't want users to download the JSON file
  def self.download?
    false
  end
end