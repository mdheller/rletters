# frozen_string_literal: true

require 'test_helper'

# Mock job class for the workflow controller
class WorkflowJob < ApplicationJob
  def perform(task); end

  def self.create_task(dataset, finished, args = {})
    task = FactoryBot.create(:task, args.merge(dataset: dataset,
                                               finished_at: finished,
                                               job_type: 'WorkflowJob'))

    WorkflowJob.perform_later(task)

    task
  end
end

class WorkflowControllerTest < ActionDispatch::IntegrationTest
  test 'should get index when logged in' do
    sign_in create(:user)

    get workflow_url

    assert_response :success
  end

  test 'should get index when not logged in' do
    get workflow_url

    assert_response :success
  end

  test 'should get index if Solr fails' do
    stub_request(:any, /(127\.0\.0\.1|localhost)/).to_timeout

    get workflow_url

    assert_response :success
  end

  test 'should get info' do
    user = create(:user)
    sign_in user

    get workflow_info_url(class: 'ArticleDatesJob')

    assert_response :success
  end

  test 'should get start' do
    user = create(:user)
    sign_in user

    get workflow_start_url

    assert_response :success
  end

  test 'should get destroy' do
    user = create(:user, workflow_active: true,
                         workflow_class: 'ArticleDatesJob')
    sign_in user
    dataset = create(:dataset, name: 'Test Dataset', user: user)
    user.workflow_datasets = [dataset.to_param]
    user.save

    get workflow_destroy_url

    user.reload
    refute user.workflow_active
    assert_nil user.workflow_class
    assert_empty user.workflow_datasets
  end

  test 'should get activate with no datasets' do
    user = create(:user)
    sign_in user

    get workflow_activate_url(class: 'ArticleDatesJob')

    user.reload
    assert user.workflow_active
    assert_equal 'ArticleDatesJob', user.workflow_class
    assert_empty user.workflow_datasets
  end

  test 'should get activate and link a dataset' do
    user = create(:user)
    sign_in user
    dataset = create(:dataset, name: 'Test Dataset', user: user)

    get workflow_activate_url(class: 'ArticleDatesJob',
                              link_dataset_id: dataset.to_param)

    user.reload
    assert user.workflow_active
    assert_equal 'ArticleDatesJob', user.workflow_class
    assert_equal [dataset.to_param], user.workflow_datasets
  end

  test 'should fail when unlinking an invalid dataset' do
    user = create(:user, workflow_active: true,
                         workflow_class: 'ArticleDatesJob')
    sign_in user
    dataset = create(:dataset, name: 'Test Dataset', user: user)
    user.workflow_datasets = [dataset.to_param]
    user.save

    get workflow_activate_url(class: 'ArticleDatesJob',
                              unlink_dataset_id: '999')

    assert_response 404
  end

  test 'should get activate and unlink one dataset' do
    user = create(:user, workflow_active: true,
                         workflow_class: 'ArticleDatesJob')
    sign_in user
    dataset = create(:dataset, name: 'Test Dataset', user: user)
    user.workflow_datasets = [dataset.to_param]
    user.save

    get workflow_activate_url(class: 'ArticleDatesJob',
                              unlink_dataset_id: dataset.to_param)

    user.reload
    assert_empty user.workflow_datasets
  end

  test 'should get activate and unlink one of two datasets' do
    user = create(:user, workflow_active: true,
                         workflow_class: 'ArticleDatesJob')
    sign_in user
    dataset = create(:dataset, name: 'Test Dataset', user: user)
    dataset2 = create(:dataset, user: user)
    user.workflow_datasets = [dataset.to_param, dataset2.to_param]
    user.save

    get workflow_activate_url(class: 'CraigZetaJob',
                              unlink_dataset_id: dataset2.to_param)

    user.reload
    assert_equal [dataset.to_param], user.workflow_datasets
  end

  test 'should get fetch' do
    sign_in create(:user)

    get workflow_fetch_url

    assert_response :success
  end

  test 'should terminate when asked to via fetch' do
    user = create(:user)
    user2 = create(:user)
    sign_in user

    dataset = create(:dataset, user: user, name: 'Enabled')
    dataset2 = create(:dataset, user: user2, name: 'OtherUser')

    finished = WorkflowJob.create_task(dataset, Time.current)
    pending = WorkflowJob.create_task(dataset, nil)
    working = WorkflowJob.create_task(dataset, nil, progress: 0.3)
    failed = WorkflowJob.create_task(dataset, nil, failed: true)

    other = WorkflowJob.create_task(dataset2, Time.current)

    get workflow_fetch_url(terminate: true)

    # Delete all the finished or pending tasks
    refute Datasets::Task.exists?(pending.id)
    refute Datasets::Task.exists?(working.id)
    refute Datasets::Task.exists?(failed.id)

    # Leave everything else alone
    assert Datasets::Task.exists?(finished.id)
    assert Datasets::Task.exists?(other.id)

    assert_redirected_to root_url
    refute_nil flash[:alert]
  end

  test 'should get fetch with XHR' do
    sign_in create(:user)

    get workflow_fetch_url, xhr: true

    assert_response :success
    refute_includes @response.body, '<html'
  end
end
