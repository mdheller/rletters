# -*- encoding : utf-8 -*-
require 'spec_helper'

describe "datasets/show.html" do
  
  fixtures :users, :datasets, :dataset_entries
  
  before(:each) do
    @user = users(:john)
    session[:user_id] = users(:john).to_param
    assign(:dataset, datasets(:one))
    
    params[:id] = datasets(:one).to_param
  end
  
  it 'shows the number of dataset entries' do
    render
    rendered.should contain('Number of documents: 10')
  end
  
  it 'shows pending analysis tasks' do
    task = AnalysisTask.new({ :name => 'test', :dataset => datasets(:one), :job_type => 'ExportCitations' })
    task.save
    render
    
    rendered.should have_selector("li[data-theme=e]", :content => '1 analysis task pending for this dataset...')
  end
  
  context 'with completed analysis tasks' do
    before(:each) do
      @task = AnalysisTask.new({ :name => 'test', :dataset => datasets(:one), :job_type => 'ExportCitations' })
      @task.finished_at = Time.zone.now
      @task.save
      render      
    end
    
    it 'shows the name of the job' do
      rendered.should contain("“test” Complete")      
    end
    
    it 'shows a link to download the results' do
      expected = url_for(:controller => 'datasets', :action => 'task_download', 
        :id => datasets(:one).to_param, :task_id => @task.to_param)    
      rendered.should have_selector("a[href='#{expected}']")      
    end
    
    it 'shows a link to delete the task' do
      expected = url_for(:controller => 'datasets', :action => 'task_destroy', 
        :id => datasets(:one).to_param, :task_id => @task.to_param)    
      rendered.should have_selector("a[href='#{expected}']")            
    end
  end
  
  context 'with failed analysis tasks' do
    before(:each) do
      task = AnalysisTask.new({ :name => 'test', :dataset => datasets(:one), :job_type => 'ExportCitations' })
      task.failed = true
      task.save
      render
    end
    
    it 'shows failed analysis tasks' do
      rendered.should contain('1 analysis task failed for this dataset!')
    end
    
    it 'shows a link to clear failed analysis tasks' do
      rendered.should have_selector("a[href='#{dataset_path(datasets(:one), :clear_failed => true)}']")
    end
  end
  
  it 'shows the create-task markup' do
    render
    rendered.should contain('Export dataset as citations')
  end
  
end