class GeodataController < ApplicationController
  
      ####################################################
      # R O U T I N G   F U N C T I O N S
      ####################################################
      @state_alpha;
      
      def all_links_for_city_of
          #http://localhost:3000/geodata/all_links_for_city_of/:feature.xml
        
          respond_to_format(GeodataHelper.get_links_for_city_of(params[:feature]))
      end
      
      def all_links_for_county_of
          #http://localhost:3000/geodata/all_links_for_county_of/:feature.xml
        
          respond_to_format(GeodataHelper.get_links_for_county_of(params[:feature]))
      end
      
      def city_links_for_state_of
          #http://localhost:3000/geodata/city_links_for_state_of/ca.xml
        
          respond_to_format(GeodataHelper.get_city_links_for_state_of(params[:alpha]))
      end
      
      def county_links_for_state_of
          #http://localhost:3000/geodata/county_links_for_state_of/va.xml
        
          respond_to_format(GeodataHelper.get_county_links_for_city_of(params[:alpha]))
      end
      
      def city_county_links_for_state_of
          #http://localhost:3000/geodata/city_county_links_for_state_of/ny.xml
        
          respond_to_format(GeodataHelper.get_city_links_for_state_of(params[:alpha]))
      end
      
      def geodata_by_zip
          #http://localhost:3000/geodata/by_zip/22209.xml
          #We take the zip and use it to get feature_id for a particular zip
          @features = GeodataHelper.getFeaturebyZip (params[:zip])
        
          respond_to_format(GeodataHelper.get_all_geodata_sites(@features))
      end

      def geodata_by_major_city
          #http://localhost:3000/geodata/major_city/anchorage.xml        
          #We take the state alpha and use it to get state_id,(fips_feature_id, feature_id will be blank in this cases)
          @majorfeature = GeodataHelper.getMajorFeatureByFeatureName(params[:feature])
        
          respond_to_format(GeodataHelper.get_all_geodata_sites(@majorfeature))
      end

      def geodata_by_state_and_feature
          #http://localhost:3000/geodata/state_and_city/il/baldwin.xml
          #We take the state alpha and use it to get state_id,(fips_feature_id, feature_id will be blank in this cases)
          @state_id = GeodataHelper.getStateIDFromStateAlpha(params[:alpha])
          
          @state_alpha = params[:alpha]

          #Get state_id, fips_feature_id and feature_id based on feature_name
          @state_and_feature = GeodataHelper.GeodataFeatureWithStateMappingQuery(params[:feature], params[:feature], @state_id[0]["state_id"])

          respond_to_format(GeodataHelper.get_all_geodata_sites(@state_and_feature))
      end
    
      def respond_to_format(resultArray)
          respond_to do |format|
     		      format.html { render :text => resultArray.to_json }
              format.xml {render :xml => resultArray}
              format.json {render :json => resultArray}
          end
      end
end