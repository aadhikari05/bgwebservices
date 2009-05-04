class PermitmeController < ApplicationController
  
#  layout "show"
  
  def show
      @joins = "left outer join permitme_resource_groups on permitme_resource_groups.id = permitme_resources.permitme_resource_group_id group by permitme_resources.permitme_resource_group_id"
      @queryResults = PermitmeResource.find(:all, :select =>"permitme_resources.link_title,permitme_resources.url", :joins => @joins)  
  end

  def permitme_by_zip
      @joins = "left outer join permitme_resource_groups on permitme_resource_groups.id = permitme_resources.permitme_resource_group_id group by permitme_resources.permitme_resource_group_id"
      @queryResults = PermitmeResource.find(:all, :select =>"permitme_resources.link_title,permitme_resources.url", :joins => @joins)  
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