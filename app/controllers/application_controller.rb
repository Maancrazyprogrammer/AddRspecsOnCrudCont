class ApplicationController < ActionController::API
before_action :authenticate_user!
before_action :load_ability

  private

  def load_ability
    @current_ability ||= Ability.new(current_user)
  end
end
