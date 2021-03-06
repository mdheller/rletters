# frozen_string_literal: true

# Helper methods for stubbing out HTTP queries
module StubConnectionHelper
  def stub_connection(url_or_regex, file)
    path = Rails.root.join('test', 'support', 'requests', "#{file}.curl")
    stub_request(:get, url_or_regex).to_return(IO.read(path))
  end
end
