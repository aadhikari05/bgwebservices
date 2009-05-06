class PermitmeController < ApplicationController
  
  def permitme_by_zip
      #http://localhost:3000/permitme/by_zip/child%20care%20services/22209.xml
      #Need to test this query and modify if it is not returning resources for that zip
      @queryResults = PermitmeResource.find_by_sql(["select Link_Title, Url from permitme_resources where permitme_resource_group_id in (select id from permitme_resource_groups where permitme_subcategory_id in (select id from permitme_subcategories where isExclusive=1 and isActive=1 and name = ?) and state_id in (select distinct(f.state_id) from features f, zipcodes z where z.zip=? and z.feature_id=f.id))",params[:business_type],params[:zip]])
      
      respond_to_format (@queryResults)
  end

  def permitme_by_state_only
    #http://localhost:3000/permitme/state_only/child%20care%20services/il.xml
    @queryResults = PermitmeResource.find_by_sql(["select Link_Title, Url from permitme_resources where permitme_resource_group_id in (select id from permitme_resource_groups where permitme_subcategory_id in (select id from permitme_subcategories where isExclusive=1 and isActive=1 and name = ?) and state_id in (select id from states where alpha=?))",params[:business_type],params[:alpha]])

      respond_to_format (@queryResults)
  end

  def permitme_by_state_and_feature
    #http://localhost:3000/permitme/state_and_city/child%20care%20services/il/baldwin.xml
    @queryResults = PermitmeResource.find_by_sql(["select Link_Title, Url from permitme_resources where permitme_resource_group_id in (select id from permitme_resource_groups where permitme_subcategory_id in (select id from permitme_subcategories where isExclusive=1 and isActive=1 and name = ?) and state_id in (select distinct(f.state_id) from features f, states s where f.feat_name like ? and s.alpha=? and f.state_id = s.id))",params[:business_type],"%"+params[:feature]+"%",params[:alpha]])

      respond_to_format (@queryResults)
  end
  
  def respond_to_format (resultArray)
      respond_to do |format|
        format.xml {render :xml => resultArray}
        format.json {render :json => resultArray}
      end
  end
  
end