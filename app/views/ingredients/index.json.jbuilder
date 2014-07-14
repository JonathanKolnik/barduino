json.array!(@ingredients) do |ingredient|
  json.extract! ingredient, :id, :name, :loaded, :pourable
  json.url ingredient_url(ingredient, format: :json)
end
