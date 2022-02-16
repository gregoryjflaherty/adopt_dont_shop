require 'rails_helper'

RSpec.describe 'admin index' do
  before(:each) do
    @cherry_creek = Shelter.create(name: 'Cherry Creek shelter', city: 'Denver, CO', foster_program: true, rank: 1)
  end

  describe "has show page with attributes" do
    it 'shelter show page, shows city and all attributes' do
      visit "/admin/shelters/#{@cherry_creek.id}"
      expect(current_path). to eq("/admin/shelters/#{@cherry_creek.id}")

      expect(page).to have_content(@cherry_creek.name)
      expect(page).to have_content(@cherry_creek.city)
    end
  end
end
