class PermitmeResource < ActiveRecord::Base
  belongs_to :permitme_resource_group
  
  def name
    @attributes["Link_Title"]
  end
  
  def self.find_permitme
    @joins = "left outer join permitme_resource_groups on permitme_resource_groups.id = permitme_resources.permitme_resource_group_id group by permitme_resources.permitme_resource_group_id"
    PermitmeResource.find(:all, :select =>"permitme_resources.link_title,permitme_resources.url", :joins => @joins)  
  end
end