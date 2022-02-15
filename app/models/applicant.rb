class Applicant < ApplicationRecord
  validates :name, presence: true
  validates :street_address, presence: true
  validates :city, presence: true
  validates :state, presence: true
  validates :zipcode, presence: true
  validates_uniqueness_of :name

  has_many :pet_applicants
  has_many :pets, through: :pet_applicants

  before_create do
    self.status = "In Progress"
  end

  def see_status
    if pet_applicants.where(status: "Approved").count == pet_applicants.count
      self.status == "Approved"
      return "Approved"
    elsif pet_applicants.where(status: "Rejected").count >= 1
      self.status == "Rejected"
      return "Rejected"
    else
      self.status == "Pending"
    end
  end
end
