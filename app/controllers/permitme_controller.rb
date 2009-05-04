class PermitmeController < ApplicationController
  
  def permitme_by_zip
      @queryResults = PermitmeResource.find_permitme
      respond_to_format (@queryResults)
  end

  def permitme_by_state_only
      @queryResults = PermitmeResource.find(:all, :select =>"permitme_resources.link_title,permitme_resources.url", :joins => @joins) 
      respond_to_format (@queryResults)
  end

  def permitme_by_state_and_feature
      @queryResults = PermitmeResource.find(:all, :select =>"permitme_resources.link_title,permitme_resources.url", :joins => @joins)  
      respond_to_format (@queryResults)
  end
  
  def respond_to_format (resultArray)
      respond_to do |format|
        format.xml {render :xml => resultArray}
        format.json {render :json => resultArray}
      end
  end
  
end