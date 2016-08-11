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
  
  require "medline_plus_2.rb"
  
  def fetch_medline( force = false )
    if self.name
      if force
        self.education ||= MedlinePlus2.find_drug_by_name( self.name )
      else
        begin
          self.education ||= MedlinePlus2.find_drug_by_name( self.name )
        rescue
          self.education ||= []
        end
      end
    else
      self.education ||= []
    end
  end
end
