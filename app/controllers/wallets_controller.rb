class WalletsController < InheritedResources::Base
  # skip_before_action :authenticate_user!, except: [:create]
  private

    def wallet_params
      params.require(:wallet).permit(:balance, :user_id)
    end

end