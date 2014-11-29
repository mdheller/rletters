# -*- encoding : utf-8 -*-
require 'spec_helper'
require 'nokogiri'

RSpec.describe RLetters::Documents::Serializers::RDFXML do

  context 'with a single document' do
    before(:example) do
      @doc = build(:full_document)
      @xml = Nokogiri::XML::Document.parse(described_class.new(@doc).serialize)
    end

    it 'creates an rdf root element' do
      expect(@xml.root.name).to eq('rdf')
    end

    it 'includes a single description element' do
      expect(@xml.css('Description').size).to eq(1)
    end

    it 'includes a few of the important Dublin Core elements' do
      expect(@xml.at_css('dc|title').content).to eq(@doc.title)
      expect(@xml.at_css('dc|relation').content).to eq(@doc.journal)
      expect(@xml.at_css('dc|type').content).to eq('Journal Article')
    end
  end

  context 'with an array of documents' do
    before(:example) do
      doc = build(:full_document)
      doc2 = build(:full_document, uid: 'doi:10.2345/6789')

      @docs = [doc, doc2]
      @xml = Nokogiri::XML::Document.parse(described_class.new(@docs).serialize)
    end

    it 'includes two description elements' do
      expect(@xml.css('Description').size).to eq(2)
    end
  end

end
