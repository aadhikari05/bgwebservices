class GrantLoanController < ApplicationController
  
  #http://localhost:3000/grant_loan/va/for_profit/nil/nil.xml
  #http://localhost:3000/grant_loan/nil/non_profit/nil/woman.xml  
  def show_all
      state_alpha = params[:state_alpha]
      business_type = params[:business_type]
      industry = params[:industry]
      specialty_type = params[:specialty_type]
      
      respond_to_format(GrantLoanHelper.get_grants_and_loans(state_alpha, business_type, industry, specialty_type))
  end
  
  #http://localhost:3000/grant_loan/federal.xml
  def all_federal
      respond_to_format(GrantLoanHelper.get_all_federal())
  end
  
  #http://localhost:3000/grant_loan/state_financing_for/va.xml
  def state_financing
      state_alpha = params[:state_alpha]
      respond_to_format(GrantLoanHelper.get_state_financing(state_alpha))
  end
  
  #http://localhost:3000/grant_loan/federal_and_state_financing_for/va.xml
  def federal_and_state_financing
      state_alpha = params[:state_alpha]
      respond_to_format(GrantLoanHelper.get_federal_and_state_financing(state_alpha))
  end
  
  #http://localhost:3000/grant_loan/all_financing_for/:specialty_type.xml
  def all_specialty_type_financing
      specialty_type = params[:specialty_type]
      
      respond_to_format(GrantLoanHelper.get_grants_and_loans(state_alpha, business_type, industry, specialty_type))
  end
  
  def respond_to_format(resultArray)
      respond_to do |format|
 		      format.html { render :text => resultArray.to_json }
          format.xml {render :xml => resultArray}
          format.json {render :json => resultArray}
      end
  end
  
end

