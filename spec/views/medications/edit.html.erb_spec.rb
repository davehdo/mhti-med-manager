require 'rails_helper'

RSpec.describe "medications/edit", type: :view do
  before(:each) do
    @medication = assign(:medication, Medication.create!(
      :name => "MyString",
      :dosage => "MyString",
      :description => "MyString"
    ))
  end

  it "renders the edit medication form" do
    render

    assert_select "form[action=?][method=?]", medication_path(@medication), "post" do

      assert_select "input#medication_name[name=?]", "medication[name]"

      assert_select "input#medication_dosage[name=?]", "medication[dosage]"

      assert_select "input#medication_description[name=?]", "medication[description]"
    end
  end
end
