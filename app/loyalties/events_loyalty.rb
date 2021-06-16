class EventsLoyalty < ApplicationLoyalty
  def create?
    user.role == "admin"
  end
end
