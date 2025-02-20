require 'rails_helper'

RSpec.describe 'admin show page' do
  before(:each) do
    @cherry_creek = Shelter.create(name: 'Cherry Creek shelter', city: 'Denver, CO', foster_program: true, rank: 1)
    @denver = Shelter.create(name: 'Denver shelter', city: 'Denver, CO', foster_program: true, rank: 5)
    @jax = @cherry_creek.pets.create(name: "Jax", age: 1, breed: 'Golden Retriever', adoptable: true, status: 'Pending')
    @boss = @cherry_creek.pets.create(name: "Boss", age: 2, breed: 'German Shepard', adoptable: true, status: 'Pending')
    @luke = @denver.pets.create(name: "Luke", age: 1, breed: 'Huskie', adoptable: true, status: 'Pending')
    @katie = Applicant.create(name: 'Katie Sanger', street_address: '123 MyStreet St.', city: "Dallas", state: "TX", zipcode: '12345', description: "Love dogs", status: "Pending")
    @greg = Applicant.create(name: 'Greg Flaherty', street_address: '123 MyStreet St.', city: "Dallas", state: "TX", zipcode: '12345', description: "Love dogs", status: "Pending")
    PetApplicant.create(pet_id: @jax.id, applicant_id: @greg.id, approved: false, status: "Pending")
    PetApplicant.create(pet_id: @boss.id, applicant_id: @greg.id, approved: false, status: "Pending")
    PetApplicant.create(pet_id: @luke.id, applicant_id: @greg.id, approved: false, status: "Pending")
    PetApplicant.create(pet_id: @luke.id, applicant_id: @katie.id, approved: false)
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
      expect(page).to have_content("#{@jax.name} has been approved on your application")
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
    end

    it 'accepting a pet on one application doesnt accept it on another' do
      visit "/admin/applications/#{@greg.id}"
      expect(current_path).to eq("/admin/applications/#{@greg.id}")
      click_on "Accept #{@luke.name}"
      expect(current_path).to eq("/admin/applications/#{@greg.id}")
      expect(page).to have_content("#{@luke.name} has been approved on your application")

      visit "/admin/applications/#{@katie.id}"
      expect(page).to have_content("#{@luke.name} has been approved on another application")
      expect(page).to_not have_content("#{@luke.name} has been approved on your application")
    end
  end

  describe 'admin decisions change applicant status' do
    it 'if I accept all pets, applicant status is "Accepted"' do
      visit "/admin/applications/#{@greg.id}"
      expect(current_path).to eq("/admin/applications/#{@greg.id}")

      click_on "Accept #{@jax.name}"
      click_on "Accept #{@boss.name}"
      click_on "Accept #{@luke.name}"
      expect(current_path).to eq("/admin/applications/#{@greg.id}")
      expect(page).to have_content("Application status: Approved")
    end

    it 'if I reject one or more pets, applicant status is "Rejected"' do
      visit "/admin/applications/#{@greg.id}"
      expect(current_path).to eq("/admin/applications/#{@greg.id}")

      click_on "Accept #{@jax.name}"
      click_on "Accept #{@boss.name}"
      click_on "Reject #{@luke.name}"
      expect(current_path).to eq("/admin/applications/#{@greg.id}")
      expect(page).to have_content("Application status: Rejected")
    end
  end

  describe 'accepting pets changes pets status in pet show page' do
    it 'accepts pets on application, then checks pet show page is not adoptable' do
      visit "/admin/applications/#{@greg.id}"
      expect(current_path).to eq("/admin/applications/#{@greg.id}")

      click_on "Accept #{@jax.name}"
      click_on "Accept #{@boss.name}"

      visit "/pets/#{@jax.id}"
      expect(page).to have_content("Adoptable: false")
      expect(page).to_not have_content("Adoptable: true")

      visit "/pets/#{@boss.id}"
      expect(page).to have_content("Adoptable: false")
      expect(page).to_not have_content("Adoptable: true")
    end
  end

  describe 'a pet can only have one approved application' do
    it 'removes the ability to approve once approved elsewhere' do

      visit "/admin/applications/#{@greg.id}"
      expect(current_path).to eq("/admin/applications/#{@greg.id}")

      click_on "Accept #{@luke.name}"

      visit "/admin/applications/#{@katie.id}"
      expect(current_path).to eq("/admin/applications/#{@katie.id}")
      within '#pet_apps' do
        expect(page.all('.pet')[0]).to have_content("#{@luke.name} has been approved on another application")
        expect(page.all('.pet')[0]).to have_button("Reject #{@luke.name}")
        expect(page.all('.pet')[0]).to_not have_button("Accept #{@luke.name}")
      end
    end
  end
end
