module TreeNode
  class MiqReportResult < Node
    STATE_ATTRIBUTE     = "task_state".freeze
    STATUS_ATTRIBUTE    = "task_status".freeze
    GENERATING_STATUSES = [MiqTask::STATE_ACTIVE, MiqTask::STATE_QUEUED].freeze

    GENERATING_TEXT     = "Generating Report".freeze
    GENERATING_TOOLTIP  = "Generating Report for - %{report_name}".freeze
    ERROR_TEXT          = "Error Generating Report".freeze
    ERROR_TOOLTIP       = "Error Generating Report for %{report_name}".freeze

    set_attributes(:text, :tooltip, :expand) do
      expand = nil
      report_status = if @object.has_attribute?(STATUS_ATTRIBUTE) && @object.has_attribute?(STATUS_ATTRIBUTE)
                        if @object[STATE_ATTRIBUTE] == MiqTask::STATE_FINISHED
                          @object[STATUS_ATTRIBUTE]
                        else
                          @object[STATE_ATTRIBUTE]
                        end
                      else
                        @object.miq_task.state_or_status
                      end

      if @object.last_run_on.nil? && GENERATING_STATUSES.include?(report_status)
        text    = _(GENERATING_TEXT)
        tooltip = _(GENERATING_TOOLTIP) % {:report_name => @object.name}
      elsif @object.last_run_on.nil? && report_status == MiqTask::STATUS_ERROR
        text    = _(ERROR_TEXT)
        tooltip = _(ERROR_TOOLTIP) % {:report_name => @object.name}
        expand  = !!@options[:open_all]
      else
        text    = format_timezone(@object.last_run_on, Time.zone, 'gtl')
        tooltip = nil
      end
      [text, tooltip, expand]
    end
  end
end
