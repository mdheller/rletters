require 'spec_helper'

RSpec.describe NetworkJob, type: :job do
  before(:example) do
    @user = create(:user)
    @dataset = create(:full_dataset, user: @user, entries_count: 0)
    @dataset.entries += [create(:entry, dataset: @dataset,
                                        uid: WORKING_UIDS[2])]
    @task = create(:task, dataset: @dataset)

    # The network code loads the English stop list
    @stop_list = create(:stop_list)
  end

  before(:each) do
    # Don't run the analyses
    mock = double(RLetters::Analysis::Network::Graph,
                  nodes: [], edges: [], max_edge_weight: 0)
    allow(RLetters::Analysis::Network::Graph).to receive(:new).and_return(mock)
  end

  it_should_behave_like 'an analysis job' do
    let(:job_params) { { word: 'disease' } }
  end

  describe '.download?' do
    it 'is false' do
      expect(described_class.download?).to be false
    end
  end

  describe '.num_datasets' do
    it 'is 1' do
      expect(described_class.num_datasets).to eq(1)
    end
  end

  context 'when all parameters are valid' do
    before(:example) do
      described_class.new.perform(
        @task,
        word: 'diseases')
      @task.reload
    end

    it 'names the task correctly' do
      expect(@task.name).to eq('Compute network of associated terms')
    end

    it 'creates good JSON' do
      data = JSON.load(@task.result.file_contents(:original))
      expect(data).to be_a(Hash)
    end

    it 'fills in some values' do
      hash = JSON.load(@task.result.file_contents(:original))
      expect(hash['name']).to eq('Dataset')
      expect(hash['word']).to eq('diseases')
    end
  end
end
