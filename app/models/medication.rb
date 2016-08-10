class Medication
  include Mongoid::Document
  field :name, type: String
  field :dosage, type: String
  field :education, type: Array 
  field :description, type: String
  field :take_am, type: Boolean
  field :take_noon, type: Boolean
  field :take_pm, type: Boolean
  
  before_save :fetch_medline
  
  def fetch_medline
    begin
      self.education ||= MedlinePlus2.find_drug_by_name( self.name || “atorvastatin” )
    rescue
      self.education ||= []
    end
  end
end
