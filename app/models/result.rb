class Result
  
  attr_reader :county_sites, :local_sites, :state_sites, :sites_for_business_type
  attr_writer :county_sites, :local_sites, :state_sites, :sites_for_business_type
  
  def initialize
    @county_sites = Array.new
    @local_sites = Array.new
    @state_sites = Array.new
    @sites_for_business_type = Array.new

#    @is_normal = true
#    @is_disambig = false
#    @is_invalid = false
#    
#    @state = ""
#    @has_multiple_counties = false
#    @outcome = Array.new
#    @errors = Array.new
#    @root_resource_group = Hash.new
#    @status = ""
#    @user_query = ""
#    @business_type = 0
#    @business_type_name = ""
  end
  s  
  def to_xml(options = {})
    xml = options[:builder] ||= Builder::XmlMarkup.new(:indent => options[:indent])
    xml.instruct! unless options[:skip_instruct => true, :dasherize => false]
    @county_sites.sort! {|a,b| a.link_title <=> b.link_title }
    @local_sites.sort! {|a,b| a.link_title <=> b.link_title }
    @state_sites.sort! {|a,b| a.link_title <=> b.link_title }
    @sites_for_business_type.sort! {|a,b| a.link_title <=> b.link_title }
    
    xml.result do
        xml.county_sites do |site|
            for current_site in 0...@county_sites.length
              xml.site do
                site.link_title (@county_sites[current_site]["link_title"])
                site.description (@county_sites[current_site]["description"])
                site.url (@county_sites[current_site]["url"])
              end
            end
        end
        
        xml.local_sites do |site|
            for current_site in 0...@local_sites.length
              xml.site do
                site.link_title (@local_sites[current_site]["link_title"])
                site.description (@local_sites[current_site]["description"])
                site.url (@local_sites[current_site]["url"])
              end
            end
        end
        
        xml.state_sites do |site|
            for current_site in 0...@state_sites.length
              xml.site do
                site.link_title (@state_sites[current_site]["link_title"])
                site.description (@state_sites[current_site]["description"])
                site.url (@state_sites[current_site]["url"])
              end
            end
        end
        
        xml.sites_for_business_type do |site|
            for current_site in 0...@sites_for_business_type.length
              xml.site do
                site.link_title (@sites_for_business_type[current_site]["link_title"])
                site.description (@sites_for_business_type[current_site]["description"])
                site.url (@sites_for_business_type[current_site]["url"])
              end
            end
        end
    end
  end

end
