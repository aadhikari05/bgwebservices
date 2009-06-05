class GrantLoanController < ApplicationController
  
  #grant_loan/:state_alpha/:business_type/:industry/:business_task
  def show_all
      state_alpha = params[:state_alpha]
      business_type = params[:business_type]
      industry = params[:industry]
      business_task = params[:business_task]
      
      respond_to_format(GrantLoanHelper.get_grants_and_loans(state_alpha, business_type, industry, business_task))
  end
  
  def respond_to_format(resultArray)
      respond_to do |format|
 		      format.html { render :text => resultArray.to_json }
          format.xml {render :xml => resultArray}
          format.json {render :json => resultArray}
      end
  end
  
end
