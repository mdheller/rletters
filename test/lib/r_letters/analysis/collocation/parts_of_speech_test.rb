require 'test_helper'
require_relative './collocation_tests'

class PartsOfSpeechTest < ActiveSupport::TestCase
  setup do
    @old_path = ENV['NLP_TOOL_PATH']
    ENV['NLP_TOOL_PATH'] = 'stubbed'

    words = build(:parts_of_speech)
    RLetters::Analysis::NLP.expects(:parts_of_speech).at_least_once.returns(words)
  end

  teardown do
    ENV['NLP_TOOL_PATH'] = @old_path
  end

  include CollocationTests
  run_common_tests(RLetters::Analysis::Collocation::PartsOfSpeech,
                   [:parts_of_speech])
end
