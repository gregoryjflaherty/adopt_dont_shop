require 'rails_helper'

RSpec.describe Applicant, type: :model do
  describe 'relationships' do
    it { should have_many(:pet_applicants) }
    it { should have_many(:pets).through(:pet_applicants) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name)}
  end

  before(:each) do


  end

  describe ("#gets all pending apps by shelter") do

  end
end
