require 'rails_helper'

RSpec.describe "recipes/edit", :type => :view do
  before(:each) do
    @recipe = assign(:recipe, Recipe.create!(
      :name => "MyString"
    ))
  end

  it "renders the edit recipe form" do
    render

    assert_select "form[action=?][method=?]", recipe_path(@recipe), "post" do

      assert_select "input#recipe_name[name=?]", "recipe[name]"
    end
  end
end
