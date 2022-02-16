class AdminSheltersController < ApplicationController
  def index
    @shelters = Shelter.alphabetical_shelters
    @pending_shelters = Shelter.pending_apps
  end

  def show
    @shelters = Shelter.get_all_with_address
  end
end
