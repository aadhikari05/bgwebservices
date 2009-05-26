module GrantLoanHelper

    #This method assumes a many-to-many relationship between grant_loan and state.
    #In the production grant_loan_state table there are only two entries, though.
    #Keeping this method in case there is a switch over to many-to-many later on.
    def GrantLoanHelper.get_grant_loans (state_alpha)
        GrantLoan.find(:all, :select => "agency, title, description, url", :joins => ("LEFT OUTER JOIN `grant_loan_state` ON `grant_loan_state`.grant_loan_id = `grant_loans`.id LEFT OUTER JOIN `states` ON `states`.id = `grant_loan_state`.state_id LEFT OUTER JOIN `grant_loans_industry` ON `grant_loans_industry`.grant_loans_id = `grant_loans`.id LEFT OUTER JOIN `industries` ON `industries`.id = `grant_loans_industry`.industry_id"), :conditions => (["states.alpha = ?", state_alpha]))
    end
    
    def GrantLoanHelper.get_grants_and_loans (state_id)
        GrantLoan.find(:all, :select => "agency, title, description, url", :conditions => ["state_id = ?", state_id])
    end
    
    def GrantLoanHelper.getStateIDFromStateAlpha(state_alpha)
        State.find(:first, :select => "id", :conditions => ["alpha = ?",state_alpha])
    end

    def GrantLoanHelper.getStateAlphaFromStateID(state_id)
        State.find(:first, :select => "alpha", :conditions => ["id = ?",state_id])
    end

    
end