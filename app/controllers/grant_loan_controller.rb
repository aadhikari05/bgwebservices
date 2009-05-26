class GrantLoanController < ApplicationController
  
  before_filter :login_required
  
  layout "admin"
  active_scaffold :grant_loan do |config|
 
    config.columns = [:agency, :url, :title, :description, :loan_type, :gov_type, :states, :business_type, :industries, :is_general_purpose, :is_development, :is_exporting, :is_contractor, :is_green, :is_military, :is_minority, :is_woman, :is_disabled, :is_rural, :is_disaster]
 
    config.list.columns = [:agency, :gov_type, :title, :url]

    config.columns.exclude  :state_name, :state_id

    config.label = 'Grants and Loans'

    columns[:states].form_ui = :select    

    columns[:industries].form_ui = :select 
  end
end

