class Shelter < ApplicationRecord
  validates :name, presence: true
  validates :rank, presence: true, numericality: true
  validates :city, presence: true

  has_many :pets, dependent: :destroy

  def self.get_with_address(params)
    find_by_sql("SELECT id, name, city FROM shelters WHERE id = #{params}")
  end

  def self.alphabetical_shelters
    find_by_sql("SELECT * FROM shelters ORDER BY name")
  end

  def self.order_by_recently_created
    order(created_at: :desc)
  end

  def self.order_by_number_of_pets
    select("shelters.*, count(pets.id) AS pets_count")
      .joins("LEFT OUTER JOIN pets ON pets.shelter_id = shelters.id")
      .group("shelters.id")
      .order("pets_count DESC")
  end

  def self.pending_alphabetical_shelters
    joins(:pets).where('pets.status = ?', 'Pending').order(name: :asc).uniq
  end

  def pet_count
    pets.count
  end

  def adoptable_pets
    pets.where(adoptable: true)
  end

  def adoptable_pet_count
    pets.where(adoptable: true).count
  end

  def adopted_pet_count
    pets.where(adoptable: false).where(status: "Approved").count
  end

  def alphabetical_pets
    adoptable_pets.order(name: :asc)
  end

  def shelter_pets_filtered_by_age(age_filter)
    adoptable_pets.where('age >= ?', age_filter)
  end

  def avg_age_available_pets
    pets.where(adoptable: true).average(:age).to_f
  end

  def pending_apps
    pets.where("status = ?", "Pending").to_a
  end
end
