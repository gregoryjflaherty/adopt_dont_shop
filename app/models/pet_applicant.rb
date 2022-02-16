class PetApplicant < ApplicationRecord
  belongs_to :pet
  belongs_to :applicant

  before_create do
    self.status = "Pending"
  end

  def self.find_and_accept(applicant, pet)
    application = where(pet_id: pet).where(applicant_id: applicant)
    application.update(approved: true, status: "Approved")
  end

  def self.find_and_reject(applicant, pet)
    application = where(pet_id: pet).where(applicant_id: applicant)
    application.update(approved: false, status: "Rejected")
  end
end
