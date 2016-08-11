require 'rails_helper'

RSpec.describe "medications/index", type: :view do
  before(:each) do
    assign(:medications, [
      Medication.create!(
        :name => "Name",
        :dosage => "Dosage",
        :description => "Description"
      ),
      Medication.create!(
        :name => "Name",
        :dosage => "Dosage",
        :description => "Description"
      )
    ])
  end

  it "renders a list of medications" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Dosage".to_s, :count => 2
    assert_select "tr>td", :text => "Description".to_s, :count => 2
  end
end
