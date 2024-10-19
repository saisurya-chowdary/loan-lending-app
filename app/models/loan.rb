class Loan < ApplicationRecord
  belongs_to :user
  belongs_to :admin_user, optional: true
  has_many :adjustments

  enum state: {
    requested: 0,
    approved: 1,
    open: 2,
    closed: 3,
    rejected: 4,
    waiting_for_adjustment_acceptance: 5,
    readjustment_requested: 6
  }
  
  validates :amount, presence: true
  validates :interest_rate, presence: true

  after_initialize :set_default_state, if: :new_record?
  after_create :schedule_interest_calculation

  def set_default_state
    self.state ||= :requested
  end

  def self.ransackable_attributes(auth_object = nil)
    ["amount", "created_at", "id", "interest_rate", "state", "updated_at", "user_id"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["user", "admin"]
  end

  def update_interest_rate(new_interest_rate)
    if self.interest_rate != new_interest_rate
      self.interest_rate = new_interest_rate
      self.state = :readjustment_requested
      save!
    end
  end

  private

  def schedule_interest_calculation
    CalculateInterestJob.set(wait: 5.minutes).perform_later(self.id)
  end
end
