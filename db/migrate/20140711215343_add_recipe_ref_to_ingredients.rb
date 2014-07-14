class AddRecipeRefToIngredients < ActiveRecord::Migration
  def change
    add_reference :ingredients, :recipe, index: true
  end
end
