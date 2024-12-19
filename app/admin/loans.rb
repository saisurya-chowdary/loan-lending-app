ActiveAdmin.register Loan do
  permit_params :amount, :interest_rate, :state
  
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
    redirect_to admin_loan_path(loan), notice: "Loan is approved and user confirmation awaited"
  end

  member_action :reject, method: :put do
    loan = Loan.find(params[:id])
    loan.update(state: :rejected)
    redirect_to admin_loan_path(loan), notice: "Loan rejected!"
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

  controller do
    
    def edit
      @loan = Loan.find_by(id: params[:id])
      if @loan.state == "open" || @loan.state == "closed"
        flash[:warning] = "Loan is already fulfilled. You cannot edit it now." 
        redirect_to admin_loans_path
      end
    end
    def update
      @loan = Loan.find_by(id: params[:id])
      if @loan.amount.to_f != permitted_params[:loan][:amount].to_f || 
        @loan.interest_rate.to_f != permitted_params[:loan][:interest_rate].to_f

        @loan.update(amount: permitted_params[:loan][:amount], interest_rate: permitted_params[:loan][:interest_rate])
        flash[:success] = "Loan's now waiting for adjustment acceptance" 
        @loan.update(state: "waiting_for_adjustment_acceptance")
        redirect_to admin_loan_path(@loan)
      elsif @loan.update(permitted_params[:loan])
        flash[:success] = "Loan details are updated successfully" 
        redirect_to admin_loan_path(@loan)
      else
        flash[:error] = "Error updating Loans #{@loan.errors.full_messages} "
      end
    end
  end
end
