require 'application_system_test_case'

class SolrQueryTest < ApplicationSystemTestCase
  test 'run an author search via Solr' do
    visit '/search/advanced'
    click_link 'Search with Solr syntax'
    fill_in 'q', with: 'authors:"Hotez" OR journal:"Gutenberg"'
    click_button 'Perform Solr query'

    assert_selector 'table.document-list tr td'
    assert_text(/52 articles /i)
  end
end