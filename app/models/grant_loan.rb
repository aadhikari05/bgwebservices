class GrantLoan < ActiveRecord::Base
      has_and_belongs_to_many :industries, :join_table => "grant_loans_industry", :foreign_key => "grant_loans_id", :association_foreign_key => "industry_id"
      has_and_belongs_to_many :states, :join_table => "grant_loan_state", :foreign_key => "grant_loan_id", :association_foreign_key => "state_id"
end
