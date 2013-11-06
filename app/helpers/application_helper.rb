module ApplicationHelper
  def mark_required(object, attribute)
    "*" if object.class.validators_on(attribute).map(&:class).include? ActiveRecord::Validations::PresenceValidator
  end

  def class_name controller, action, type=nil
    if type
      "highlighted" if (params[:controller] == controller && params[:action] == action && params[:type] == type)
    else
      "highlighted" if (params[:controller] == controller && params[:action] == action && !params[:type])
    end
  end

end
