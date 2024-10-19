class WalletsController < InheritedResources::Base

  private

    def wallet_params
      params.require(:wallet).permit(:balance, :user_id)
    end

end
