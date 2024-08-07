ActiveAdmin.register User do
  permit_params :username, :email, :first_name, :last_name, :password, :password_confirmation, address_attributes: [:id, :street, :city, :province_id, :postal_code, :_destroy]

  index do
    selectable_column
    id_column
    column :username
    column :email
    column :first_name
    column :last_name
    column 'Street' do |user|
      user.address.present? ? user.address.street : "No address"
    end
    column 'City' do |user|
      user.address.present? ? user.address.city : "No address"
    end
    column 'Province' do |user|
      user.address.present? ? user.address.province&.name : "No address"
    end
    column 'Postal Code' do |user|
      user.address.present? ? user.address.postal_code : "No address"
    end
    column 'Past Orders' do |user|
      link_to 'View Orders', admin_orders_path(q: { user_id_eq: user.id })
    end
    actions
  end

  show do
    attributes_table do
      row :username
      row :email
      row :first_name
      row :last_name
      row :created_at
      row :updated_at
      row :address do |user|
        if user.address.present?
          div do
            "Street: #{user.address.street}"
          end
          div do
            "City: #{user.address.city}"
          end
          div do
            "Province: #{user.address.province&.name}"
          end
          div do
            "Postal Code: #{user.address.postal_code}"
          end
        else
          "No Address"
        end
      end
    end
    active_admin_comments
  end

  form do |f|
    f.inputs 'User Details' do
      f.input :username
      f.input :email
      f.input :first_name
      f.input :last_name
      f.input :password, hint: 'Leave blank if you do not want to change the password'
      f.input :password_confirmation, hint: 'Leave blank if you do not want to change the password'
    end

    f.inputs 'Address' do
      f.semantic_fields_for :address do |address_fields|
        address_fields.input :street, label: 'Street'
        address_fields.input :city, label: 'City'
        address_fields.input :province_id, as: :select, collection: Province.all.collect { |p| [p.name, p.id] }, label: 'Province'
        address_fields.input :postal_code, label: 'Postal Code'
      end
    end

    f.actions
  end

  controller do
    def update
      # If password fields are blank, remove them from the params
      if params[:user][:password].blank?
        params[:user].delete(:password)
        params[:user].delete(:password_confirmation)
      end

      # Handle address attributes properly
      if params[:user][:address_attributes].present?
        params[:user][:address_attributes].delete(:_destroy) if params[:user][:address_attributes][:id].blank?
      end

      super
    end

    def create
      @user = User.new(permitted_params[:user])
      if @user.save
        redirect_to admin_user_path(@user), notice: "User was successfully created."
      else
        render :new
      end
    end

    private

    def permitted_params
      params.require(:user).permit(:username, :email, :first_name, :last_name, :password, :password_confirmation, address_attributes: [:id, :street, :city, :province_id, :postal_code, :_destroy])
    end
  end

  filter :username_cont, as: :string, label: 'Username'
end
