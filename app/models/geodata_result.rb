class GeodataResult
  
  attr_accessor :county_sites, :local_sites, :state_sites
  
  def initialize
    @county_sites = Array.new
    @local_sites = Array.new
    @state_sites = Array.new
  end
  
  
  def to_xml(options = {})
      xml = options[:builder] ||= Builder::XmlMarkup.new(:indent => options[:indent])
      xml.instruct! unless options[:skip_instruct => true, :dasherize => false]
    
      @county_sites.sort! {|a,b| a.link_title <=> b.link_title}
      @local_sites.sort! {|a,b| a.link_title <=> b.link_title }
#      @state_sites.sort! {|a,b| a.link_title <=> b.link_title }
    
      xml.result do
          xml.county_sites do |site|
              for current_site in 0...@county_sites.length
                xml.site do
                    site.id(@county_sites[current_site]["id"])
                    site.feature_id(@county_sites[current_site]["feature_id"])
                    site.feat_class(@county_sites[current_site]["feat_class"])
                    site.fips_class(@county_sites[current_site]["fips_class"])
                    site.feat_name(@county_sites[current_site]["feat_name"])
                    site.fips_county_cd(@county_sites[current_site]["fips_county_cd"])
                    site.fips_county_name(@county_sites[current_site]["fips_county_name"])
                    site.fips_primary_lat(@county_sites[current_site]["fips_primary_lat"])
                    site.fips_primary_lon(@county_sites[current_site]["fips_primary_lon"])
                    site.alt_feat_name(@county_sites[current_site]["alt_feat_name"])
                    site.state_name(@county_sites[current_site]["state_name"])
                    site.county_name_full(@county_sites[current_site]["county_name_full"])
                    site.url_local(@county_sites[current_site]["url_local"])
                    site.url_county(@county_sites[current_site]["url_county"])
                    site.url(@county_sites[current_site]["url"])
                    site.link_title(@county_sites[current_site]["link_title"])
                    site.description(@county_sites[current_site]["description"])
                end
              end
          end
        
          xml.local_sites do |site|
              for current_site in 0...@local_sites.length
                xml.site do
                  site.id(@county_sites[current_site]["id"])
                  site.feature_id(@county_sites[current_site]["feature_id"])
                  site.feat_class(@county_sites[current_site]["feat_class"])
                  site.fips_class(@county_sites[current_site]["fips_class"])
                  site.feat_name(@county_sites[current_site]["feat_name"])
                  site.fips_county_cd(@county_sites[current_site]["fips_county_cd"])
                  site.fips_county_name(@county_sites[current_site]["fips_county_name"])
                  site.fips_primary_lat(@county_sites[current_site]["fips_primary_lat"])
                  site.fips_primary_lon(@county_sites[current_site]["fips_primary_lon"])
                  site.alt_feat_name(@county_sites[current_site]["alt_feat_name"])
                  site.state_name(@county_sites[current_site]["state_name"])
                  site.county_name_full(@county_sites[current_site]["county_name_full"])
                  site.url_local(@county_sites[current_site]["url_local"])
                  site.url_county(@county_sites[current_site]["url_county"])
                  site.url(@county_sites[current_site]["url"])
                  site.link_title(@county_sites[current_site]["link_title"])
                  site.description(@county_sites[current_site]["description"])
                end
              end
          end
      
          xml.state_sites do |site|
              for current_site in 0...@state_sites.length
                xml.site do
                  site.id(@county_sites[current_site]["id"])
                  site.feature_id(@county_sites[current_site]["feature_id"])
                  site.feat_class(@county_sites[current_site]["feat_class"])
                  site.fips_class(@county_sites[current_site]["fips_class"])
                  site.feat_name(@county_sites[current_site]["feat_name"])
                  site.fips_county_cd(@county_sites[current_site]["fips_county_cd"])
                  site.fips_county_name(@county_sites[current_site]["fips_county_name"])
                  site.fips_primary_lat(@county_sites[current_site]["fips_primary_lat"])
                  site.fips_primary_lon(@county_sites[current_site]["fips_primary_lon"])
                  site.alt_feat_name(@county_sites[current_site]["alt_feat_name"])
                  site.state_name(@county_sites[current_site]["state_name"])
                  site.county_name_full(@county_sites[current_site]["county_name_full"])
                  site.url_local(@county_sites[current_site]["url_local"])
                  site.url_county(@county_sites[current_site]["url_county"])
                  site.url(@county_sites[current_site]["url"])
                  site.link_title(@county_sites[current_site]["link_title"])
                  site.description(@county_sites[current_site]["description"])
                end
              end
          end
      end
  end
  
  def to_json(options = {})
      result = Hash.new
	
    	for current_site in 0...@county_sites.length
    		county_site_value=Array.new
    		county_site_value.push({"id"=>@county_sites[current_site]["id"]})
    		county_site_value.push({"feature_id"=>@county_sites[current_site]["feature_id"]})
    		county_site_value.push({"feat_class"=>@county_sites[current_site]["feat_class"]})
    		county_site_value.push({"fips_class"=>@county_sites[current_site]["fips_class"]})
    		county_site_value.push({"feat_name"=>@county_sites[current_site]["feat_name"]})
    		county_site_value.push({"fips_county_cd"=>@county_sites[current_site]["fips_county_cd"]})
    		county_site_value.push({"fips_county_name"=>@county_sites[current_site]["fips_county_name"]})
    		county_site_value.push({"fips_primary_lat"=>@county_sites[current_site]["fips_primary_lat"]})
    		county_site_value.push({"fips_primary_lon"=>@county_sites[current_site]["fips_primary_lon"]})
    		county_site_value.push({"alt_feat_name"=>@county_sites[current_site]["alt_feat_name"]})
    		county_site_value.push({"state_name"=>@county_sites[current_site]["state_name"]})
    		county_site_value.push({"county_name_full"=>@county_sites[current_site]["county_name_full"]})
    		county_site_value.push({"url_local"=>@county_sites[current_site]["url_local"]})
    		county_site_value.push({"url_county"=>@county_sites[current_site]["url_county"]})
    		county_site_value.push({"url"=>@county_sites[current_site]["url"]})
    		county_site_value.push({"link_title"=>@county_sites[current_site]["link_title"]})
    		county_site_value.push({"description"=>@county_sites[current_site]["description"]})
    		h1={"county_sites_item"+current_site.to_s =>county_site_value}
    		result.merge!(h1) 
    	end
    	
    	for current_site in 0...@local_sites.length
    		local_site_value=Array.new
    		local_site_value.push({"id"=>@local_sites[current_site]["id"]})
    		local_site_value.push({"feature_id"=>@local_sites[current_site]["feature_id"]})
    		local_site_value.push({"feat_class"=>@local_sites[current_site]["feat_class"]})
    		local_site_value.push({"fips_class"=>@local_sites[current_site]["fips_class"]})
    		local_site_value.push({"feat_name"=>@local_sites[current_site]["feat_name"]})
    		local_site_value.push({"fips_county_cd"=>@local_sites[current_site]["fips_county_cd"]})
    		local_site_value.push({"fips_county_name"=>@local_sites[current_site]["fips_county_name"]})
    		local_site_value.push({"fips_primary_lat"=>@local_sites[current_site]["fips_primary_lat"]})
    		local_site_value.push({"fips_primary_lon"=>@local_sites[current_site]["fips_primary_lon"]})
    		local_site_value.push({"alt_feat_name"=>@local_sites[current_site]["alt_feat_name"]})
    		local_site_value.push({"state_name"=>@local_sites[current_site]["state_name"]})
    		local_site_value.push({"county_name_full"=>@local_sites[current_site]["county_name_full"]})
    		local_site_value.push({"url_local"=>@local_sites[current_site]["url_local"]})
    		local_site_value.push({"url_county"=>@local_sites[current_site]["url_county"]})
    		local_site_value.push({"url"=>@local_sites[current_site]["url"]})
    		local_site_value.push({"link_title"=>@local_sites[current_site]["link_title"]})
    		local_site_value.push({"description"=>@local_sites[current_site]["description"]})
    		h1={"local_site_item"+current_site.to_s =>local_site_value}
    		result.merge!(h1) 
    	end
    	
    	for current_site in 0...@state_sites.length
    		state_site_value=Array.new
    		state_site_value.push({"id"=>@state_sites[current_site]["id"]})
    		state_site_value.push({"feature_id"=>@state_sites[current_site]["feature_id"]})
    		state_site_value.push({"feat_class"=>@state_sites[current_site]["feat_class"]})
    		state_site_value.push({"fips_class"=>@state_sites[current_site]["fips_class"]})
    		state_site_value.push({"feat_name"=>@state_sites[current_site]["feat_name"]})
    		state_site_value.push({"fips_county_cd"=>@state_sites[current_site]["fips_county_cd"]})
    		state_site_value.push({"fips_county_name"=>@state_sites[current_site]["fips_county_name"]})
    		state_site_value.push({"fips_primary_lat"=>@state_sites[current_site]["fips_primary_lat"]})
    		state_site_value.push({"fips_primary_lon"=>@state_sites[current_site]["fips_primary_lon"]})
    		state_site_value.push({"alt_feat_name"=>@state_sites[current_site]["alt_feat_name"]})
    		state_site_value.push({"state_name"=>@state_sites[current_site]["state_name"]})
    		state_site_value.push({"county_name_full"=>@state_sites[current_site]["county_name_full"]})
    		state_site_value.push({"url_local"=>@state_sites[current_site]["url_local"]})
    		state_site_value.push({"url_county"=>@state_sites[current_site]["url_county"]})
    		state_site_value.push({"url"=>@state_sites[current_site]["url"]})
    		state_site_value.push({"link_title"=>@state_sites[current_site]["link_title"]})
    		state_site_value.push({"description"=>@state_sites[current_site]["description"]})
    		h1={"state_site_item"+current_site.to_s =>state_site_value}
    		result.merge!(h1) 
    	end
      result.to_json  
  end

end
