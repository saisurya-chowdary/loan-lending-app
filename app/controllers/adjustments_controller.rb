class AdjustmentsController < InheritedResources::Base

  private

    def adjustment_params
      params.require(:adjustment).permit(:loan_id, :amount, :interest_rate)
    end

end
