class Comment
  include Mongoid::Document
  field :comment, type: String
  field :name, type: String
  field :image_url, type: String
  
  validates_presence_of :name, :comment, :image_url
  
  validates :comment, length: { maximum: 240 }
end
