ActiveAdmin.register Loan do
  permit_params :amount, :interest_rate, :state, :user_id
  
  actions :all, except: [:new, :create]

  index do
    selectable_column
    id_column
    column :amount
    column :interest_rate
    column :state
    column :user
    column :created_at
    actions
  end

  filter :amount
  filter :interest_rate
  filter :state, as: :select, collection: Loan.states
  filter :user
  filter :admin
  filter :created_at

  form do |f|
    f.inputs "Loan Details" do
      f.input :user, as: :select, collection: User.all.map { |u| [u.email, u.id] }
      f.input :amount
      f.input :interest_rate
      f.input :state, as: :select, collection: Loan.states.keys
    end
    f.actions
  end

  show do
    attributes_table do
      row :user
      row :amount
      row :interest_rate
      row :state
      row :created_at
      row :updated_at
    end
  end

  member_action :approve, method: :put do
    loan = Loan.find(params[:id])
    loan.update(state: :approved)
    CalculateInterestJob.perform_later(loan.id)
    redirect_to admin_loan_path(loan), notice: "Loan approved and interest adjusted!"
  end

  member_action :reject, method: :put do
    loan = Loan.find(params[:id])
    loan.update(state: :rejected)
    redirect_to admin_loan_path(loan), notice: "Loan rejected!"
  end

  member_action :waiting_for_adjustment_acceptance, method: :put do
    loan = Loan.find(params[:id])
    loan.update(state: :waiting_for_adjustment_acceptance)
    CalculateInterestJob.perform_later(loan.id)
    redirect_to admin_loan_path(loan), notice: "Loan approved and interest adjusted!"
  end

  action_item :approve, only: :show do
    link_to 'Approve Loan', approve_admin_loan_path(loan), method: :put if loan.requested?
  end

  action_item :reject, only: :show do
    link_to 'Reject Loan', reject_admin_loan_path(loan), method: :put if loan.requested?
  end

  action_item :waiting_for_adjustment_acceptance, only: :show do
    link_to 'Waiting for readjustment Acceptance', reject_admin_loan_path(loan), method: :put if loan.requested?
  end
end
