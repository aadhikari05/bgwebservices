class Result
  
  attr_accessor :county_sites, :local_sites, :state_sites, :sites_for_business_type , :rec_sites, :sites_for_category
  
  def initialize
    @county_sites = Array.new
    @local_sites = Array.new
    @state_sites = Array.new
    @sites_for_business_type = Array.new
    @rec_sites = Array.new
    @sites_for_category = Array.new
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
    
    if !@county_sites[0].nil?
      if !@county_sites[0][0].nil?
          @county_sites.sort! {|a,b| a.link_title <=> b.link_title}
      end
    end
    @local_sites.sort! {|a,b| a.link_title <=> b.link_title }
    @state_sites.sort! {|a,b| a.link_title <=> b.link_title}
    @sites_for_business_type.sort! {|a,b| a.link_title <=> b.link_title }
    @sites_for_category.sort! {|a,b| a.link_title <=> b.link_title }
    
    xml.result do
        xml.county_sites do |site|
          if !@county_sites[0].nil?
            for current_site in 0...@county_sites[0].length
              xml.site do
                site.link_title(@county_sites[current_site][0]["link_title"])
                site.description(@county_sites[current_site][0]["description"])
                site.url(@county_sites[current_site][0]["url"]) 
                site.category(@county_sites[current_site][0]["category"])
                site.county(@county_sites[current_site][0]["county"])
                site.state(@county_sites[current_site][0]["state"])
                site.business_type(@county_sites[current_site][0]["business_type"])
                site.section(@county_sites[current_site][0]["section"])
                site.resource_group_description(@county_sites[current_site][0]["resource_group_description"])
              end
            end
          end
        end
        
        xml.local_sites do |site|
            for current_site in 0...@local_sites.length
              xml.site do
                site.link_title(@local_sites[current_site]["link_title"])
                site.description(@local_sites[current_site]["description"])
                site.url(@local_sites[current_site]["url"])
                site.category(@local_sites[current_site]["category"])
                site.county(@local_sites[current_site]["county"])
                site.state(@local_sites[current_site]["state"])
                site.business_type(@local_sites[current_site]["business_type"])
                site.section(@local_sites[current_site]["section"])
                site.resource_group_description(@local_sites[current_site]["resource_group_description"])
              end
            end
        end
        
        xml.state_sites do |site|
            for current_site in 0...@state_sites.length
              xml.site do
                site.link_title(@state_sites[current_site]["link_title"])
                site.description(@state_sites[current_site]["description"])
                site.url(@state_sites[current_site]["url"])
                site.category(@state_sites[current_site]["category"])
                site.county(@state_sites[current_site]["county"])
                site.state(@state_sites[current_site]["state"])
                site.business_type(@state_sites[current_site]["business_type"])
                site.section(@state_sites[current_site]["section"])
                site.resource_group_description(@state_sites[current_site]["resource_group_description"])
              end
            end
        end
        
        xml.sites_for_business_type do |site|
            for current_site in 0...@sites_for_business_type.length
              xml.site do
                site.link_title(@sites_for_business_type[current_site]["link_title"])
                site.description(@sites_for_business_type[current_site]["description"])
                site.url(@sites_for_business_type[current_site]["url"])
                site.category(@sites_for_business_type[current_site]["category"])
                site.county(@sites_for_business_type[current_site]["county"])
                site.state(@sites_for_business_type[current_site]["state"])
                site.business_type(@sites_for_business_type[current_site]["business_type"])
                site.section(@sites_for_business_type[current_site]["section"])
                site.resource_group_description(@sites_for_business_type[current_site]["resource_group_description"])
              end
            end
        end

        xml.sites_for_category do |site|
            for current_site in 0...@sites_for_category.length
              xml.site do
                site.link_title(@sites_for_category[current_site]["link_title"])
                site.description(@sites_for_category[current_site]["description"])
                site.url(@sites_for_category[current_site]["url"])
                site.category(@sites_for_category[current_site]["category"])
                site.county(@sites_for_category[current_site]["county"])
                site.state(@sites_for_category[current_site]["state"])
                site.business_type(@sites_for_category[current_site]["business_type"])
                site.section(@sites_for_category[current_site]["section"])
                site.resource_group_description(@sites_for_category[current_site]["resource_group_description"])
              end
            end
        end

    end
  end
  
  def to_json(options = {})
    result = Hash.new
	
	for current_site in 0...@county_sites.length
		county_site_value=Array.new
    if !@county_sites[0].nil?
        if !@county_sites[current_site][0].nil?
      
        else
  		      @county_sites[current_site][0] = ""
  		  end
		else
	      @county_sites[current_site][0]["link_title"] = ""
		end
		county_site_value.push({"title"=>@county_sites[current_site][0]["link_title"]})
		county_site_value.push({"description"=>@county_sites[current_site][0]["description"]})
		county_site_value.push({"url"=>@county_sites[current_site][0]["url"]})
		county_site_value.push({"state"=>@county_sites[current_site][0]["state"]})
		county_site_value.push({"category"=>@county_sites[current_site][0]["category"]})
		county_site_value.push({"county"=>@county_sites[current_site][0]["county"]})
		county_site_value.push({"business_type"=>@county_sites[current_site][0]["business_type"]})
		county_site_value.push({"section"=>@county_sites[current_site][0]["section"]})
		county_site_value.push({"resource_group_description"=>@county_sites[current_site][0]["resource_group_description"]})
		h1={"county_sites_item"+current_site.to_s =>county_site_value}
		result.merge!(h1) 
	end
	for current_site in 0...@local_sites.length
		local_site_value=Array.new
		if @local_sites[current_site].nil?
		    @local_sites[current_site] = ""
		end
		local_site_value.push({"title"=>@local_sites[current_site]["link_title"]})
		local_site_value.push({"description"=>@local_sites[current_site]["description"]})
		local_site_value.push({"url"=>@local_sites[current_site]["url"]})
		local_site_value.push({"state"=>@local_sites[current_site]["state"]})
		local_site_value.push({"category"=>@local_sites[current_site]["category"]})
		local_site_value.push({"county"=>@local_sites[current_site]["county"]})
		local_site_value.push({"business_type"=>@local_sites[current_site]["business_type"]})
		local_site_value.push({"section"=>@local_sites[current_site]["section"]})
		local_site_value.push({"resource_group_description"=>@local_sites[current_site]["resource_group_description"]})
		h1={"local_site_item"+current_site.to_s =>local_site_value}
		result.merge!(h1) 
	end
	for current_site in 0...@state_sites.length
		state_site_value=Array.new
		if @state_sites[current_site].nil?
		    @state_sites[current_site] = ""
		end
		state_site_value.push({"title"=>@state_sites[current_site]["link_title"]})
		state_site_value.push({"description"=>@state_sites[current_site]["description"]})
		state_site_value.push({"url"=>@state_sites[current_site]["url"]})
		state_site_value.push({"state"=>@state_sites[current_site]["state"]})
		state_site_value.push({"category"=>@state_sites[current_site]["category"]})
		state_site_value.push({"county"=>@state_sites[current_site]["county"]})
		state_site_value.push({"business_type"=>@state_sites[current_site]["business_type"]})
		state_site_value.push({"section"=>@state_sites[current_site]["section"]})
		state_site_value.push({"resource_group_description"=>@state_sites[current_site]["resource_group_description"]})
		h1={"state_site_item"+current_site.to_s =>state_site_value}
		result.merge!(h1) 
	end
	for current_site in 0...@sites_for_business_type.length
		sites_for_business_value=Array.new
		if @sites_for_business_type[current_site].nil?
		    @sites_for_business_type[current_site] = ""
		end
		sites_for_business_value.push({"title"=>@sites_for_business_type[current_site]["link_title"]})
		sites_for_business_value.push({"description"=>@sites_for_business_type[current_site]["description"]})
		sites_for_business_value.push({"url"=>@sites_for_business_type[current_site]["url"]})
		sites_for_business_value.push({"state"=>@sites_for_business_type[current_site]["state"]})
		sites_for_business_value.push({"category"=>@sites_for_business_type[current_site]["category"]})
		sites_for_business_value.push({"county"=>@sites_for_business_type[current_site]["county"]})
		sites_for_business_value.push({"business_type"=>@sites_for_business_type[current_site]["business_type"]})
		sites_for_business_value.push({"section"=>@sites_for_business_type[current_site]["section"]})
		sites_for_business_value.push({"resource_group_description"=>@sites_for_business_type[current_site]["resource_group_description"]})
		h1={"business_type_site_item"+current_site.to_s =>sites_for_business_value}
		result.merge!(h1) 
	end

	for current_site in 0...@sites_for_category.length
		sites_for_category_value=Array.new
		if @sites_for_category[current_site]["link_title"].nil?
		    @sites_for_category[current_site]["link_title"] = ""
		end
		sites_for_category_value.push({"title"=>@sites_for_category[current_site]["link_title"]})
		sites_for_category_value.push({"description"=>@sites_for_category[current_site]["description"]})
		sites_for_category_value.push({"url"=>@sites_for_category[current_site]["url"]})
		sites_for_category_value.push({"state"=>@sites_for_category[current_site]["state"]})
		sites_for_category_value.push({"category"=>@sites_for_category[current_site]["category"]})
		sites_for_category_value.push({"county"=>@sites_for_category[current_site]["county"]})
		sites_for_category_value.push({"business_type"=>@sites_for_category[current_site]["business_type"]})
		sites_for_category_value.push({"section"=>@sites_for_category[current_site]["section"]})
		sites_for_category_value.push({"resource_group_description"=>@sites_for_category[current_site]["resource_group_description"]})
		h1={"category_site_item"+current_site.to_s =>sites_for_category_value}
		result.merge!(h1) 
	end

    result.to_json  
  end

end
