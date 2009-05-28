class GrantLoanResult
  
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
    
    @grant_results.sort! {|a,b| a.title <=> b.title }
    @loan_results.sort! {|a,b| a.title <=> b.title }
    @venture_results.sort! {|a,b| a.title <=> b.title }
    @tax_results.sort! {|a,b| a.title <=> b.title }
    
    xml.result do
        xml.grant_results do |grant|
            for current_site in 0...@grant_results.length
              xml.grant do
                grant.agency(@grant_results[current_site]["agency"])
                grant.title(@grant_results[current_site]["title"])
                grant.description(@grant_results[current_site]["description"])
                grant.url(@grant_results[current_site]["url"])
              end
            end
        end
        
        xml.loan_results do |loan|
            for current_site in 0...@loan_results.length
              xml.loan do
                loan.agency(@loan_results[current_site]["agency"])
                loan.title(@loan_results[current_site]["title"])
                loan.description(@loan_results[current_site]["description"])
                loan.url(@loan_results[current_site]["url"])
              end
            end
        end
        
        xml.venture_capital_results do |venture_capital|
            for current_site in 0...@venture_results.length
              xml.venture_capital do
                venture_capital.agency(@venture_results[current_site]["agency"])
                venture_capital.title(@venture_results[current_site]["title"])
                venture_capital.description(@venture_results[current_site]["description"])
                venture_capital.url(@venture_results[current_site]["url"])
              end
            end
        end
        
        xml.tax_incentive_results do |tax_incentive|
            for current_site in 0...@tax_results.length
              xml.tax_incentive do
                tax_incentive.agency(@tax_results[current_site]["agency"])
                tax_incentive.title(@tax_results[current_site]["title"])
                tax_incentive.description(@tax_results[current_site]["description"])
                tax_incentive.url(@tax_results[current_site]["url"])
              end
            end
        end
    end
  end
  
  def to_json(options = {})
      result = Hash.new
	
    	for current_site in 0...@grant_results.length
      		grant_result_value=Array.new
      		grant_result_value.push({"title"=>@grant_results[current_site]["title"]})
      		grant_result_value.push({"description"=>@grant_results[current_site]["description"]})
      		grant_result_value.push({"url"=>@grant_results[current_site]["url"]})
      		h1={"grant_results_item"+current_site.to_s =>state_site_value}
      		result.merge!(h1) 
    	end
    	for current_site in 0...@loan_results.length
      		loan_result_value=Array.new
      		loan_result_value.push({"title"=>@loan_results[current_site]["title"]})
      		loan_result_value.push({"description"=>@loan_results[current_site]["description"]})
      		loan_result_value.push({"url"=>@loan_results[current_site]["url"]})
      		h1={"state_site_item"+current_site.to_s =>loan_result_value}
      		result.merge!(h1) 
    	end
    	for current_site in 0...@venture_results.length
      		state_site_value=Array.new
      		state_site_value.push({"title"=>@venture_results[current_site]["title"]})
      		state_site_value.push({"description"=>@venture_results[current_site]["description"]})
      		state_site_value.push({"url"=>@venture_results[current_site]["url"]})
      		h1={"state_site_item"+current_site.to_s =>state_site_value}
      		result.merge!(h1) 
    	end
    	for current_site in 0...@tax_results.length
      		sites_for_business_value=Array.new
      		sites_for_business_value.push({"title"=>@tax_results[current_site]["title"]})
      		sites_for_business_value.push({"description"=>@tax_results[current_site]["description"]})
      		sites_for_business_value.push({"url"=>@tax_results[current_site]["url"]})
  		
      		h1={"state_site_item"+current_site.to_s =>sites_for_business_value}
      		result.merge!(h1) 
    	end
      result.to_json  
  end

end
