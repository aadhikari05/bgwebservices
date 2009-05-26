module GrantLoanHelper

    def GrantLoanHelper.get_grant_loans (state_alpha)
        GrantLoan.find(:all, :select => "agency, title, description, url", :joins => ("LEFT OUTER JOIN `grant_loan_state` ON `grant_loan_state`.grant_loan_id = `grant_loans`.id LEFT OUTER JOIN `states` ON `states`.id = `grant_loan_state`.state_id LEFT OUTER JOIN `grant_loans_industry` ON `grant_loans_industry`.grant_loans_id = `grant_loans`.id LEFT OUTER JOIN `industries` ON `industries`.id = `grant_loans_industry`.industry_id"), :conditions => (["states.alpha = ?", state_alpha]))
    end
end