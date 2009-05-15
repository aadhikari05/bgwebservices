class PermitmeController < ApplicationController
  
      ####################################################
      # R O U T I N G   F U N C T I O N S
      ####################################################
      def permitme_by_zip
          #http://localhost:3000/permitme/by_zip/child%20care%20services/22209.xml
          #We take the zip and use it to get state_id, fips_feature_id, feature_id for a particular zip
          @state_and_feature = PermitmeHelper.getFeatureAndStatebyZip (params[:zip])
          @business_type_id = PermitmeHelper.getBusinessTypeIdFromBusinessType (params[:business_type])
        
          #We pass the state_id and fips_feat_id to the function below to get the list of County Sites
          respond_to_format (PermitmeHelper.get_all_permitme_sites (@state_and_feature, @business_type_id, "permitme_by_zip"))
      end

      def permitme_by_state_only
          #http://localhost:3000/permitme/state_only/child%20care%20services/il.xml
          @business_type_id = PermitmeHelper.getBusinessTypeIdFromBusinessType (params[:business_type])
        
          #We take the state alpha and use it to get state_id, (fips_feature_id, feature_id will be blank in this cases)
          @state_and_feature = PermitmeHelper.getStateIDFromStateAlpha (params[:alpha])
        
          #We pass the state_id and fips_feat_id to the function below to get the list of County Sites
          respond_to_format (PermitmeHelper.get_all_permitme_sites (@state_and_feature, @business_type_id, "permitme_by_state_only"))
      end

      def permitme_by_state_and_feature
          #http://localhost:3000/permitme/state_and_city/child%20care%20services/il/baldwin.xml

          @business_type_id = PermitmeHelper.getBusinessTypeIdFromBusinessType (params[:business_type])
          
          #Get state_id, fips_feature_id and feature_id based on feature_name
          #Need to trim the list by state

          @state_and_feature = PermitmeHelper.PermitMeFeatureAltNameMappingQuery (params[:feature])

          #We pass the state_id and fips_feat_id to the function below to get the list of County Sites
          respond_to_format (PermitmeHelper.get_all_permitme_sites (@state_and_feature, @business_type_id, "permitme_by_state_and_feature"))
      end
  
    
      def respond_to_format (resultArray)
          respond_to do |format|
              format.xml {render :xml => resultArray}
              format.json {render :json => resultArray}
          end
      end
    
end