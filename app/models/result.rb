class Result
  
  attr_reader :link_title, :url
  
  def initialize
    @is_normal = false
    @is_disambig = false
    @is_invalid = false
    @state = false
    @has_multiple_counties = false
    @outcome = false
    @errors = false
    @county_sites = false
    @disambig_choices = false
    @root_resource_group = false
    @status = false
    @user_query = false
    @primary_local_sites = false
    @business_type = false
    @business_type_name = false
#    @p_state = false  #Provisional State - Not Needed since we know states
  end
  
  def find_all
    PermitmeResource.find(:all, :select => "link_title, url")
  end
end