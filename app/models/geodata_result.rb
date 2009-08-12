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
      @state_sites.sort! {|a,b| a.link_title <=> b.link_title}
    
      xml.result do
          xml.county_sites do |site|
              for current_site in 0...@county_sites.length
                xml.site do
                  site.link_title(@county_sites[current_site]["link_title"])
                  site.description(@county_sites[current_site]["description"])
                  site.url(@county_sites[current_site]["url"])
                  site.fips_id(@county_sites[current_site]["fips_id"])
                  site.fips_class(@county_sites[current_site]["fips_class"])
                  site.fips_feat_id(@county_sites[current_site]["fips_feat_id"])
                  site.fips_st_cd(@county_sites[current_site]["fips_st_cd"])
                  site.fips_place_cd(@county_sites[current_site]["fips_place_cd"])
                  site.fips_county_cd(@county_sites[current_site]["fips_county_cd"])
                end
              end
          end
        
          xml.local_sites do |site|
              for current_site in 0...@local_sites.length
                xml.site do
                  site.link_title(@local_sites[current_site]["link_title"])
                  site.description(@local_sites[current_site]["description"])
                  site.url(@local_sites[current_site]["url"])
                  site.fips_id(@local_sites[current_site]["fips_id"])
                  site.fips_class(@local_sites[current_site]["fips_class"])
                  site.fips_feat_id(@local_sites[current_site]["fips_feat_id"])
                  site.fips_st_cd(@local_sites[current_site]["fips_st_cd"])
                  site.fips_place_cd(@local_sites[current_site]["fips_place_cd"])
                  site.fips_county_cd(@local_sites[current_site]["fips_county_cd"])
                end
              end
          end
        
          xml.state_sites do |site|
              for current_site in 0...@state_sites.length
                xml.site do
                  site.link_title(@state_sites[current_site]["link_title"])
                  site.description(@state_sites[current_site]["description"])
                  site.url(@state_sites[current_site]["url"])
                  site.fips_id(@state_sites[current_site]["fips_id"])
                  site.fips_class(@state_sites[current_site]["fips_class"])
                  site.fips_feat_id(@state_sites[current_site]["fips_feat_id"])
                  site.fips_st_cd(@state_sites[current_site]["fips_st_cd"])
                  site.fips_place_cd(@state_sites[current_site]["fips_place_cd"])
                  site.fips_county_cd(@state_sites[current_site]["fips_county_cd"])
                end
              end
          end
      end
  end
  
  def to_json(options = {})
      result = Hash.new
	
    	for current_site in 0...@county_sites.length
    		county_site_value=Array.new
    		county_site_value.push({"title"=>@county_sites[current_site]["link_title"]})
    		county_site_value.push({"description"=>@county_sites[current_site]["description"]})
    		county_site_value.push({"url"=>@county_sites[current_site]["url"]})
    		county_site_value.push({"fips_id"=>@county_sites[current_site]["fips_id"]})
    		county_site_value.push({"fips_class"=>@county_sites[current_site]["fips_class"]})
    		county_site_value.push({"fips_feat_id"=>@county_sites[current_site]["fips_feat_id"]})
    		county_site_value.push({"fips_st_cd"=>@county_sites[current_site]["fips_st_cd"]})
    		county_site_value.push({"fips_place_cd"=>@county_sites[current_site]["fips_place_cd"]})
    		county_site_value.push({"fips_county_cd"=>@county_sites[current_site]["fips_county_cd"]})
    		h1={"county_sites_item"+current_site.to_s =>county_site_value}
    		result.merge!(h1) 
    	end
    	for current_site in 0...@local_sites.length
    		local_site_value=Array.new
    		local_site_value.push({"title"=>@local_sites[current_site]["link_title"]})
    		local_site_value.push({"description"=>@local_sites[current_site]["description"]})
    		local_site_value.push({"url"=>@local_sites[current_site]["url"]})
    		local_site_value.push({"fips_id"=>@local_sites[current_site]["fips_id"]})
    		local_site_value.push({"fips_class"=>@local_sites[current_site]["fips_class"]})
    		local_site_value.push({"fips_feat_id"=>@local_sites[current_site]["fips_feat_id"]})
    		local_site_value.push({"fips_st_cd"=>@local_sites[current_site]["fips_st_cd"]})
    		local_site_value.push({"fips_place_cd"=>@local_sites[current_site]["fips_place_cd"]})
    		local_site_value.push({"fips_county_cd"=>@local_sites[current_site]["fips_county_cd"]})
    		h1={"local_site_item"+current_site.to_s =>local_site_value}
    		result.merge!(h1) 
    	end
    	for current_site in 0...@state_sites.length
    		state_site_value=Array.new
    		state_site_value.push({"title"=>@state_sites[current_site]["link_title"]})
    		state_site_value.push({"description"=>@state_sites[current_site]["description"]})
    		state_site_value.push({"url"=>@state_sites[current_site]["url"]})
    		state_site_value.push({"fips_id"=>@state_sites[current_site]["fips_id"]})
    		state_site_value.push({"fips_class"=>@state_sites[current_site]["fips_class"]})
    		state_site_value.push({"fips_feat_id"=>@state_sites[current_site]["fips_feat_id"]})
    		state_site_value.push({"fips_st_cd"=>@state_sites[current_site]["fips_st_cd"]})
    		state_site_value.push({"fips_place_cd"=>@state_sites[current_site]["fips_place_cd"]})
    		state_site_value.push({"fips_county_cd"=>@state_sites[current_site]["fips_county_cd"]})
    		h1={"state_site_item"+current_site.to_s =>state_site_value}
    		result.merge!(h1) 
    	end
      result.to_json  
  end

end
