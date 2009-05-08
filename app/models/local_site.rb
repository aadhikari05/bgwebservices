class LocalSite
  
  
  def initialize
    @type = ""
    @primacy = ""
    @description = ""
    @url = ""
    @name = ""
    @id = ""
    @feature_id = ""
    @fips_class = ""
    @feature_name = ""
    @state_alpha = ""
  end
  
  def find_all
    PermitmeResource.find(:all, :select => "link_title, url")
  end
end