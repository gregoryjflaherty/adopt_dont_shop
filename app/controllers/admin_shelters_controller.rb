class AdminSheltersController < ApplicationController
  def index
    @shelters = Shelter.reverse_alphabetical_shelters
    @pending_shelters = Shelter.pending_alphabetical_shelters
  end

  def show
    @shelter = Shelter.get_with_address(params[:id]).first
  end
end
