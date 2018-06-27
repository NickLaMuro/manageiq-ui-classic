class MiqReportResultDecorator < MiqDecorator
  STATE_ATTRIBUTE     = "task_state".freeze
  STATUS_ATTRIBUTE    = "task_status".freeze

  def status
    object = __getobj__
    report_status = if object.has_attribute?(STATUS_ATTRIBUTE) && object.has_attribute?(STATUS_ATTRIBUTE)
                      if object[STATE_ATTRIBUTE] == MiqTask::STATE_FINISHED
                        object[STATUS_ATTRIBUTE]
                      else
                        object[STATE_ATTRIBUTE]
                      end
                    else
                      object.miq_task.state_or_status
                    end
  end

  def fonticon
    case status
    when MiqTask::STATUS_ERROR
      'pficon pficon-error-circle-o'
    when MiqTask::STATE_FINISHED # never hit...
      'pficon pficon-ok'
    when MiqTask::STATE_ACTIVE
      'pficon pficon-running'
    when MiqTask::STATE_QUEUED
      'fa fa-play-circle-o'
    else
      'fa fa-arrow-right'
    end
  end
end
