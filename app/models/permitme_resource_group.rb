class PermitmeResourceGroup < ActiveRecord::Base
  belongs_to :state
  belongs_to :permitme_category
  belongs_to :permitme_subcategory
  belongs_to :permitme_section
  has_many :permitme_resources
end
