class CalculateInterestJob < ApplicationJob
  queue_as :default

  def perform(loan_id)
    loan = Loan.find(loan_id)
    if loan.state == "approved"
      interest_amount = (loan.amount * loan.interest_rate / 100)

        loan.update(total_amount_due: (loan.total_amount_due || loan.amount) + interest_amount)
    end

    CalculateInterestJob.set(wait: 5.seconds).perform_later(loan_id)
  end
end
