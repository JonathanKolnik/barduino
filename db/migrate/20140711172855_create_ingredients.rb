class CreateIngredients < ActiveRecord::Migration
  def change
    create_table :ingredients do |t|
      t.string :name
      t.boolean :loaded
      t.boolean :pourable

      t.timestamps
    end
  end
end
