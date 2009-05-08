class County
  
  
  def initialize
    @id = ""
    @name = ""
  end
  
  def find_all
    PermitmeResource.find(:all, :select => "link_title, url")
  end
end