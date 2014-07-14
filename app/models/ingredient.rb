class Ingredient < ActiveRecord::Base
  belongs_to :recipe 
  validate :loaded, :can_load?






  def can_load?
    unless pourable
      errors.add(:loaded, "Ingredient must be pourable")
    end
  end

end
