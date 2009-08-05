module GeodataHelper
  

        ####################################################
        # H E L P E R   F U N C T I O N S
        ####################################################
        def GeodataHelper.get_all_geodata_sites(features)
            @this_result = Result.new
            
            @features = features
            
            for ss in 0...state_and_feature_array.length
                tempCountySites = findAllCountySitesByFeatureAndState(features[ss]["state_id"], features[ss]["fips_feat_id"], features[ss]["feature_id"])
                tempCountySites.each do |tc|
                  @this_result.county_sites.push(tc)
                end

                #Get Primary Local Sites
                @this_result.local_sites = findAllSitesByFeatureId(features[ss]["feature_id"])
            end
          
            @this_result
        end


        #########################################################
        # S Q L   Q U E R I E S   T O   S I N G L E   T A B L E S
        #########################################################
        def GeodataHelper.getFeaturebyZip(zip)
            Feature.find_by_sql(["select fips_feat_id, feature_id, state_id from features,zipcodes where zipcodes.sequence = 1 and zipcodes.feature_id = features.id and county_seq = 1 and zip = ?",zip])
        end

        def GeodataHelper.getStateIDFromStateAlpha(state_alpha)
            State.find(:all, :select => "id as state_id", :conditions => ["alpha = ?",state_alpha])
        end

        def GeodataHelper.getStateAlphaFromStateID(state_id)
            State.find(:all, :select => "alpha as state_alpha", :conditions => ["id = ?",state_id])
        end

        def GeodataHelper.SitesByFeatureIdQuery(feature_id)
            Site.find(:all, :select => "url,name, feature_id", :conditions => ["feature_id = ? and is_primary = 1 and url is not null",feature_id])
        end

        def GeodataHelper.getCountiesByFeature(state_id, fips_feature_id)
        		Feature.find(:all, :select => "id, state_id, county_name_full, county_name_full as link_title, fips_class", :conditions => ["state_id = ? and fips_feat_id=? and county_name_full is not null", state_id, fips_feature_id])
        end
        
        #Adding in the getFeatureByCountyName to get information using the countyName as a feat_name.  schoe 5/20/09
        def GeodataHelper.getFeatureByCountyName(state_id, countyName)
            Feature.find(:all, :select=>"id, fips_class", :conditions=>["feat_name=? and state_id=?", countyName,state_id])
        end

        ####################################################
        # G E O D A T A   Q U E R I E S
        ####################################################

        def GeodataHelper.findAllFeatureSitesByFeatureAndState(feature_id, state_alpha)
            foundSites = findAllSitesByFeatureId(feature_id)
        end

        def  GeodataHelper.findAllSitesByFeatureId(feature_id)
            foundSites = PermitMeSitesByFeatureIdQuery(feature_id)

            if foundSites.empty?
          			foundSites =  SitesByFeatureIdQuery(feature_id)
          	end

            for counter in 0...foundSites.length
                sites = GeodataHelper.FeatureNameByFeatureIDQuery(foundSites[counter]["feature_id"])
                state_id = sites[0]["state_id"]
                state_name = GeodataHelper.getStateAlphaFromStateID(state_id)
                foundSites[counter]["link_title"] = sites[0]["feat_name"] + ", " + state_name[0]["state_alpha"]
            end
            
            return foundSites
        end

        def  GeodataHelper.findAllCountySitesByFeatureAndState (state_id, fips_feature_id,feature_id)
            #The following will return id, county_name_full and fips_class for a given state_id and fips_feat_id
            counties = getCountiesByFeature(state_id, fips_feature_id)
            
            county_name = counties[0]["county_name_full"]
            state_id = counties[0]["state_id"]
            state_name = GeodataHelper.getStateAlphaFromStateID(state_id)

            counties = process_rules(counties)
            
            counties[0][0]["link_title"] = county_name + ", " + state_name[0]["state_alpha"]
          
          return counties
      end


end