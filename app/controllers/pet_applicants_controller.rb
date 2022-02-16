class PetApplicantsController < ApplicationController
  def create
    @application = PetApplicant.create(
      pet: Pet.find(params[:pet_id]),
      applicant: Applicant.find(params[:id]))
    @application.save
    @application.pet.update!(status: 'Pending')
    redirect_to "/applicants/#{@application.applicant.id}"
  end
end
