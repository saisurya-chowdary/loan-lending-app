class RepayLoanJob < ApplicationJob

    queue_as :default

    def perform
        open_loan_users = User.joins(:loans).where(loans: { state: 'open' }).distinct 
        if open_loan_users.present?
            open_loan_users.each do |current_user|
                open_loans = current_user.loans.where(state: 'open')
                if open_loans.present?
                    total_amount_to_repay = 0
                    open_loans.each do |loan|
                        total_amount_to_repay += loan.total_amount_due
                    end
                    puts total_amount_to_repay
                    if total_amount_to_repay > current_user.wallet.balance 
                        current_user.wallet.debit(total_amount_to_repay)
                        AdminUser.last.wallet.credit(total_amount_to_repay)
                        current_user.loans.update_all(state: 'closed')
                    end
                else
                    puts "There are no open loans yet for #{current_user.email}"
                end
            end
        else
            puts "No users are present with opened loans"
        end
    end
end