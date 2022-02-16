class AdminSheltersController < ApplicationController
  def index
    @shelters = Shelter.alphabetical_shelters
    @pending_shelters = Shelter.pending_alphabetical_shelters
  end

  def show
    @shelters = Shelter.get_all_with_address
  end
end
