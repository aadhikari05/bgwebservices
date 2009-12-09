module GrantLoanHelper
    
  def GrantLoanHelper.get_all_federal ()
      GrantLoan.find(:all, :select => "state_name, business_type, title, description, url, loan_type, agency, gov_type, is_general_purpose, is_development, is_exporting, is_contractor, is_green, is_military, is_minority, is_woman, is_disabled, is_rural, is_disaster", :conditions => "gov_type = 'federal'")
  end

  def GrantLoanHelper.get_state_financing (state_alpha)
      state_id = GrantLoanHelper.getStateIDFromStateAlpha(state_alpha)
      GrantLoan.find(:all, :select => "state_name, business_type, title, description, url, loan_type, agency, gov_type, is_general_purpose, is_development, is_exporting, is_contractor, is_green, is_military, is_minority, is_woman, is_disabled, is_rural, is_disaster", :conditions => ["gov_type = 'state' and state_id=?",state_id])
  end

  def GrantLoanHelper.get_federal_and_state_financing (state_alpha)
    state_id = GrantLoanHelper.getStateIDFromStateAlpha(state_alpha)
    GrantLoan.find(:all, :select => "state_name, business_type, title, description, url, loan_type, agency, gov_type, is_general_purpose, is_development, is_exporting, is_contractor, is_green, is_military, is_minority, is_woman, is_disabled, is_rural, is_disaster", :conditions => ["(gov_type = 'federal') or (gov_type = 'state' and state_id=?)",state_id])
  end

    def GrantLoanHelper.get_grants_and_loans (state_alpha, business_type, industry, business_task)
        result_array = Array.new
        this_result = GrantLoanResult.new
  
        if !state_alpha.eql?("nil")
            state_name = GrantLoanHelper.getStateNameFromStateAlpha(state_alpha)
            result_array << GrantLoanHelper.get_state_results (state_name["name"])
        end
        
        if !business_task.eql?("nil")
            #Get results individually based on the parameters and then add to the results
            #type_array = ["general_purpose","development","exporting","contractor","green","military","minority","woman","disabled","rural","disaster"]
            type_array = business_task.split("-")
            type_array.each do |type_name|
                result_array << GrantLoanHelper.get_is_type_results(type_name)
            end
        end

        if !industry.eql?("nil")
            if !GrantLoanHelper.is_industry(industry).empty?
                result_array << GrantLoanHelper.get_industry_results (business_type, industry)
            else
                return this_result
            end
        end
      
        if !business_type.eql?("nil")
            result_array << GrantLoanHelper.get_business_type_results (business_type)
        end
      
        result_array.collect do |result|
            for j in 0...result.length               
#                if result[j]["state_name"].nil? or result[j]["state_name"].eql?("")  or result[j]["state_name"].eql?(state_name["name"])
                     if result[j]["loan_type"].eql?("Venture Capital")
                         this_result.venture_results << result[j]
                     elsif result[j]["loan_type"].eql?("Grant")
                         this_result.grant_results << result[j]
                     elsif result[j]["loan_type"].eql?("Tax Incentive")
                         this_result.tax_results << result[j]
                     else
                         this_result.loan_results << result[j]
                     end
#               end
            end
        end

        return this_result
    end
    
    def GrantLoanHelper.get_is_type_results (is_type)
        GrantLoan.find(:all, :select => "state_name, business_type, title, description, url,loan_type, state_name, agency,gov_type, is_general_purpose, is_development, is_exporting, is_contractor, is_green, is_military, is_minority, is_woman, is_disabled, is_rural, is_disaster", :conditions => ["is_"+is_type+"=1"])
    end

    def GrantLoanHelper.get_business_type_results (business_type)
        GrantLoan.find(:all, :select => "state_name, business_type, title, description, url,loan_type, state_name, agency,gov_type, is_general_purpose, is_development, is_exporting, is_contractor, is_green, is_military, is_minority, is_woman, is_disabled, is_rural, is_disaster", :conditions => ["business_type like ?", '%'+business_type+'%'])
    end

    def GrantLoanHelper.is_industry(industry)
        Industry.find(:all, :select =>"name", :conditions =>["name = ?", industry])
    end
    
    def GrantLoanHelper.get_state_results (state_name)
        GrantLoan.find(:all, :select => "state_name, business_type, title, description, url, loan_type, state_name, agency, gov_type, is_general_purpose, is_development, is_exporting, is_contractor, is_green, is_military, is_minority, is_woman, is_disabled, is_rural, is_disaster", :conditions => ["state_name = ?",state_name])
    end

    def GrantLoanHelper.get_industry_results (business_type, industry)
        industry_sql = "select state_name, business_type, title, description, url,loan_type, state_name, agency, gov_type, is_general_purpose, is_development, is_exporting, is_contractor, is_green, is_military, is_minority, is_woman, is_disabled, is_rural, is_disaster "
        industry_sql += "from grant_loans g, grant_loans_industry gli where "
        industry_sql += " business_type like ? and g.id= any "
        industry_sql += "(select gli.grant_loans_id from grant_loans_industry gli, industries i "
        industry_sql += " where gli.industry_id=i.id and i.name=?) and gli.grant_loans_id=g.id"
        
        GrantLoan.find_by_sql([industry_sql, '%'+business_type+'%', industry])
    end
    
    def GrantLoanHelper.getStateIDFromStateAlpha(state_alpha)
        State.find(:first, :select => "id", :conditions => ["alpha = ?",state_alpha])
    end

    def GrantLoanHelper.getStateNameFromStateAlpha(state_alpha)
        State.find(:first, :select => "name", :conditions => ["alpha = ?",state_alpha])
    end    
end