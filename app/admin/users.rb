ActiveAdmin.register User do
  permit_params :email, :admin

  index do
    selectable_column
    id_column
    column :email
    column :admin
    actions
  end

  filter :id
  filter :email
  filter :admin
  filter :created_at
  filter :updated_at

  form do |f|
    f.inputs do
      f.input :email
      f.input :admin
    end
    f.actions
  end
end
