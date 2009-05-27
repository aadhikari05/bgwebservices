module GrantLoanHelper

    #This method assumes a many-to-many relationship between grant_loan and state.
    #In the production grant_loan_state table there are only two entries, though.
    #Keeping this method in case there is a switch over to many-to-many later on.
    def GrantLoanHelper.get_grant_loans (state_alpha)
        GrantLoan.find(:all, :select => "agency, title, description, url", :joins => ("LEFT OUTER JOIN `grant_loan_state` ON `grant_loan_state`.grant_loan_id = `grant_loans`.id LEFT OUTER JOIN `states` ON `states`.id = `grant_loan_state`.state_id LEFT OUTER JOIN `grant_loans_industry` ON `grant_loans_industry`.grant_loans_id = `grant_loans`.id LEFT OUTER JOIN `industries` ON `industries`.id = `grant_loans_industry`.industry_id"), :conditions => (["states.alpha = ?", state_alpha]))
    end
    
    def GrantLoanHelper.get_grants_and_loans (state_alpha, business_type, industry, business_task)
        state_id = GrantLoanHelper.getStateIDFromStateAlpha(state_alpha)
        
        #Get results individually based on the parameters and then add to the results
        type_array = ["general_purpose","development","exporting","contractor","green","military","minority","woman","disabled","rural","disaster"]
        result_array = Array.new
        
        type_array.each do |type_name|
            result_array << GrantLoanHelper.get_is_type_results(business_type, type_name)
        end
        
        return result_array
#        GrantLoan.find(:all, :select => "agency, title, description, url", :conditions => ["state_id = ?", state_id])
    end
    
    def GrantLoanHelper.get_is_type_results (business_type, is_type)
        GrantLoan.find(:all, :select => "title, description, url,loan_type, state_name, agency,gov_type", :conditions => ["business_type like ? and is_"+is_type+"=1", '%'+business_type+'%'])
    end
    
    def GrantLoanHelper.get_industry_results (business_type, industry)
        industry_condition = "select title, description, url,loan_type, state_name, agency, gov_type from grant_loans g, grant_loans_industry gli where "
        industry_condition += " business_type like ? and g.id= any (select gli.grant_loans_id from grant_loans_industry gli, industries i "
        industry_condition += " where gli.industry_id=i.id and i.name=?) and gli.grant_loans_id=g.id"
        
        GrantLoan.find(:all, :select => "title, description, url,loan_type, state_name, agency,gov_type", :conditions => [industry_condition, '%'+business_type+'%', industry])
    end
    
    def GrantLoanHelper.getStateIDFromStateAlpha(state_alpha)
        State.find(:first, :select => "id", :conditions => ["alpha = ?",state_alpha])
    end

    def GrantLoanHelper.getStateAlphaFromStateID(state_id)
        State.find(:first, :select => "alpha", :conditions => ["id = ?",state_id])
    end

    
end