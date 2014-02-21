require_dependency "customer_authentify/application_controller"

module CustomerAuthentify
  class UsersController < ApplicationController
    
    def index
    end
    
    def new
      @title = t("New User")
      @user = Authentify::User.new
      @customer_id = params[:customer_id]
      @user.user_levels.build
      @user.user_roles.build
    end
  
    def create
      #re-assign the value to enforce only customer role id is entered.
      params[:user]['user_roles_attributes']['0']['role_definition_id'] = Authentify::RoleDefinition.where(name: 'customer').first.id.to_s
      params[:user]['user_levels_attributes']['0']['sys_user_group_id'] = Authentify::SysUserGroup.where(user_group_name: 'customer').first.id.to_s
      @user = Authentify::User.new(params[:user], :as => :admin)
      @user.last_updated_by_id = session[:user_id]
      if @user.save
        redirect_to URI.escape(SUBURI + "/view_handler?index=0&msg=Successfully Saved!")
      else
        flash.now[:error] = t('Data Error. Not Saved!')
        render 'new_customer_login'
      end
    end
    
    def edit
      @title = t("Update User")
      @user = Authentify::User.find_by_id(params[:id])
    end
  
    def update
      @user = Authentify::User.find_by_id(params[:id])     
      @user.last_updated_by_id = session[:user_id]
      if @user.update_attributes(params[:user], :as => :sales_update)
        redirect_to URI.escape(SUBURI + "/view_handler?index=0&msg=Successfully Updated!")
      else
        flash.now[:error] = t('Data Error. Not Updated!')
        render 'edit_customer_login'
      end     
    end

  end
end
