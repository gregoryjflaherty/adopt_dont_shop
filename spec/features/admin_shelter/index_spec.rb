require 'rails_helper'

RSpec.describe 'admin index' do
  before(:each) do
    @aurora = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
    @cherry_creek = Shelter.create(name: 'Cherry Creek shelter', city: 'Denver, CO', foster_program: true, rank: 1)
    @denver = Shelter.create(name: 'Denver shelter', city: 'Denver, CO', foster_program: true, rank: 5)
    @jax = @cherry_creek.pets.create(name: "Jax", age: 1, breed: 'Golden Retriever', adoptable: true, status: 'Pending')
    @boss = @aurora.pets.create(name: "Boss", age: 2, breed: 'German Shepard', adoptable: true, status: 'Pending')
    @luke = @denver.pets.create(name: "Luke", age: 1, breed: 'Huskie', adoptable: true, status: 'Pending')
    @greg = Applicant.create(name: 'Greg Flaherty', street_address: '123 MyStreet St.', city: "Dallas", state: "TX", zipcode: '12345', description: "Love dogs", status: "Pending")
    PetApplicant.create(pet_id: @jax.id, applicant_id: @greg.id, approved: false)
    PetApplicant.create(pet_id: @boss.id, applicant_id: @greg.id, approved: false)
    PetApplicant.create(pet_id: @luke.id, applicant_id: @greg.id, approved: false)
  end

  it 'lists all shelters alphabetically' do
    visit "/admin/shelters"

    within ('#shelters') do
      expect(page.all('.shelter')[0]).to have_content("#{@aurora.name}")
      expect(page.all('.shelter')[1]).to have_content("#{@cherry_creek.name}")
      expect(page.all('.shelter')[2]).to have_content("#{@denver.name}")
    end
  end

  describe 'shows pending applications' do
    it 'shows each shelter with pending application' do
    visit "/admin/shelters"
      within ('#pending_apps') do
        expect(page).to have_content("#{@cherry_creek.name}")
        expect(page).to have_content("#{@denver.name}")
        expect(page).to have_content("#{@aurora.name}")
        expect(page).to have_content("Shelter's with Pending Applications")
      end
    end

    it 'shows each shelter with pending application in alphabetical order' do
    visit "/admin/shelters"
      within ('#pending_apps') do
        expect(page.all('.shelter')[0]).to have_content("#{@aurora.name}")
        expect(page.all('.shelter')[1]).to have_content("#{@cherry_creek.name}")
        expect(page.all('.shelter')[2]).to have_content("#{@denver.name}")
      end
    end
  end
end
