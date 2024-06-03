module TasksHelper
    def task_editable?(task)
        assigned_to_current_user = task.assignments.exists?(assigned_to: Current.user)
        created_by_current_user = task.user == Current.user
        Current.user.admin? || assigned_to_current_user || created_by_current_user
      end
      

    def task_destroyable?(task)
        Current.user.admin? || task.user == Current.user
    end
end
