require "application_system_test_case"

class AdjustmentsTest < ApplicationSystemTestCase
  setup do
    @adjustment = adjustments(:one)
  end

  test "visiting the index" do
    visit adjustments_url
    assert_selector "h1", text: "Adjustments"
  end

  test "should create adjustment" do
    visit adjustments_url
    click_on "New adjustment"

    fill_in "Amount", with: @adjustment.amount
    fill_in "Interest rate", with: @adjustment.interest_rate
    fill_in "Loan", with: @adjustment.loan_id
    click_on "Create Adjustment"

    assert_text "Adjustment was successfully created"
    click_on "Back"
  end

  test "should update Adjustment" do
    visit adjustment_url(@adjustment)
    click_on "Edit this adjustment", match: :first

    fill_in "Amount", with: @adjustment.amount
    fill_in "Interest rate", with: @adjustment.interest_rate
    fill_in "Loan", with: @adjustment.loan_id
    click_on "Update Adjustment"

    assert_text "Adjustment was successfully updated"
    click_on "Back"
  end

  test "should destroy Adjustment" do
    visit adjustment_url(@adjustment)
    click_on "Destroy this adjustment", match: :first

    assert_text "Adjustment was successfully destroyed"
  end
end
