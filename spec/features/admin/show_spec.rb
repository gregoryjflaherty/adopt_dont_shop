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

      expect(page).to have_button("Accept #{@jax.name}")
      expect(page).to have_button("Accept #{@boss.name}")
      expect(page).to have_button("Accept #{@luke.name}")
    end

    it 'when I click on approve, I see indicator that pet is approved' do
      visit "/admin/applications/#{@greg.id}"
      expect(current_path).to eq("/admin/applications/#{@greg.id}")

      click_on "Accept #{@jax.name}"
      expect(current_path).to eq("/admin/applications/#{@greg.id}")
      expect(page).to have_content("#{@jax.name} has been approved")
    end
  end

  describe 'rejects a specific pet' do
    it 'For every pet, I see a button to approve the application for that specific pet' do
      visit "/admin/applications/#{@greg.id}"
      expect(current_path).to eq("/admin/applications/#{@greg.id}")

      expect(page).to have_button("Reject #{@jax.name}")
      expect(page).to have_button("Reject #{@boss.name}")
      expect(page).to have_button("Reject #{@luke.name}")
    end

    it 'when I click on reject, I see indicator that pet is rejected' do
      visit "/admin/applications/#{@greg.id}"
      expect(current_path).to eq("/admin/applications/#{@greg.id}")

      click_on "Reject #{@luke.name}"
      expect(current_path).to eq("/admin/applications/#{@greg.id}")
      expect(page).to have_content("#{@luke.name} has been rejected")
      save_and_open_page
    end
  end
end
