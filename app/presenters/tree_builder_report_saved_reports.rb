class TreeBuilderReportSavedReports < TreeBuilderReportReportsClass
  private

  def tree_init_options(_tree_name)
    {
      :full_ids => true,
      :leaf     => 'MiqReportResult'
    }
  end

  def set_locals_for_render
    locals = super
    locals.merge!(:autoload => true)
  end

  def root_options
    {
      :text    => t = _("All Saved Reports"),
      :tooltip => t
    }
  end

  # Get root nodes count/array for explorer tree
  def x_get_tree_roots(_count_only, _options)
    u = User.current_user
    user_groups = u.report_admin_user? ? nil : u.miq_groups
    having_report_results(user_groups).pluck(:name, :id).sort.map do |name, id|
      {:id => id.to_i.to_s, :text => name, :icon => 'fa fa-file-text-o', :tip => name}
    end
  end

  def x_get_tree_custom_kids(object, count_only, _options)
    if count_only
      1
    else
      result_id        = object[:id].split('-').last
      task_state_arel  = MiqTask.arel_table[:state]
                                .as(TreeNode::MiqReportResult::STATE_ATTRIBUTE)
      task_status_arel = MiqTask.arel_table[:status]
                                .as(TreeNode::MiqReportResult::STATUS_ATTRIBUTE)

      MiqReportResult.with_current_user_groups_and_report(result_id)
                     .select(:id, :name, :last_run_on)
                     .select(task_state_arel, task_status_arel)
                     .joins(:miq_task)
                     .order("last_run_on DESC").tap {|s| puts; puts; puts s.to_sql; puts; puts; }
                     .to_a
    end
  end

  # Scope on reports that have report results.
  def having_report_results(miq_groups)
    miq_group_relation = MiqReport.joins(:miq_report_results).distinct
    if miq_groups.nil? # u.report_admin_user?
      miq_group_relation.where.not(:miq_report_results => {:miq_group_id => nil})
    else
      miq_group_relation.where(:miq_report_results => {:miq_group_id => miq_groups})
    end
  end
end
