class PermitmeController < ApplicationController
  
      ####################################################
      # R O U T I N G   F U N C T I O N S
      ####################################################
      @state_alpha;
      
      def permitme_by_zip
          #http://localhost:3000/permitme/by_zip/child%20care%20services/22209.xml
          #We take the zip and use it to get state_id, fips_feature_id, feature_id for a particular zip
          @state_and_feature = PermitmeHelper.getFeatureAndStatebyZip (params[:zip])
          @business_type_id = PermitmeHelper.getBusinessTypeIdFromBusinessType (params[:business_type])
          @state_alpha = PermitmeHelper.getStateAlphaFromStateID (@state_and_feature[0]["state_id"])
        
          #We pass the state_id and fips_feat_id to the function below to get the list of County Sites
          respond_to_format (PermitmeHelper.get_all_permitme_sites (@state_and_feature, @business_type_id, "permitme_by_zip"))
      end

      def permitme_by_state_only
          #http://localhost:3000/permitme/state_only/child%20care%20services/il.xml
          @business_type_id = PermitmeHelper.getBusinessTypeIdFromBusinessType (params[:business_type])
        
          #We take the state alpha and use it to get state_id, (fips_feature_id, feature_id will be blank in this cases)
          @state_and_feature = PermitmeHelper.getStateIDFromStateAlpha (params[:alpha])
          @state_alpha = params[:alpha]
        
          #We pass the state_id and fips_feat_id to the function below to get the list of County Sites
          respond_to_format (PermitmeHelper.get_all_permitme_sites (@state_and_feature, @business_type_id, "permitme_by_state_only"))
      end

      def permitme_by_state_and_feature
          #http://localhost:3000/permitme/state_and_city/child%20care%20services/il/baldwin.xml

          @business_type_id = PermitmeHelper.getBusinessTypeIdFromBusinessType (params[:business_type])

          #We take the state alpha and use it to get state_id, (fips_feature_id, feature_id will be blank in this cases)
          @state_id = PermitmeHelper.getStateIDFromStateAlpha (params[:alpha])
          
          @state_alpha = params[:alpha]

          #Get state_id, fips_feature_id and feature_id based on feature_name
          @state_and_feature = PermitmeHelper.PermitMeFeatureWithStateMappingQuery (params[:feature], params[:feature], @state_id[0]["state_id"])

          #We pass the state_id and fips_feat_id to the function below to get the list of County Sites
          #resultArray = Array.new
          #@state_and_feature.each do |sf|
          #  resultArray.push(PermitmeHelper.get_all_permitme_sites (sf, @business_type_id, "permitme_by_state_and_feature"))
         # end
          
         # puts 'b'
          respond_to_format (PermitmeHelper.get_all_permitme_sites (@state_and_feature, @business_type_id, "permitme_by_state_and_feature"))
      end
    
      def respond_to_format (resultArray)
          respond_to do |format|
     		      format.html { render :text => resultArray.to_json }
              format.xml {render :xml => resultArray}
              format.json {render :json => resultArray}
          end
      end
end