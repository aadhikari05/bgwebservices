module GrantLoanHelper
    
    def GrantLoanHelper.get_grants_and_loans (state_alpha, business_type, industry, business_task)
        state_id = GrantLoanHelper.getStateIDFromStateAlpha(state_alpha)
        state_name = GrantLoanHelper.getStateIDFromStateAlpha(state_alpha)
        
        #Get results individually based on the parameters and then add to the results
#        type_array = ["general_purpose","development","exporting","contractor","green","military","minority","woman","disabled","rural","disaster"]
        type_array = business_task.split("-")
        result_array = Array.new
        this_result = GrantLoanResult.new
        
        type_array.each do |type_name|
            result_array << GrantLoanHelper.get_is_type_results(business_type, type_name)
#            result_array = GrantLoan.find(:all, :select => "title, description, url,loan_type, state_name, agency,gov_type", :conditions => ["business_type like ? and is_"+type_name+"=1", '%'+business_type+'%'])
        end
        
        result_array << GrantLoanHelper.get_industry_results (business_type, industry)

                    result_array.collect do |result|
                      for j in 0...result.length
                         #Check whether each grant_loan is federal (state is empty) or for the state requested
#                         if result[j]["state_name"].empty? or result[j]["state_name"].eql?(state_name)
                             if result[j]["loan_type"].eql?("Venture Capital")
                                 this_result.venture_results << result[j]
                             elsif result[j]["loan_type"].eql?("grant")
                                 this_result.grant_results << result[j]
                             elsif result[j]["loan_type"].eql?("Tax Incentive")
                                 this_result.tax_results << result[j]
                             else
                                 this_result.loan_results << result[j]
                             end
                         end
                      end
#                    end


        return this_result
    end
    
    def GrantLoanHelper.get_is_type_results (business_type, is_type)
        GrantLoan.find(:all, :select => "title, description, url,loan_type, state_name, agency,gov_type", :conditions => ["business_type like ? and is_"+is_type+"=1", '%'+business_type+'%'])
    end
    
    def GrantLoanHelper.get_industry_results (business_type, industry)
        industry_sql = "select title, description, url,loan_type, state_name, agency, gov_type from grant_loans g, grant_loans_industry gli where "
        industry_sql += " business_type like ? and g.id= any (select gli.grant_loans_id from grant_loans_industry gli, industries i "
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