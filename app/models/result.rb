class Result
  
  attr_reader :county_sites, :local_sites, :state_sites, :sites_for_business_type
  attr_writer :county_sites, :local_sites, :state_sites, :sites_for_business_type
  
  def initialize
    @county_sites = Hash.new
    @local_sites = Hash.new
    @state_sites = Hash.new
    @sites_for_business_type = Hash.new

    @is_normal = true
    @is_disambig = false
    @is_invalid = false
    
    @state = ""
    @has_multiple_counties = false
    @outcome = Array.new
    @errors = Array.new
    @root_resource_group = Hash.new
    @status = ""
    @user_query = ""
    @business_type = 0
    @business_type_name = ""
  end
  
end