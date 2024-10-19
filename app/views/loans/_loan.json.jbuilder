json.extract! loan, :id, :amount, :interest_rate, :state, :user_id, :created_at, :updated_at
json.url loan_url(loan, format: :json)
