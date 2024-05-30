module TasksHelper
    def task_editable?(task)
        puts task.assigned_to, Current.user.id, "******************************"
        Current.user == task.user || Current.user == task.assigned_to || Current.user.admin?
    end

    def task_destroyable?(task)
        Current.user.admin? || task.user == Current.user
    end
end
