class CalculateInterestJob < ApplicationJob
  queue_as :default

  def perform
    loans = Loan.where(state: 'open')
    if loans.present? 
      loans.each do |loan|
        interest_amount = (loan.amount * loan.interest_rate / 100)

          loan.update(total_amount_due: (loan.total_amount_due || loan.amount) + interest_amount)
      end
    else
      puts "No loans are opened yet to calculate interest"
    end
  end
end
