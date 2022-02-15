require 'rails_helper'

RSpec.describe 'admin show page' do
  before(:each) do
    @aurora = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
    @cherry_creek = Shelter.create(name: 'Cherry Creek shelter', city: 'Denver, CO', foster_program: true, rank: 1)
    @denver = Shelter.create(name: 'Denver shelter', city: 'Denver, CO', foster_program: true, rank: 5)
    @jax = @cherry_creek.pets.create(name: "Jax", age: 1, breed: 'Golden Retriever', adoptable: true, status: 'Pending')
    @boss = @cherry_creek.pets.create(name: "Boss", age: 2, breed: 'German Shepard', adoptable: true, status: 'Pending')
    @luke = @denver.pets.create(name: "Luke", age: 1, breed: 'Huskie', adoptable: true, status: 'Pending')
    @greg = Applicant.create(name: 'Greg Flaherty', street_address: '123 MyStreet St.', city: "Dallas", state: "TX", zipcode: '12345', description: "Love dogs", status: "Pending")
    PetApplicant.create(pet_id: @jax.id, applicant_id: @greg.id, approved: false)
    PetApplicant.create(pet_id: @boss.id, applicant_id: @greg.id, approved: false)
    PetApplicant.create(pet_id: @luke.id, applicant_id: @greg.id, approved: false)
  end

  describe 'approve a specific pet' do
    it 'For every pet, I see a button to approve the application for that specific pet' do
      visit "/admin/applications/#{@greg.id}"
      expect(current_path).to eq("/admin/applications/#{@greg.id}")

      within '#pets' do
        expect(page.all('.pet')[0]).to have_button("Approve #{@jax.name}")
        expect(page.all('.pet')[1]).to have_button("Approve #{@boss.name}")
        expect(page.all('.pet')[2]).to have_buttton("Approve #{@luke.name}")
      end
    end
  end
end
