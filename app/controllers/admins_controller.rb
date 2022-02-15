class AdminsController < ApplicationController
  def show
    @applicant = Applicant.find(params[:id])
  end

  def update
    @applicant = Applicant.find(params[:id])
    @pet = Pet.find(params[:pet_id])
    if params[:decision] == 'accept'
      @application = PetApplicant.find_and_accept(params[:id], params[:pet_id]).first
      @pet.update!(adoptable: false, status: true)
      redirect_to "/admin/applications/#{@applicant.id}"
    elsif params[:decision] == 'reject'
      @application = PetApplicant.find_and_reject(params[:id], params[:pet_id]).first
      @pet.update!(adoptable: true, status: false)
      redirect_to "/admin/applications/#{@applicant.id}"
    end
  end
end
