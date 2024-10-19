class CalculateInterestJob < ApplicationJob
  queue_as :default

  def perform(loan_id)
    loan = Loan.find(loan_id)

    interest_amount = (loan.amount * loan.interest_rate / 100)
    loan.update(total_amount_due: loan.amount + interest_amount)

    CalculateInterestJob.set(wait: 5.minutes).perform_later(loan_id)
  end
end
