namespace 'db' do
  desc "Loading all models and their methods in permissions table."
  task(:add_permissions => :environment) do
    arr = []
    controllers = Dir.new("#{Rails.root}/app/controllers").entries
    controllers.each do |entry|
      if entry =~ /_controller/
        arr << entry.camelize.gsub('.rb', '').constantize
      end
    end

    arr.each do |controller|
      if controller.permission
        write_permission(controller.permission, "manage", 'manage', 'manage all action in this controller') 
        controller_name = controller.permission.to_s.underscore.pluralize
        controller.action_methods.each do |method|
          if method =~ /^([A-Za-z\d*]+)+([\w]*)+([A-Za-z\d*]+)$/ #add_user, add_user_info, Add_user, add_User
            name, cancan_action, action_desc = eval_cancan_action(controller_name, method)
            write_permission(controller.permission, cancan_action, name, action_desc)  
          end
        end
      end
    end
  end
end

def eval_cancan_action(controller_name, action)
  case action.to_s
  when "new", "create"
    name = I18n.t(controller_name + ".new.title")
    cancan_action = "create"
    action_desc = name 
  when "edit", "update"
    name = I18n.t(controller_name + ".edit.title")
    cancan_action = "edit"
    action_desc = name 
  when "delete", "destroy"
    name = I18n.t(controller_name + ".destroy.title")
    cancan_action = "destroy"
    action_desc = name 
  else
    name = I18n.t(controller_name + "." + action.to_s + ".title")
    cancan_action = action.to_s
    action_desc = name 
  end
  return name, cancan_action, action_desc
end


def write_permission(class_name, cancan_action, name, description)
  permission  = Permission.where(["subject_class = ? and action = ?", class_name, cancan_action]).first 
  unless permission
    permission = Permission.new
    permission.subject_class =  class_name
    permission.action = cancan_action
    permission.name = name
    permission.description = description
    permission.save
  else
    permission.name = name 
    permission.description = description
    permission.save
  end
end
