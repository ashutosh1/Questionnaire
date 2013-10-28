module UsersHelper

  def attr_checked?(form_obj)
    return true if form_obj.object.persisted?
    if params[:user] && params[:user][:roles_users_attributes]
      params[:user][:roles_users_attributes].each do |k, v|
        return v["_destroy"] == "0" if form_obj.object.role_id == v["role_id"].to_i
      end  
    end
  end

end
