require 'rails_helper'

RSpec.describe 'admin show' do
  before(:each) do
    @cherry_creek = Shelter.create(name: 'Cherry Creek shelter', city: 'Denver, CO', foster_program: true, rank: 1)

    @boss = @cherry_creek.pets.create(name: "Boss", age: 2, breed: 'German Shepard', adoptable: true, status: "Pending")
    @luke = @cherry_creek.pets.create(name: "Luke", age: 1, breed: 'Huskie', adoptable: false, status: "Approved")
    @milka = @cherry_creek.pets.create(name: "Milka", age: 2, breed: 'English Retriever', adoptable: false, status: "Approved")
    @ducky = @cherry_creek.pets.create(name: "Ducky", age: 5, breed: 'Unkown', adoptable: true, status: "Pending")

    @greg = Applicant.create(name: 'Greg Flaherty', street_address: '123 MyStreet St.', city: "Dallas", state: "TX", zipcode: '12345', description: "Love dogs", status: "Pending")
    @laura = Applicant.create(name: 'Laura Guerra', street_address: '123 MyStreet St.', city: "Dallas", state: "TX", zipcode: '12345', description: "Love dogs", status: "Pending")

    PetApplicant.create(pet_id: @luke.id, applicant_id: @greg.id, approved: false)
    PetApplicant.create(pet_id: @boss.id, applicant_id: @greg.id, approved: false)
    PetApplicant.create(pet_id: @milka.id, applicant_id: @laura.id, approved: false)
    PetApplicant.create(pet_id: @ducky.id, applicant_id: @laura.id, approved: false)
  end

  describe "has show page with attributes" do
    it 'shelter show page, shows city and all attributes' do
      visit "/admin/shelters/#{@cherry_creek.id}"
      expect(current_path).to eq("/admin/shelters/#{@cherry_creek.id}")

      expect(page).to have_content(@cherry_creek.name)
      expect(page).to have_content(@cherry_creek.city)
    end
  end

  describe 'has statistics section' do
    it 'has a section called statistics' do
      visit "/admin/shelters/#{@cherry_creek.id}"
      expect(page).to have_content("Statistics")
    end

    it 'has a statistic for avg age of all adoptable pets' do
      visit "/admin/shelters/#{@cherry_creek.id}"
      expect(page).to have_content("Average age of adoptable pets: #{@cherry_creek.avg_age_available_pets}")
    end

    it 'has a statistic for count of all adoptable pets' do
      visit "/admin/shelters/#{@cherry_creek.id}"
      expect(page).to have_content("Number of adoptable pets: #{@cherry_creek.adoptable_pet_count}")
    end

    it 'has a statistic for count of all adopted pets' do
      visit "/admin/shelters/#{@cherry_creek.id}"

      expect(page).to have_content("Number of adopted pets: #{@cherry_creek.adopted_pet_count}")
    end
  end

  describe 'shows all pending applications for given shelter' do

    it 'has action required section- with all pending' do
      visit "/admin/shelters/#{@cherry_creek.id}"

      expect(page).to have_content("Action Required")
    end

    it 'shows pending applications' do
      visit "/admin/shelters/#{@cherry_creek.id}"

      expect(page).to have_link("#{@boss.name}")
      expect(page).to have_link("#{@ducky.name}")
    end

    it 'link takes you to application show page' do
      visit "/admin/shelters/#{@cherry_creek.id}"

      expect(page).to have_link("#{@boss.name}")
      click_on "#{@boss.name}"
      expect(current_path).to eq("/admin/applications/#{@greg.id}")

      visit "/admin/shelters/#{@cherry_creek.id}"
      expect(page).to have_link("#{@ducky.name}")
      click_on "#{@ducky.name}"
      expect(current_path).to eq("/admin/applications/#{@laura.id}")
    end
  end
end
