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
       
        xml.loan_results do |loan|
            for current_site in 0...@loan_results.length
              xml.loan do
                loan.state_name(@loan_results[current_site]["state_name"])
                loan.business_type(@loan_results[current_site]["business_type"])
                loan.gov_type(@loan_results[current_site]["gov_type"])
                loan.loan_type(@loan_results[current_site]["loan_type"])
                loan.agency(@loan_results[current_site]["agency"])
                loan.industry(@loan_results[current_site]["industry"])
                loan.title(@loan_results[current_site]["title"])
                loan.description(@loan_results[current_site]["description"])
                loan.url(@loan_results[current_site]["url"])
                loan.is_general_purpose(@loan_results[current_site]["is_general_purpose"])
                loan.is_development(@loan_results[current_site]["is_development"])
                loan.is_exporting(@loan_results[current_site]["is_exporting"])
                loan.is_contractor(@loan_results[current_site]["is_contractor"])
                loan.is_green(@loan_results[current_site]["is_green"])
                loan.is_military(@loan_results[current_site]["is_military"])
                loan.is_minority(@loan_results[current_site]["is_minority"])
                loan.is_woman(@loan_results[current_site]["is_woman"])
                loan.is_disabled(@loan_results[current_site]["is_disabled"])
                loan.is_rural(@loan_results[current_site]["is_rural"])
                loan.is_disaster(@loan_results[current_site]["is_disaster"])
              end
            end
        end
        
        xml.venture_capital_results do |venture_capital|
            for current_site in 0...@venture_results.length
              xml.venture_capital do
                venture_capital.state_name(@venture_results[current_site]["state_name"])
                venture_capital.business_type(@venture_results[current_site]["business_type"])
                venture_capital.gov_type(@venture_results[current_site]["gov_type"])
                venture_capital.loan_type(@venture_results[current_site]["loan_type"])
                venture_capital.agency(@venture_results[current_site]["agency"])
                venture_capital.industry(@venture_results[current_site]["industry"])
                venture_capital.title(@venture_results[current_site]["title"])
                venture_capital.description(@venture_results[current_site]["description"])
                venture_capital.url(@venture_results[current_site]["url"])
                venture_capital.is_general_purpose(@venture_results[current_site]["is_general_purpose"])
                venture_capital.is_development(@venture_results[current_site]["is_development"])
                venture_capital.is_exporting(@venture_results[current_site]["is_exporting"])
                venture_capital.is_contractor(@venture_results[current_site]["is_contractor"])
                venture_capital.is_green(@venture_results[current_site]["is_green"])
                venture_capital.is_military(@venture_results[current_site]["is_military"])
                venture_capital.is_minority(@venture_results[current_site]["is_minority"])
                venture_capital.is_woman(@venture_results[current_site]["is_woman"])
                venture_capital.is_disabled(@venture_results[current_site]["is_disabled"])
                venture_capital.is_rural(@venture_results[current_site]["is_rural"])
                venture_capital.is_disaster(@venture_results[current_site]["is_disaster"])
              end
            end
        end
        
        xml.tax_incentive_results do |tax_incentive|
            for current_site in 0...@tax_results.length
              xml.tax_incentive do
                tax_incentive.state_name(@tax_results[current_site]["state_name"])
                tax_incentive.business_type(@tax_results[current_site]["business_type"])
                tax_incentive.gov_type(@tax_results[current_site]["gov_type"])
                tax_incentive.loan_type(@tax_results[current_site]["loan_type"])
                tax_incentive.agency(@tax_results[current_site]["agency"])
                tax_incentive.industry(@tax_results[current_site]["industry"])
                tax_incentive.title(@tax_results[current_site]["title"])
                tax_incentive.description(@tax_results[current_site]["description"])
                tax_incentive.url(@tax_results[current_site]["url"])
                tax_incentive.is_general_purpose(@tax_results[current_site]["is_general_purpose"])
                tax_incentive.is_development(@tax_results[current_site]["is_development"])
                tax_incentive.is_exporting(@tax_results[current_site]["is_exporting"])
                tax_incentive.is_contractor(@tax_results[current_site]["is_contractor"])
                tax_incentive.is_green(@tax_results[current_site]["is_green"])
                tax_incentive.is_military(@tax_results[current_site]["is_military"])
                tax_incentive.is_minority(@tax_results[current_site]["is_minority"])
                tax_incentive.is_woman(@tax_results[current_site]["is_woman"])
                tax_incentive.is_disabled(@tax_results[current_site]["is_disabled"])
                tax_incentive.is_rural(@tax_results[current_site]["is_rural"])
                tax_incentive.is_disaster(@tax_results[current_site]["is_disaster"])
              end
            end
        end
         xml.grant_results do |grant|
            for current_site in 0...@grant_results.length
              xml.grant do
                grant.state_name(@grant_results[current_site]["state_name"])
                grant.business_type(@grant_results[current_site]["business_type"])
                grant.gov_type(@grant_results[current_site]["gov_type"])
                grant.loan_type(@grant_results[current_site]["loan_type"])
                grant.agency(@grant_results[current_site]["agency"])
                grant.industry(@grant_results[current_site]["industry"])
                grant.title(@grant_results[current_site]["title"])
                grant.description(@grant_results[current_site]["description"])
                grant.url(@grant_results[current_site]["url"])
                grant.is_general_purpose(@grant_results[current_site]["is_general_purpose"])
                grant.is_development(@grant_results[current_site]["is_development"])
                grant.is_exporting(@grant_results[current_site]["is_exporting"])
                grant.is_contractor(@grant_results[current_site]["is_contractor"])
                grant.is_green(@grant_results[current_site]["is_green"])
                grant.is_military(@grant_results[current_site]["is_military"])
                grant.is_minority(@grant_results[current_site]["is_minority"])
                grant.is_woman(@grant_results[current_site]["is_woman"])
                grant.is_disabled(@grant_results[current_site]["is_disabled"])
                grant.is_rural(@grant_results[current_site]["is_rural"])
                grant.is_disaster(@grant_results[current_site]["is_disaster"])
              end
            end
        end
        
    end
  end
  
  def to_json(options = {})
      result = Hash.new
	
    	for current_site in 0...@grant_results.length
      		grant_result_value=Array.new
      		grant_result_value.push({"state_name"=>@grant_results[current_site]["state_name"]})
      		grant_result_value.push({"business_type"=>@grant_results[current_site]["business_type"]})
      		grant_result_value.push({"gov_type"=>@grant_results[current_site]["gov_type"]})
      		grant_result_value.push({"loan_type"=>@grant_results[current_site]["loan_type"]})
      		grant_result_value.push({"agency"=>@grant_results[current_site]["agency"]})
      		grant_result_value.push({"industry"=>@grant_results[current_site]["industry"]})
      		grant_result_value.push({"title"=>@grant_results[current_site]["title"]})
      		grant_result_value.push({"description"=>@grant_results[current_site]["description"]})
      		grant_result_value.push({"url"=>@grant_results[current_site]["url"]})
          grant_result_value.push({"is_general_purpose"=>@grant_results[current_site]["is_general_purpose"]})
          grant_result_value.push({"is_development"=>@grant_results[current_site]["is_development"]})
          grant_result_value.push({"is_exporting"=>@grant_results[current_site]["is_exporting"]})
          grant_result_value.push({"is_contractor"=>@grant_results[current_site]["is_contractor"]})
          grant_result_value.push({"is_green"=>@grant_results[current_site]["is_green"]})
          grant_result_value.push({"is_military"=>@grant_results[current_site]["is_military"]})
          grant_result_value.push({"is_minority"=>@grant_results[current_site]["is_minority"]})
          grant_result_value.push({"is_woman"=>@grant_results[current_site]["is_woman"]})
          grant_result_value.push({"is_disabled"=>@grant_results[current_site]["is_disabled"]})
          grant_result_value.push({"is_rural"=>@grant_results[current_site]["is_rural"]})
          grant_result_value.push({"is_disaster"=>@grant_results[current_site]["is_disaster"]})
      		h1={"grant_results_item"+current_site.to_s =>state_site_value}
      		result.merge!(h1) 
    	end
    	for current_site in 0...@loan_results.length
      		loan_result_value=Array.new
      		loan_result_value.push({"state_name"=>@loan_results[current_site]["state_name"]})
      		loan_result_value.push({"business_type"=>@loan_results[current_site]["business_type"]})
      		loan_result_value.push({"gov_type"=>@loan_results[current_site]["gov_type"]})
      		loan_result_value.push({"loan_type"=>@loan_results[current_site]["loan_type"]})
      		loan_result_value.push({"agency"=>@loan_results[current_site]["agency"]})
      		loan_result_value.push({"industry"=>@loan_results[current_site]["industry"]})
      		loan_result_value.push({"title"=>@loan_results[current_site]["title"]})
      		loan_result_value.push({"description"=>@loan_results[current_site]["description"]})
      		loan_result_value.push({"url"=>@loan_results[current_site]["url"]})
          loan_result_value.push({"is_general_purpose"=>@loan_results[current_site]["is_general_purpose"]})
          loan_result_value.push({"is_development"=>@loan_results[current_site]["is_development"]})
          loan_result_value.push({"is_exporting"=>@loan_results[current_site]["is_exporting"]})
          loan_result_value.push({"is_contractor"=>@loan_results[current_site]["is_contractor"]})
          loan_result_value.push({"is_green"=>@loan_results[current_site]["is_green"]})
          loan_result_value.push({"is_military"=>@loan_results[current_site]["is_military"]})
          loan_result_value.push({"is_minority"=>@loan_results[current_site]["is_minority"]})
          loan_result_value.push({"is_woman"=>@loan_results[current_site]["is_woman"]})
          loan_result_value.push({"is_disabled"=>@loan_results[current_site]["is_disabled"]})
          loan_result_value.push({"is_rural"=>@loan_results[current_site]["is_rural"]})
          loan_result_value.push({"is_disaster"=>@loan_results[current_site]["is_disaster"]})
      		h1={"loan_result_item"+current_site.to_s =>loan_result_value}
      		result.merge!(h1) 
    	end
    	for current_site in 0...@venture_results.length
      		venture_result_value=Array.new
      		venture_result_value.push({"state_name"=>@venture_results[current_site]["state_name"]})
      		venture_result_value.push({"business_type"=>@venture_results[current_site]["business_type"]})
      		venture_result_value.push({"gov_type"=>@venture_results[current_site]["gov_type"]})
      		venture_result_value.push({"loan_type"=>@venture_results[current_site]["loan_type"]})
      		venture_result_value.push({"agency"=>@venture_results[current_site]["agency"]})
      		venture_result_value.push({"industry"=>@venture_results[current_site]["industry"]})
      		venture_result_value.push({"title"=>@venture_results[current_site]["title"]})
      		venture_result_value.push({"description"=>@venture_results[current_site]["description"]})
      		venture_result_value.push({"url"=>@venture_results[current_site]["url"]})
          venture_result_value.push({"is_general_purpose"=>@venture_results[current_site]["is_general_purpose"]})
          venture_result_value.push({"is_development"=>@venture_results[current_site]["is_development"]})
          venture_result_value.push({"is_exporting"=>@venture_results[current_site]["is_exporting"]})
          venture_result_value.push({"is_contractor"=>@venture_results[current_site]["is_contractor"]})
          venture_result_value.push({"is_green"=>@venture_results[current_site]["is_green"]})
          venture_result_value.push({"is_military"=>@venture_results[current_site]["is_military"]})
          venture_result_value.push({"is_minority"=>@venture_results[current_site]["is_minority"]})
          venture_result_value.push({"is_woman"=>@venture_results[current_site]["is_woman"]})
          venture_result_value.push({"is_disabled"=>@venture_results[current_site]["is_disabled"]})
          venture_result_value.push({"is_rural"=>@venture_results[current_site]["is_rural"]})
          venture_result_value.push({"is_disaster"=>@venture_results[current_site]["is_disaster"]})
      		h1={"venture_result_item"+current_site.to_s =>venture_result_value}
      		result.merge!(h1) 
    	end
    	for current_site in 0...@tax_results.length
      		tax_result_value=Array.new
      		tax_result_value.push({"state_name"=>@tax_results[current_site]["state_name"]})
      		tax_result_value.push({"business_type"=>@tax_results[current_site]["business_type"]})
      		tax_result_value.push({"gov_type"=>@tax_results[current_site]["gov_type"]})
      		tax_result_value.push({"loan_type"=>@tax_results[current_site]["loan_type"]})
      		tax_result_value.push({"agency"=>@tax_results[current_site]["agency"]})
      		tax_result_value.push({"industry"=>@tax_results[current_site]["industry"]})
      		tax_result_value.push({"title"=>@tax_results[current_site]["title"]})
      		tax_result_value.push({"description"=>@tax_results[current_site]["description"]})
      		tax_result_value.push({"url"=>@tax_results[current_site]["url"]})
          tax_result_value.push({"is_general_purpose"=>@tax_results[current_site]["is_general_purpose"]})
          tax_result_value.push({"is_development"=>@tax_results[current_site]["is_development"]})
          tax_result_value.push({"is_exporting"=>@tax_results[current_site]["is_exporting"]})
          tax_result_value.push({"is_contractor"=>@tax_results[current_site]["is_contractor"]})
          tax_result_value.push({"is_green"=>@tax_results[current_site]["is_green"]})
          tax_result_value.push({"is_military"=>@tax_results[current_site]["is_military"]})
          tax_result_value.push({"is_minority"=>@tax_results[current_site]["is_minority"]})
          tax_result_value.push({"is_woman"=>@tax_results[current_site]["is_woman"]})
          tax_result_value.push({"is_disabled"=>@tax_results[current_site]["is_disabled"]})
          tax_result_value.push({"is_rural"=>@tax_results[current_site]["is_rural"]})
          tax_result_value.push({"is_disaster"=>@tax_results[current_site]["is_disaster"]})
      		h1={"tax_result_item"+current_site.to_s =>tax_result_value}
      		result.merge!(h1) 
    	end
      result.to_json  
  end

end
