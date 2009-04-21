class State < ActiveRecord::Base
  has_many :features
  has_many :grant_loans
  has_many :state_recommended_sites 
  has_many :permitme_resource_groups
  has_and_belongs_to_many :grant_loans, :join_table => "grant_loan_state", :foreign_key => "state_id", :association_foreign_key => "grant_loan_id"
  
#  has_many :state_recommended_site_keywords, :through => :state_recommended_sites
#  has_many :recommended_site_categories, :through => :state_recommended_sites
end
