require 'helpers/permitme_helper.rb'

class PermitmeController < ApplicationController
  
    def permitme_by_zip
        #http://localhost:3000/permitme/by_zip/child%20care%20services/22209.xml
        @queryResults = CountySpecsByNameQuery (:feature, 42)
        respond_to do |format|
          format.xml {render :xml => @queryResults}
          format.json {render :json => @queryResults}
        end
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

  
      #	featureAltNameMappingQuery = new PermitMeFeatureAltNameMappingQuery(ds);
      #	sitesByFeatureIdQuery = new SitesByFeatureIdQuery(ds);
      #	permitMeCountySpecsByNameQuery = new CountySpecsByNameQuery(ds);
      #	permitMeSitesByFeatureIdQuery = new PermitMeSitesByFeatureIdQuery(ds);
      #	permitMeFeatureWithStateMappingQuery = new PermitMeFeatureWithStateMappingQuery(ds);

    
end