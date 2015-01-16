module CustomerAuthentify
  module UsersHelper
    #before_filter load @customer
    def self.included(base)
      base.before_filter :load_record
    end
    
    def index_customer_login
      @title = t("Users")
      @users = params[:authentify_users][:model_ar_r]
      @users = @users.where(:customer_id => CustomerAuthentify.customer_class.where(:sales_id => session[:user_id]).pluck(:id))
      @users = @users.page(params[:page]).per_page(@max_pagination)
      @erb_code = find_config_const('user_index_customer_login_view', 'customer_authentify')
    end
    
    def new_customer_login
      @title = t("New User")
      @user = Authentify::User.new
      @user.user_levels.build
      @user.user_roles.build
      @erb_code = find_config_const('user_new_customer_login_view', 'customer_authentify')
    end
  
    def create_customer_login
      #re-assign the value to enforce only customer role id is entered.
      params[:user]['user_roles_attributes']['0']['role_definition_id'] = Authentify::RoleDefinition.where(name: 'customer').first.id.to_s
      params[:user]['user_levels_attributes']['0']['sys_user_group_id'] = Authentify::SysUserGroup.where(user_group_name: 'customer').first.id.to_s
      @user = Authentify::User.new(params[:user], :as => :admin)
      @user.last_updated_by_id = session[:user_id]
      if @user.save
        redirect_to URI.escape(SUBURI + "/view_handler?index=0&msg=Successfully Saved!")
      else
        @erb_code = find_config_const('user_new_customer_login_view', 'customer_authentify')
        flash.now[:error] = t('Data Error. Not Saved!')
        render 'new_customer_login'
      end
    end
    
    def edit_customer_login
      @title = t("Update User")
      @user = Authentify::User.find_by_id(params[:id])
      @erb_code = find_config_const('user_edit_customer_login_view', 'customer_authentify')
    end
  
    def update_customer_login
      @user = Authentify::User.find_by_id(params[:user][:id])
      @user.last_updated_by_id = session[:user_id]
      if @user.update_attributes(params[:user], :as => :sales_update)
        redirect_to URI.escape(SUBURI + "/view_handler?index=0&msg=Successfully Updated!")
      else
        @erb_code = find_config_const('user_edit_customer_login_view', 'customer_authentify')
        flash.now[:error] = t('Data Error. Not Updated!')
        render 'edit_customer_login'
      end     
    end
    
    protected
    def load_record
      @customer = CustomerAuthentify.customer_class.find_by_id(params[:customer_id]) if params[:customer_id].present?
    end
  end
end
