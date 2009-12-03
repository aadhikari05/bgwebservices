module GeodataHelper
  

        ####################################################
        # H E L P E R   F U N C T I O N S
        ####################################################
        def GeodataHelper.get_all_geodata_sites(features)
            @this_result = GeodataResult.new
            
            @features = features
            
            for ss in 0...features.length
              if !features[ss]["county_name_full"].nil?
                tempCountySites = findAllCountySitesByFeatureAndState(features[ss]["state_id"], features[ss]["fips_feat_id"], features[ss]["feature_id"])
                tempCountySites.each do |tc|
                    @this_result.county_sites.push(tc)
                end
              end
                #Get Primary Local Sites
                @this_result.local_sites = findAllSitesByFeatureId(features[ss]["feature_id"])

                #Get State Sites
                @this_result.state_sites = get_state_sites(@this_result, features[ss]["state_id"])
            end
          
            @this_result
        end


        ###########################
        # F I N D   Q U E R I E S
        ###########################
         def  GeodataHelper.get_links_for_city_of(feature)
            strQuery = "SELECT f.id, s.feature_id, feat_class, fips_class, feat_name as 'name', st.alpha as 'state_abbreviation', fips_county_cd, " +
            "county_name as 'county_name', primary_lat as 'primary_lattitude', primary_lon as 'primary_longitude', st.name as 'state_name', " +
            "county_name_full as 'full_county_name', url, s.name as link_title " +
            "FROM `sites` s " +
            "INNER JOIN `features`f ON f.id = s.feature_id " +
            "left join alternate_names an on f.id = an.feature_id " +
            "left join states st on f.state_id = st.id " +
            "WHERE ((feat_name = ? or an.name=?) and is_primary = 1 and url is not null)"
        		Site.find_by_sql([strQuery,feature, feature])
      	end
        
         def  GeodataHelper.GeodataFeatureWithStateMappingQuery(feature_name, alternate_name, state_id)
            strQuery = "select id as feature_id, state_id, feat_name, county_name_full, fips_id, fips_class, fips_feat_id, fips_st_cd, fips_county_cd, majorfeature from features where county_seq = 1 and feat_name = ? "
        		strQuery += "and state_id = ? union select features.id as feature_id, state_id, feat_name, county_name_full, fips_id, fips_class, fips_feat_id, fips_st_cd, fips_county_cd, majorfeature from features, alternate_names "
        		strQuery += "where feature_id = features.id and county_seq = 1 and name = ? and state_id = ?"
        		Feature.find_by_sql([strQuery,feature_name,state_id,alternate_name,state_id])
      	end

        def GeodataHelper.getFeaturebyZip(zip)
            Feature.find_by_sql(["select fips_id, fips_class, fips_feat_id, fips_st_cd, fips_county_cd, majorfeature, feature_id, state_id from features,zipcodes where zipcodes.sequence = 1 and zipcodes.feature_id = features.id and county_seq = 1 and zip = ?",zip])
        end

        def GeodataHelper.getStateIDFromStateAlpha(state_alpha)
            State.find(:all, :select => "id as state_id", :conditions => ["alpha = ?",state_alpha])
        end

        def GeodataHelper.getStateAlphaFromStateID(state_id)
            State.find(:all, :select => "alpha as state_alpha", :conditions => ["id = ?",state_id])
        end

        def GeodataHelper.FeatureNameByFeatureIDQuery(feature_id)
            Feature.find(:all, :select => "feat_name, county_name_full, state_id, fips_id, fips_class, fips_feat_id, fips_st_cd, fips_county_cd, fips_place_cd, majorfeature", :conditions => ["id = ?",feature_id])
        end

        def GeodataHelper.getMajorFeatureByFeatureName(feature)
            Feature.find(:all, :select => "id, feat_name, county_name_full, state_id, fips_id, fips_class, fips_feat_id, fips_st_cd, fips_county_cd, fips_place_cd, majorfeature", :conditions => ["feat_name = ? and majorfeature = 1",feature])
        end

        def GeodataHelper.SitesByFeatureIdQuery(feature_id)
            Site.find(:all, :select => "url,name as link_title, feature_id", :conditions => ["feature_id = ? and is_primary = 1 and url is not null",feature_id])
        end

        def GeodataHelper.SiteFiltersByFeatureIdQuery(feature_id)
            SiteFilter.find(:all, :select => "url,name as link_title, feature_id", :conditions => ["feature_id = ? and url is not null",feature_id])
        end

        def GeodataHelper.SitesByStateQuery(state_id)
            Site.find(:all, :select => "url,name as link_title, feature_id, feat_name, county_name_full, state_id, fips_id, fips_class, fips_feat_id, fips_st_cd, fips_county_cd, fips_place_cd, majorfeature", :joins => :feature, :conditions => ["state_id=? and is_primary = 1 and url is not null",state_id])
        end

        def GeodataHelper.SiteFiltersByStateQuery(state_id)
            SiteFilter.find(:all, :select => "url,name as link_title, feature_id, feat_name, county_name_full, state_id, fips_id, fips_class, fips_feat_id, fips_st_cd, fips_county_cd, fips_place_cd, majorfeature", :joins => :feature, :conditions => ["state_id=? and url is not null",state_id])
        end

        def GeodataHelper.getCountiesByFeature(state_id, fips_feature_id)
        		Feature.find(:all, :select => "id, state_id, county_name_full, county_name_full as link_title, fips_id, fips_class, fips_feat_id, fips_st_cd, fips_county_cd, fips_place_cd, majorfeature", :conditions => ["state_id = ? and fips_feat_id=? and county_name_full is not null", state_id, fips_feature_id])
        end
        
        def GeodataHelper.getCountyNameByFeature(state_id, feature_id)
        		Feature.find(:all, :select => "county_name_full", :conditions => ["state_id = ? and id=? and county_name_full is not null", state_id, feature_id])
        end
        
        def GeodataHelper.getFeatureByCountyName(state_id, countyName)
            Feature.find(:all, :select=>"id, fips_id, fips_class, fips_feat_id, fips_st_cd, fips_county_cd, majorfeature", :conditions=>["feat_name=? and state_id=?", countyName,state_id])
        end


        ####################################################
        # G E O D A T A   Q U E R I E S
        ####################################################

        def GeodataHelper.get_state_sites(this_result, state_id)
            #Add State Results
            this_result.state_sites = GeodataHelper.SitesByStateQuery(state_id)
            
            if this_result.state_sites.empty?
                this_result.state_sites = GeodataHelper.SiteFiltersByStateQuery(state_id)
            end

            #Added check for link_title is blank for state_sites. 
            #If link_title is blank, makes it equal to empty string, so it doesn't get sent as a nil object 
            #and doesn't break sort in to_xml.
#            for counter in 0...this_result.state_sites.length
#              if this_result.state_sites[counter]["link_title"].nil?
#                  this_result.state_sites[counter]["link_title"] = ""
#              end
#            end

            this_result.state_sites
        end

        def GeodataHelper.findAllFeatureSitesByFeatureAndState(feature_id, state_alpha)
            foundSites = findAllSitesByFeatureId(feature_id)
        end

        def  GeodataHelper.findAllSitesByFeatureId(feature_id)
            foundSites = SitesByFeatureIdQuery(feature_id)

            if foundSites.empty?
          			foundSites =  SiteFiltersByFeatureIdQuery(feature_id)
          	end

            for counter in 0...foundSites.length
                sites = GeodataHelper.FeatureNameByFeatureIDQuery(foundSites[counter]["feature_id"])
                state_id = sites[0]["state_id"]
                state_name = GeodataHelper.getStateAlphaFromStateID(state_id)
                
                foundSites[counter]["link_title"] = sites[0]["feat_name"] + ", " + state_name[0]["state_alpha"]
                foundSites[counter]["fips_id"] = sites[0]["fips_id"]
                foundSites[counter]["fips_class"] = sites[0]["fips_class"]
                foundSites[counter]["fips_feat_id"] = sites[0]["fips_feat_id"]
                foundSites[counter]["fips_st_cd"] = sites[0]["fips_st_cd"]
                foundSites[counter]["fips_county_cd"] = sites[0]["fips_county_cd"]
                foundSites[counter]["fips_place_cd"] = sites[0]["fips_place_cd"]
            end
            
            return foundSites
        end

        def  GeodataHelper.findAllCountySitesByFeatureAndState (state_id, fips_feature_id,feature_id)
            #The following will return id, county_name_full and fips_class for a given state_id and fips_feat_id
            countyNameArray = getCountyNameByFeature(state_id, feature_id)
            countyName = countyNameArray[0]["county_name_full"]
            counties = getFeatureByCountyName(state_id, countyName)
            
            county_sites = Array.new
            county_site_counter = 0
            
            for counter in 0...counties.length
                temp_county_sites = GeodataHelper.findAllSitesByFeatureId(counties[counter]["id"])
                for temp_counter in 0...temp_county_sites.length
                    county_sites[county_site_counter] = temp_county_sites[temp_counter]
                    county_sites[county_site_counter]["fips_id"] = counties[counter]["fips_id"]
                    county_sites[county_site_counter]["fips_class"] = counties[counter]["fips_class"]
                    county_sites[county_site_counter]["fips_feat_id"] = counties[counter]["fips_feat_id"]
                    county_sites[county_site_counter]["fips_st_cd"] = counties[counter]["fips_st_cd"]
                    county_sites[county_site_counter]["fips_county_cd"] = counties[counter]["fips_county_cd"]
                    county_sites[county_site_counter]["fips_place_cd"] = counties[counter]["fips_place_cd"]
                    county_site_counter = county_site_counter + 1
                end
            end
          
            return county_sites
        end

end