class Result
  
  attr_reader :county_sites, :primary_local_sites
  attr_writer :county_sites, :primary_local_sites
  
  def initialize
    @is_normal = true
    @is_disambig = false
    @is_invalid = false
    @state = ""
    @has_multiple_counties = false
    @outcome = Array.new
    @errors = Array.new
    @county_sites = Array.new
#    @disambig_choices = false
    @root_resource_group = Array.new
    @status = ""
    @user_query = ""
    @primary_local_sites = Array.new
    @business_type = 0
    @business_type_name = ""
#    @p_state = false  #Provisional State - Not Needed since we know state
  end
  
end