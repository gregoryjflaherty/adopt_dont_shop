require 'rails_helper'

RSpec.describe PetApplicant, type: :model do
  describe 'relationships' do
    it { should belong_to(:pet)}
    it { should belong_to(:applicant)}
  end
  before(:each) do
    @cherry_creek = Shelter.create(name: 'Cherry Creek shelter', city: 'Denver, CO', foster_program: true, rank: 1)

    @jax = @cherry_creek.pets.create(name: "Jax", age: 1, breed: 'Golden Retriever', adoptable: false, status: "Approved")
    @milka = @cherry_creek.pets.create(name: "Milka", age: 2, breed: 'English Retriever', adoptable: false, status: "Approved")

    @greg = Applicant.create(name: 'Greg Flaherty', street_address: '123 MyStreet St.', city: "Dallas", state: "TX", zipcode: '12345', description: "Love dogs", status: "Pending")
    @laura = Applicant.create(name: 'Laura Guerra', street_address: '123 MyStreet St.', city: "Dallas", state: "TX", zipcode: '12345', description: "Love dogs", status: "Pending")

    @app_1 = PetApplicant.create(pet_id: @jax.id, applicant_id: @greg.id, approved: false)
    @app_2 = PetApplicant.create(pet_id: @milka.id, applicant_id: @laura.id, approved: false)
  end
end
