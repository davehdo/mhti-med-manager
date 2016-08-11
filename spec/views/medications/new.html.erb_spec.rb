require 'rails_helper'

RSpec.describe "medications/new", type: :view do
  before(:each) do
    assign(:medication, Medication.new(
      :name => "MyString",
      :dosage => "MyString",
      :description => "MyString"
    ))
  end

  it "renders new medication form" do
    render

    assert_select "form[action=?][method=?]", medications_path, "post" do

      assert_select "input#medication_name[name=?]", "medication[name]"

      assert_select "input#medication_dosage[name=?]", "medication[dosage]"

      assert_select "input#medication_description[name=?]", "medication[description]"
    end
  end
end
