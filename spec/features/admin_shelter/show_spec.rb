require 'rails_helper'

RSpec.describe 'admin index' do
  before(:each) do
    @cherry_creek = Shelter.create(name: 'Cherry Creek shelter', city: 'Denver, CO', foster_program: true, rank: 1)
    @boss = @cherry_creek.pets.create(name: "Boss", age: 2, breed: 'German Shepard', adoptable: true)
    @luke = @cherry_creek.pets.create(name: "Luke", age: 1, breed: 'Huskie', adoptable: true)
    @milka = @cherry_creek.pets.create(name: "Milka", age: 2, breed: 'English Retriever', adoptable: true)
    @ducky = @cherry_creek.pets.create(name: "Ducky", age: 5, breed: 'Unkown', adoptable: true)
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

    it 'has a statistic fpr avg age of all adotpable pets' do
      visit "/admin/shelters/#{@cherry_creek.id}"
      save_and_open_page
      expect(page).to have_content("Average age of adoptable pets: #{@cherry_creek.avg_age_available_pets}")
    end
  end
end
