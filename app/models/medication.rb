class Medication
  include Mongoid::Document
  field :name, type: String
  field :dosage, type: String
  field :description, type: String
  field :take_am, type: Boolean
  field :take_noon, type: Boolean
  field :take_pm, type: Boolean
end
