class Permitme
  
  attr_reader :link_title, :url
  
  def initialize
    @link_title = ""
    @url = ""
  end
  
  def find_all
    PermitmeResource.find(:all, :select => "link_title, url")
  end
end