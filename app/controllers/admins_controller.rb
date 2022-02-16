class AdminsController < ApplicationController
  def show
    @applicant = Applicant.find(params[:id])
    @applications = @applicant.pet_applicants
  end

  def update
    @applicant = Applicant.find(params[:id])
    @pet = Pet.find(params[:pet_id])
    if params[:decision] == 'accept'
      @application = PetApplicant.find_and_accept(params[:id], params[:pet_id]).first
      @application.pet.update!(adoptable: false)
      redirect_to "/admin/applications/#{@applicant.id}"
    elsif params[:decision] == 'reject'
      @application = PetApplicant.find_and_reject(params[:id], params[:pet_id]).first
      redirect_to "/admin/applications/#{@applicant.id}"
    end
  end
end
