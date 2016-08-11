require 'rails_helper'

RSpec.describe "medications/show", type: :view do
  before(:each) do
    @medication = assign(:medication, Medication.create!(
      :name => "Name",
      :dosage => "Dosage",
      :description => "Description"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Dosage/)
    expect(rendered).to match(/Description/)
  end
end
