module GrantLoanHelper

    def GrantLoanHelper.get_grant_loans
        GrantLoan.find(:all)
    end
end