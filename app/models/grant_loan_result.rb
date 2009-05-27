class Result
  
  attr_accessor :grant_results, :loan_results, :venture_results, :tax_results 
  
  def initialize
    @grant_results = Array.new
    @loan_results = Array.new
    @venture_results = Array.new
    @tax_results = Array.new

  end
    
  def to_xml(options = {})
    xml = options[:builder] ||= Builder::XmlMarkup.new(:indent => options[:indent])
    xml.instruct! unless options[:skip_instruct => true, :dasherize => false]
    
    @grant_results.sort! {|a,b| a.link_title <=> b.link_title }
    @loan_results.sort! {|a,b| a.link_title <=> b.link_title }
    @venture_results.sort! {|a,b| a.link_title <=> b.link_title }
    @tax_results.sort! {|a,b| a.link_title <=> b.link_title }
    
    xml.result do
        xml.grant_results do |site|
            for current_site in 0...@grant_results.length
              xml.site do
                site.link_title(@grant_results[current_site][0]["link_title"])
                site.description(@grant_results[current_site][0]["description"])
                site.url(@grant_results[current_site][0]["url"])
              end
            end
        end
        
        xml.loan_results do |site|
            for current_site in 0...@loan_results.length
              xml.site do
                site.link_title(@loan_results[current_site]["link_title"])
                site.description(@loan_results[current_site]["description"])
                site.url(@loan_results[current_site]["url"])
              end
            end
        end
        
        xml.venture_results do |site|
            for current_site in 0...@venture_results.length
              xml.site do
                site.link_title(@venture_results[current_site]["link_title"])
                site.description(@venture_results[current_site]["description"])
                site.url(@venture_results[current_site]["url"])
              end
            end
        end
        
        xml.tax_results do |site|
            for current_site in 0...@tax_results.length
              xml.site do
                site.link_title(@tax_results[current_site]["link_title"])
                site.description(@tax_results[current_site]["description"])
                site.url(@tax_results[current_site]["url"])
              end
            end
        end
    end
  end
  
  def to_json(options = {})
    result = Hash.new
	
	for current_site in 0...@grant_results.length
  		grant_result_value=Array.new
  		grant_result_value.push({"title"=>@grant_results[current_site]["link_title"]})
  		grant_result_value.push({"description"=>@grant_results[current_site]["description"]})
  		grant_result_value.push({"url"=>@grant_results[current_site]["url"]})
  		h1={"grant_results_item"+current_site.to_s =>state_site_value}
  		result.merge!(h1) 
	end
	for current_site in 0...@loan_results.length
  		loan_result_value=Array.new
  		loan_result_value.push({"title"=>@loan_results[current_site]["link_title"]})
  		loan_result_value.push({"description"=>@loan_results[current_site]["description"]})
  		loan_result_value.push({"url"=>@loan_results[current_site]["url"]})
  		h1={"state_site_item"+current_site.to_s =>loan_result_value}
  		result.merge!(h1) 
	end
	for current_site in 0...@venture_results.length
  		state_site_value=Array.new
  		state_site_value.push({"title"=>@venture_results[current_site]["link_title"]})
  		state_site_value.push({"description"=>@venture_results[current_site]["description"]})
  		state_site_value.push({"url"=>@venture_results[current_site]["url"]})
  		h1={"state_site_item"+current_site.to_s =>state_site_value}
  		result.merge!(h1) 
	end
	for current_site in 0...@tax_results.length
  		sites_for_business_value=Array.new
  		sites_for_business_value.push({"title"=>@tax_results[current_site]["link_title"]})
  		sites_for_business_value.push({"description"=>@tax_results[current_site]["description"]})
  		sites_for_business_value.push({"url"=>@tax_results[current_site]["url"]})
  		
  		h1={"state_site_item"+current_site.to_s =>sites_for_business_value}
  		result.merge!(h1) 
	end
    result.to_json  
  end

  def to_json(options = {})

    result = Hash.new

    for current_site in 0...@grant_results.length
        grant_result_value=Array.new
        grant_result_value.push({"title"=>@grant_results[current_site][0]["link_title"]})
        grant_result_value.push({"description"=>@grant_results[current_site][0]["description"]})
        grant_result_value.push({"url"=>@grant_results[current_site][0]["url"]})
        
        h1={"grant_results_item"+current_site.to_s =>grant_result_value}

        result.merge!(h1) 
    end

    for current_site in 0...@loan_results.length
        loan_result_value=Array.new
        loan_result_value.push({"title"=>@loan_results[current_site]["link_title"]})
        loan_result_value.push({"description"=>@loan_results[current_site]["description"]})
        loan_result_value.push({"url"=>@loan_results[current_site]["url"]})

        h1={"state_site_item"+current_site.to_s =>loan_result_value}

        result.merge!(h1) 
    end

    for current_site in 0...@venture_results.length
        state_site_value=Array.new
        state_site_value.push({"title"=>@venture_results[current_site]["link_title"]})
        state_site_value.push({"description"=>@venture_results[current_site]["description"]})
        state_site_value.push({"url"=>@venture_results[current_site]["url"]})

        h1={"state_site_item"+current_site.to_s =>state_site_value}

        result.merge!(h1) 
    end

    for current_site in 0...@tax_results.length
        sites_for_business_value=Array.new
        sites_for_business_value.push({"title"=>@tax_results[current_site]["link_title"]})
        sites_for_business_value.push({"description"=>@tax_results[current_site]["description"]})
        sites_for_business_value.push({"url"=>@tax_results[current_site]["url"]})

        h1={"state_site_item"+current_site.to_s =>sites_for_business_value}

        result.merge!(h1) 
    end

    result.to_json  

  end

end
