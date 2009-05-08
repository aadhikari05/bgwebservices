class PermitmeResource < ActiveRecord::Base
  belongs_to :permitme_resource_group
  
  def name
    @attributes["Link_Title"]
  end
  
end