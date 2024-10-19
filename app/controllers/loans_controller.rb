class LoansController < InheritedResources::Base
  before_action :authenticate_user!
  before_action :authorize_admin, only: [:approve, :reject, :adjust]
  before_action :set_loan, only: [:approve, :reject, :adjust, :update_status, :repay]

  def index
    if current_user.admin?
      @loans = Loan.all
    else
      @loans = current_user.loans
    end
  end

  def new
    @loan = Loan.new
  end

  def create
    @loan = current_user.loans.new(loan_params)
    if @loan.save
      redirect_to loans_path, notice: 'Loan requested successfully.'
    else
      render :new
    end
  end

  def approve
    loan.update(state: :approved)
    redirect_to admin_dashboard_path, notice: 'Loan approved.'
  end

  def reject
    loan.update(state: :rejected)
    redirect_to admin_dashboard_path, notice: 'Loan rejected.'
  end

  def adjust
    adjustment = loan.adjustments.create!(amount: params[:amount], interest_rate: params[:interest_rate])
    
    loan.update_interest_rate(params[:interest_rate])
    
    redirect_to admin_dashboard_path, notice: 'Loan adjusted.'
  end

  def update_status
    if @loan.user == current_user && @loan.state == 'readjustment_requested'
      @loan.update(state: :waiting_for_adjustment_acceptance)
      redirect_to loans_path, notice: 'Loan status updated successfully.'
    else
      redirect_to loans_path, alert: 'You are not authorized to update this loan status.'
    end
  end

  def repay
    amount_to_repay = loan.amount + loan.interest
    if current_user.wallet.balance >= amount_to_repay
      current_user.wallet.debit(amount_to_repay)
      loan.user.wallet.credit(amount_to_repay)
      loan.update(state: :closed)
    else
      loan.user.wallet.debit(loan.user.wallet.balance)
      loan.update(state: :closed)
    end
  end

  private

  def loan_params
    params.require(:loan).permit(:amount, :interest_rate, :user_id)
  end

  def set_loan
    @loan = Loan.find(params[:id])
  end

  def authorize_admin
    redirect_to root_path, alert: 'Access denied.' unless current_user.admin?
  end
end
