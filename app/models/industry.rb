class Industry < ActiveRecord::Base
      has_and_belongs_to_many :grant_loans, :join_table => "grant_loans_industry", :foreign_key => "industry_id", :association_foreign_key => "grant_loans_id"
end
