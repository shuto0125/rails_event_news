class WelcomeController < ApplicationController
  skip_before_action :authenticate

  def index
    @events = Event.page(params[:page]).per(3).where("start_at > ?", Time.zone.now).order(:start_at)
  end
end
