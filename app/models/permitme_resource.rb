class PermitmeResource < ActiveRecord::Base
  belongs_to :permitme_resource_group
  
  def name
    @attributes["Link_Title"]
  end
  
  def self.find_permitme
    @joins = "left outer join permitme_resource_groups on permitme_resource_groups.id = permitme_resources.permitme_resource_group_id group by permitme_resources.permitme_resource_group_id"
    PermitmeResource.find(:all, :select =>"permitme_resources.link_title,permitme_resources.url", :joins => @joins)  
  end

  def self.find_by_businesstype_and_zip (business_type, zip)
    @query = "select Link_Title, Url from permitme_resources where permitme_resource_group_id in (select id from permitme_resource_groups where permitme_subcategory_id in (select id from permitme_subcategories where isExclusive=1 and isActive=1 and name = ?) and state_id in (select distinct(f.state_id) from features f, zipcodes z where z.zip=? and z.feature_id=f.id))"
    PermitmeResource.find_by_sql(["select Link_Title, Url from permitme_resources where permitme_resource_group_id in (select id from permitme_resource_groups where permitme_subcategory_id in (select id from permitme_subcategories where isExclusive=1 and isActive=1 and name = ?) and state_id in (select distinct(f.state_id) from features f, zipcodes z where z.zip=? and z.feature_id=f.id))", business_type, zip])  
  end

end