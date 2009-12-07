class Result
  
  attr_accessor :county_sites, :local_sites, :state_sites, :sites_for_business_type , :rec_sites
  
  def initialize
    @county_sites = Array.new
    @local_sites = Array.new
    @state_sites = Array.new
    @sites_for_business_type = Array.new
    @rec_sites = Array.new
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
  
  def to_recSitexml(options ={})
    xml = options[:builder] ||= Builder::XmlMarkup.new(:indent => options[:indent])
    xml.instruct! unless options[:skip_instruct => true, :dasherize => false]
    
     xml.result do
        xml.rec_sites do |site|
            for rec_site in 0...@rec_sites.length
              xml.site do
                site.link_title(@rec_sites[rec_site]["title"])
                site.url(@rec_sites[rec_site]["url"])
                site.description(@rec_sites[rec_site]["description"])
                site.keywords(@rec_sites[rec_site]["keywords"])
                site.category(@rec_sites[rec_site]["category"])
                site.orders(@rec_sites[rec_site]["orders"])
              end
            end
        end
    end
    
  end
  
  def to_recSitejson(options = {})

    result = Hash.new

    for current_site in 0...@rec_sites.length
        county_site_value=Array.new
        county_site_value.push({"title"=>@rec_sites[current_site]["title"]})
        county_site_value.push({"url"=>@rec_sites[current_site]["url"]})
        county_site_value.push({"description"=>@rec_sites[current_site]["description"]})
        county_site_value.push({"keywords"=>@rec_sites[current_site]["keywords"]})
        county_site_value.push({"category"=>@rec_sites[current_site]["category"]})
        county_site_value.push({"orders"=>@rec_sites[current_site]["orders"]})
        
        h1={"recommended_sites_item"+current_site.to_s =>county_site_value}

        result.merge!(h1) 
    end
    result.to_json 
  end
  
  def to_xml(options = {})
    xml = options[:builder] ||= Builder::XmlMarkup.new(:indent => options[:indent])
    xml.instruct! unless options[:skip_instruct => true, :dasherize => false]
    
    if !@county_sites[0][0].nil?
        @county_sites.sort! {|a,b| a.link_title <=> b.link_title}
    end
    @local_sites.sort! {|a,b| a.link_title <=> b.link_title }
    @state_sites.sort! {|a,b| a.link_title <=> b.link_title}
    @sites_for_business_type.sort! {|a,b| a.link_title <=> b.link_title }
    
    xml.result do
        xml.county_sites do |site|
            for current_site in 0...@county_sites[0].length
              xml.site do
                site.link_title(@county_sites[current_site][0]["link_title"])
                site.description(@county_sites[current_site][0]["description"])
                site.url(@county_sites[current_site][0]["url"])
              end
            end
        end
        
        xml.local_sites do |site|
            for current_site in 0...@local_sites.length
              xml.site do
                site.link_title(@local_sites[current_site]["link_title"])
                site.description(@local_sites[current_site]["description"])
                site.url(@local_sites[current_site]["url"])
              end
            end
        end
        
        xml.state_sites do |site|
            for current_site in 0...@state_sites.length
              xml.site do
                site.link_title(@state_sites[current_site]["link_title"])
                site.description(@state_sites[current_site]["description"])
                site.url(@state_sites[current_site]["url"])
              end
            end
        end
        
        xml.sites_for_business_type do |site|
            for current_site in 0...@sites_for_business_type.length
              xml.site do
                site.link_title(@sites_for_business_type[current_site]["link_title"])
                site.description(@sites_for_business_type[current_site]["description"])
                site.url(@sites_for_business_type[current_site]["url"])
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
		h1={"county_sites_item"+current_site.to_s =>state_site_value}
		result.merge!(h1) 
	end
	for current_site in 0...@local_sites.length
		local_site_value=Array.new
		local_site_value.push({"title"=>@local_sites[current_site]["link_title"]})
		local_site_value.push({"description"=>@local_sites[current_site]["description"]})
		local_site_value.push({"url"=>@local_sites[current_site]["url"]})
		h1={"state_site_item"+current_site.to_s =>local_site_value}
		result.merge!(h1) 
	end
	for current_site in 0...@state_sites.length
		state_site_value=Array.new
		state_site_value.push({"title"=>@state_sites[current_site]["link_title"]})
		state_site_value.push({"description"=>@state_sites[current_site]["description"]})
		state_site_value.push({"url"=>@state_sites[current_site]["url"]})
		h1={"state_site_item"+current_site.to_s =>state_site_value}
		result.merge!(h1) 
	end
	for current_site in 0...@sites_for_business_type.length
		sites_for_business_value=Array.new
		sites_for_business_value.push({"title"=>@sites_for_business_type[current_site]["link_title"]})
		sites_for_business_value.push({"description"=>@sites_for_business_type[current_site]["description"]})
		sites_for_business_value.push({"url"=>@sites_for_business_type[current_site]["url"]})
		h1={"state_site_item"+current_site.to_s =>sites_for_business_value}
		result.merge!(h1) 
	end
    result.to_json  
  end

  def to_json(options = {})

    result = Hash.new

    for current_site in 0...@county_sites.length
        county_site_value=Array.new
        county_site_value.push({"title"=>@county_sites[current_site][0]["link_title"]})
        county_site_value.push({"description"=>@county_sites[current_site][0]["description"]})
        county_site_value.push({"url"=>@county_sites[current_site][0]["url"]})
        # fixing spell mistake.  schoe 5/20/09
        h1={"county_sites_item"+current_site.to_s =>county_site_value}

        result.merge!(h1) 
    end

    for current_site in 0...@local_sites.length
        local_site_value=Array.new
        local_site_value.push({"title"=>@local_sites[current_site]["link_title"]})
        local_site_value.push({"description"=>@local_sites[current_site]["description"]})
        local_site_value.push({"url"=>@local_sites[current_site]["url"]})

        h1={"state_site_item"+current_site.to_s =>local_site_value}

        result.merge!(h1) 
    end

    for current_site in 0...@state_sites.length
        state_site_value=Array.new
        state_site_value.push({"title"=>@state_sites[current_site]["link_title"]})
        state_site_value.push({"description"=>@state_sites[current_site]["description"]})
        state_site_value.push({"url"=>@state_sites[current_site]["url"]})

        h1={"state_site_item"+current_site.to_s =>state_site_value}

        result.merge!(h1) 
    end

    for current_site in 0...@sites_for_business_type.length
        sites_for_business_value=Array.new
        sites_for_business_value.push({"title"=>@sites_for_business_type[current_site]["link_title"]})
        sites_for_business_value.push({"description"=>@sites_for_business_type[current_site]["description"]})
        sites_for_business_value.push({"url"=>@sites_for_business_type[current_site]["url"]})

        h1={"state_site_item"+current_site.to_s =>sites_for_business_value}

        result.merge!(h1) 
    end

    result.to_json  

  end

end
