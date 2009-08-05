class GeodataController < ApplicationController
  
      ####################################################
      # R O U T I N G   F U N C T I O N S
      ####################################################
      @state_alpha;
      
      def geodata_by_zip
          #http://localhost:3000/geodata/by_zip/22209.xml
          #We take the zip and use it to get state_id, fips_feature_id, feature_id for a particular zip
          @state_and_feature = GeodataHelper.getFeatureAndStatebyZip (params[:zip])
          @business_type_id = GeodataHelper.getBusinessTypeIdFromBusinessType(params[:business_type])
          @state_alpha = GeodataHelper.getStateAlphaFromStateID(@state_and_feature[0]["state_id"])
        
          #We pass the state_id and fips_feat_id to the function below to get the list of County Sites
          respond_to_format(GeodataHelper.get_all_geodata_sites(@state_and_feature, @business_type_id, "geodata_by_zip"))
      end

      def geodata_by_state_only
          #http://localhost:3000/geodata/state_only/il.xml
          @business_type_id = GeodataHelper.getBusinessTypeIdFromBusinessType(params[:business_type])
        
          #We take the state alpha and use it to get state_id,(fips_feature_id, feature_id will be blank in this cases)
          @state_and_feature = GeodataHelper.getStateIDFromStateAlpha(params[:alpha])
          @state_alpha = params[:alpha]
        
          #We pass the state_id and fips_feat_id to the function below to get the list of County Sites
          respond_to_format(GeodataHelper.get_all_geodata_sites(@state_and_feature, @business_type_id, "geodata_by_state_only"))
      end

      def geodata_by_state_and_feature
          #http://localhost:3000/geodata/state_and_city/il/baldwin.xml

          @business_type_id = GeodataHelper.getBusinessTypeIdFromBusinessType(params[:business_type])

          #We take the state alpha and use it to get state_id,(fips_feature_id, feature_id will be blank in this cases)
          @state_id = GeodataHelper.getStateIDFromStateAlpha(params[:alpha])
          
          @state_alpha = params[:alpha]

          #Get state_id, fips_feature_id and feature_id based on feature_name
          @state_and_feature = GeodataHelper.PermitMeFeatureWithStateMappingQuery(params[:feature], params[:feature], @state_id[0]["state_id"])

          #We pass the state_id and fips_feat_id to the function below to get the list of County Sites
          #resultArray = Array.new
          #@state_and_feature.each do |sf|
          #  resultArray.push(GeodataHelper.get_all_geodata_sites(sf, @business_type_id, "geodata_by_state_and_feature"))
         # end
          
         # puts 'b'
          respond_to_format(GeodataHelper.get_all_geodata_sites(@state_and_feature, @business_type_id, "geodata_by_state_and_feature"))
      end
    
      def respond_to_format(resultArray)
          respond_to do |format|
     		      format.html { render :text => resultArray.to_json }
              format.xml {render :xml => resultArray}
              format.json {render :json => resultArray}
          end
      end
end