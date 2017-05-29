
module AnalysisJobHelper
  def test_should_call_finish_and_send_email
    mailer_ret = stub
    mailer_ret.expects(:deliver_later).with(queue: :maintenance)

    UserMailer.expects(:job_finished_email).returns(mailer_ret)

    perform

    refute_nil @task.reload.finished_at
  end
end