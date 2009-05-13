class PermitmeController < ApplicationController
  
      ####################################################
      # R O U T I N G   F U N C T I O N S
      ####################################################
      def permitme_by_zip
          #http://localhost:3000/permitme/by_zip/child%20care%20services/22209.xml
          #We take the zip and use it to get state_id and fips_feature_id for a particular zip
          #using getFeatureAndStatebyZip for now, change to findAllCountySitesByFeatureAndState and save to countyResults array
          @state_and_feature = PermitmeHelper.getFeatureAndStatebyZip (params[:zip])
          @business_type_id = PermitmeHelper.getBusinessTypeIdFromBusinessType (params[:business_type])
        
          #We pass the state_id and fips_feat_id to the function below to get the list of County Sites
          respond_to_format (PermitmeHelper.get_all_permitme_sites (@state_and_feature, @business_type_id))
      end

      def permitme_by_state_only
          #http://localhost:3000/permitme/state_only/child%20care%20services/il.xml
          @business_type_id = PermitmeHelper.getBusinessTypeIdFromBusinessType (params[:business_type])
        
          @state_and_feature = PermitmeHelper.getFeatureAndStatebyZip (params[:zip])
        
          #We pass the state_id and fips_feat_id to the function below to get the list of County Sites
          respond_to_format (PermitmeHelper.get_all_permitme_sites (state_and_feature_array, business_type_id))
      end

      def permitme_by_state_and_feature
          #http://localhost:3000/permitme/state_and_city/child%20care%20services/il/baldwin.xml
          #params[:business_type],"%"+params[:feature]+"%",params[:alpha]])

          @business_type_id = PermitmeHelper.getBusinessTypeIdFromBusinessType (params[:business_type])
        
          @state_and_feature = PermitmeHelper.getFeatureAndStatebyZip (params[:zip])

          #We pass the state_id and fips_feat_id to the function below to get the list of County Sites
          respond_to_format (PermitmeHelper.get_all_permitme_sites (state_and_feature_array, business_type_id))
      end
  
    
      def respond_to_format (resultArray)
          respond_to do |format|
            format.xml {render :xml => resultArray}
            format.json {render :json => resultArray}
          end
      end
    
end