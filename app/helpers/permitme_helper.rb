module PermitmeHelper
  

        ####################################################
        # H E L P E R   F U N C T I O N S
        ####################################################
        def PermitmeHelper.get_all_permitme_sites(state_and_feature_array, business_type_id, query_type)
            @this_result = Result.new
            
            # Making this new @state_and_feature_array for prune_unincorporated_area only for now.  unincorporated area can be from diferrent fips_feat_id
            # but currently findAllCountySitesByFeatureAndState=>getCountiesByFeature(state_id, fips_feature_id) uses fips_features_id only.
            # dallas,tx has one city with 5 counties(same fips_feature_id), but for (georgetown, id) has two features with different fips_feat_id.
            # so if each feature gets into the PermitmeHelper.prune_unincorporated_areas @state_and_feature_array will be used and spit out county_array
            # this way I don't touch other structures.  schoe 5/21/09
            @state_and_feature_array=state_and_feature_array
            
            if !query_type.eql?("permitme_by_state_only")
                for ss in 0...state_and_feature_array.length
                    
                    #Get County Sites
                      #Fixed so that the county result gets into one permit me item.(Example springfield, va)
                      #as local county site is the only values that are not shared.
                      #This can be changed to 3 different items.  schoe 5/20/09 
                    #@this_result.county_sites = findAllCountySitesByFeatureAndState(state_and_feature_array[ss]["state_id"], state_and_feature_array[ss]["fips_feat_id"], state_and_feature_array[ss]["feature_id"])
                    tempCountySites = findAllCountySitesByFeatureAndState(state_and_feature_array[ss]["state_id"], state_and_feature_array[ss]["fips_feat_id"], state_and_feature_array[ss]["feature_id"])
                    tempCountySites.each do |tc|
                      @this_result.county_sites.push(tc)
                    end

                    #Get Primary Local Sites
                    @this_result.local_sites = findAllSitesByFeatureId(state_and_feature_array[ss]["feature_id"])
                end
            end
          
            @this_result = get_state_business_type_permitme_sites(@this_result, state_and_feature_array[0]["state_id"], business_type_id)

            @this_result
        end

        def PermitmeHelper.get_state_business_type_permitme_sites(this_result, state_id, business_type_id)
            #Add State Results
            this_result.state_sites = PermitMeResultsByStateQuery(state_id)

            #Add Business Type Results
            this_result.sites_for_business_type = PermitMeResultsByBusinessTypeQuery(state_id, business_type_id)

            this_result
        end

        #########################################################
        # S Q L   Q U E R I E S   T O   S I N G L E   T A B L E S
        #########################################################
        def PermitmeHelper.getBusinessTypeIdFromBusinessType(business_type)
            PermitmeSubcategory.find(:all, :select => "id", :conditions => ["isExclusive=1 and isActive=1 and name = ?",business_type])
        end

        def PermitmeHelper.getFeatureAndStatebyZip(zip)
            Feature.find_by_sql(["select state_id, fips_feat_id, feature_id from features,zipcodes where zipcodes.sequence = 1 and zipcodes.feature_id = features.id and county_seq = 1 and zip = ?",zip])
        end

        def PermitmeHelper.getStateIDFromStateAlpha(state_alpha)
            State.find(:all, :select => "id as state_id", :conditions => ["alpha = ?",state_alpha])
        end

        def PermitmeHelper.getStateAlphaFromStateID(state_id)
            State.find(:all, :select => "alpha as state_alpha", :conditions => ["id = ?",state_id])
        end

        def PermitmeHelper.CountySpecsByNameQuery(feature_name, state_id)
            Feature.find(:all, :select => "id, fips_class", :conditions => ["feat_name = ? and state_id = ?",feature_name, state_id])
        end

        def PermitmeHelper.FeatureNameByFeatureIDQuery(feature_id)
            Feature.find(:all, :select => "feat_name, county_name_full, state_id", :conditions => ["id = ?",feature_id])
        end

        def PermitmeHelper.SitesByFeatureIdQuery(feature_id)
            Site.find(:all, :select => "url,name, feature_id", :conditions => ["feature_id = ? and is_primary = 1 and url is not null",feature_id])
        end

        def  PermitmeHelper.PermitMeSitesByFeatureIdQuery(feature_id)
            PermitmeSite.find(:all, :select => "url,name, feature_id", :conditions => ["feature_id = ? and url is not null",feature_id])
        end

        def  PermitmeHelper.PermitMeFeatureAltNameMappingQuery(alternate_name)
            Feature.find_by_sql(["select features.id as feature_id, state_id, fips_feat_id from features,alternate_names where alternate_names.feature_id = features.id and county_seq = 1 and name = ?",alternate_name])
#            Feature.find_by_sql("select features.id, fips_class, state_id, feat_name,county_name_full,majorfeature, fips_feat_id from features,alternate_names where alternate_names.feature_id = features.id and county_seq = 1 and name = ?",alternate_name)
        end

        def PermitmeHelper.permitMeCountySpecsByNameQuery(feature_id)
            PermitmeSite.find(:all, :select => "id,description, url,name, feature_id", :conditions => ["feature_id = ? and url is not null", feature_id])
        end

        def PermitmeHelper.getCountiesByFeature(state_id, fips_feature_id)
        		Feature.find(:all, :select => "id, state_id, county_name_full, county_name_full as link_title, fips_class", :conditions => ["state_id = ? and fips_feat_id=? and county_name_full is not null", state_id, fips_feature_id])
        end
        
        #Adding in the getFeatureByCountyName to get information using the countyName as a feat_name.  schoe 5/20/09
        def PermitmeHelper.getFeatureByCountyName(state_id, countyName)
            Feature.find(:all, :select=>"id, fips_class", :conditions=>["feat_name=? and state_id=?", countyName,state_id])
        end

        ####################################################
        # P E R M I T M E   Q U E R I E S
        ####################################################
        def  PermitmeHelper.PermitMeFeatureMappingQuery(feature_name, alternate_name)
            strQuery = "select id, state_id, fips_class, feat_name,county_name_full,majorfeature, fips_feat_id from features where county_seq = 1 and feat_name = ? "
        		strQuery +=	"union select features.id, state_id, fips_class, feat_name,county_name_full,majorfeature, fips_feat_id from features, alternate_names "
        		strQuery += "where feature_id = features.id and county_seq = 1 and name = ?"
        		Feature.find_by_sql([strQuery,feature_name,alternate_name])
        end

        def  PermitmeHelper.PermitMeFeatureWithStateMappingQuery(feature_name, alternate_name, state_id)
            strQuery = "select id as feature_id, state_id, fips_class, feat_name,county_name_full,majorfeature, fips_feat_id from features where county_seq = 1 and feat_name = ? "
        		strQuery += "and state_id = ? union select features.id, state_id, fips_class, feat_name,county_name_full,majorfeature, fips_feat_id from features, alternate_names "
        		strQuery += "where feature_id = features.id and county_seq = 1 and name = ? and state_id = ?"
        		Feature.find_by_sql([strQuery,feature_name,state_id,alternate_name,state_id])
      	end

        def PermitmeHelper.PermitMeResultsByStateQuery(state_id)
  #          strQuery = "select rg.id, state_id, c.name as category, s.name as subcategory, sec.name as section, rg.description, p.url, p.link_title "
            strQuery = "select s.name as subcategory,rg.description, p.url, p.link_title "
        		strQuery += "from permitme_resource_groups rg join permitme_resources p on p.permitme_resource_group_id = rg.id "
        		strQuery += "left join permitme_categories c on rg.permitme_category_id <=> c.id "
        		strQuery += "left join permitme_subcategories s on rg.permitme_subcategory_id <=> s.id "
        		strQuery += "left join permitme_sections sec on rg.permitme_section_id <=> sec.id "
        		strQuery += "where state_id= ? "
        		strQuery += "and(s.isExclusive <=> 0 or s.isExclusive is null) "
        		strQuery += "and(s.isActive = 1 or s.isActive is null) "
        		strQuery += "order by permitme_category_id, permitme_subcategory_id, permitme_section_id"
        		PermitmeResourceGroup.find_by_sql([strQuery,state_id])
        end

        def PermitmeHelper.PermitMeResultsByBusinessTypeQuery(state_id, business_type_id)
          strQuery = "select s.name as subcategory, p.url, p.link_title "
  #          strQuery = "select rg.id, state_id, c.name as category, s.name as subcategory, sec.name as section, rg.description, p.URL, p.link_title "
        		strQuery += "from permitme_resource_groups rg join permitme_resources p on p.permitme_resource_group_id = rg.id "
        		strQuery += "left join permitme_categories c on rg.permitme_category_id <=> c.id "
        		strQuery += "join permitme_subcategories s on rg.permitme_subcategory_id <=> s.id "
        		strQuery += "left join permitme_sections sec on rg.permitme_section_id <=> sec.id "
        		strQuery += "where state_id= ? and url is not null "
        		strQuery += "and(s.id = ?) "
        		strQuery += "and(s.isActive = 1 or s.isActive is null) "
        		strQuery += "order by permitme_category_id, permitme_subcategory_id, permitme_section_id"
        		PermitmeResourceGroup.find_by_sql([strQuery,state_id,business_type_id])
        end

        def PermitmeHelper.findAllFeatureSitesByFeatureAndState(feature_id, state_alpha)
            foundSites = findAllSitesByFeatureId(feature_id)
        end

        def  PermitmeHelper.findAllSitesByFeatureId(feature_id)
            foundSites = PermitMeSitesByFeatureIdQuery(feature_id)

            if foundSites.empty?
          			foundSites =  SitesByFeatureIdQuery(feature_id)
          	end

            for counter in 0...foundSites.length
                sites = PermitmeHelper.FeatureNameByFeatureIDQuery(foundSites[counter]["feature_id"])
                state_id = sites[0]["state_id"]
                state_name = PermitmeHelper.getStateAlphaFromStateID(state_id)
                foundSites[counter]["link_title"] = sites[0]["feat_name"] + ", " + state_name[0]["state_alpha"]
            end
            
            return foundSites
        end

        def  PermitmeHelper.findAllCountySitesByFeatureAndState (state_id, fips_feature_id,feature_id)
            #The following will return id, county_name_full and fips_class for a given state_id and fips_feat_id
            counties = getCountiesByFeature(state_id, fips_feature_id)
            
            county_name = counties[0]["county_name_full"]
            state_id = counties[0]["state_id"]
            state_name = PermitmeHelper.getStateAlphaFromStateID(state_id)

            counties = process_rules(counties)
            
            counties[0][0]["link_title"] = county_name + ", " + state_name[0]["state_alpha"]

#           localSites = Array.new
#            sitesForThisCounty = Hash.new

#            for counter1 in 0...counties.length
#              for counter2 in 0...counties[counter1].length
                  # Special case for St. Louis because the St. is abbreviated in the county name
#                  county_name = county["county_name_full"]

#                  if(county_name.include?("^St\\.(.)*"))
#                      find_string = "St."
#                      replace_string = "Saint"
#                      string_index = county_name.index(find_string)
#                      county_name[string_index, find_string.length] = replace_string
#                      county["county_name_full"] = county_name
#                  end

                  # get county specs like id,description, url,name, feature_id from Permitme site using feature_id
#                  countySpecs = permitMeCountySpecsByNameQuery(counties[counter1][counter2]["id"])

#                  for currentSpec in 0...countySpecs.length
                      #For this county id get all the sites and set the name for each
                      #localSites << this.findAllSitesByFeatureId(countySpecs[currentSpec]["id"])
#                      localSites << countySpecs
#                  end
#              end
#           end
           
          #converting from java List<LocalSite> findAllSitesByFeatureId in PermitMeFeatureQuery.java where 
          #if the result coming back from the permitSite is empty, the site result gets copied. 
          #this case the counties are the only local sites.  schoe 5/20/09
#          if localSites.blank?
#              localSites=counties
#          end
          
          return counties
      end


      ####################################################
      # P E R M I T M E   R U L E S
      ####################################################
      def PermitmeHelper.process_rules(county_array)
          county_array = prune_unincorporated_areas(county_array)
          county_array = prune_vt_h1_6_counties(county_array)
          county_array = prune_h4_h6_counties(county_array)
          county_array = combine_multiple_urls(county_array)
      end
      
      def PermitmeHelper.prune_array(this_array, fips_compare_array)
          #prune this_array based on fips_compare_array
          for i in 0...this_array.length
              for j in 0...fips_compare_array.length
                  if this_array[i]["fips_class"].eql?fips_compare_array[j]
                      this_array[i] = []
                  end
              end
          end
          
          this_array
      end
      
      def PermitmeHelper.prune_unincorporated_areas(this_array)
          #prune unincorporated areas when we have another option in same county
          fips_compare_array = ["u1","u2","u3","u4","u5","u6"]
          tempFeatureToCompare=nil
          
          ############################################################################
          # The following loop is necessary for this perticular structure as unincorporated area can be from diferrent fips_feat_id
          # but currently findAllCountySitesByFeatureAndState=>getCountiesByFeature(state_id, fips_feature_id) uses fips_features_id only.
          # dallas,tx has one city with 5 counties(same fips_feature_id), but for (georgetown, id) has two features with different fips_feat_id.
          # so if each feature gets into the PermitmeHelper.prune_unincorporated_areas @state_and_feature_array will be used and spit out county_array
          @state_and_feature_array.each do |sfa|
            if sfa["fips_class"] =~ /U\d/
              tempFeatureToCompare=sfa
            end
          end
          
          for f in 0...@state_and_feature_array.size
            if !tempFeatureToCompare.eql?(nil) && tempFeatureToCompare.state_id==@state_and_feature_array[f]["state_id"] && tempFeatureToCompare.county_name_full.eql?(@state_and_feature_array[f]["county_name_full"]) && !tempFeatureToCompare.fips_class.eql?(@state_and_feature_array[f]["fips_class"])
              for g in 0...this_array.length
                if tempFeatureToCompare.feature_id.eql?(this_array[g]["id"].to_s) && this_array[g]["fips_class"] =~ /U\d/
                  this_array[g]=@state_and_feature_array[f]
                end  
              end
            end
          end
          ############################################################################
          
          for i in 0...this_array.length
              for j in 0...fips_compare_array.length
                  if !this_array[i].blank? && this_array[i]["fips_class"].downcase.eql?(fips_compare_array[j])  #put downcase as this_array has the value as Upper case.
                      for k in 0...this_array.length
                          if this_array[k]["county_name_full"].eql?this_array[i]["county_name_full"]
                              if this_array[k]["fips_class"].eql?("h1")
                                  this_array[i] = []
                              end
                          end
                      end
                  end
              end
          end
          
          this_array
      end
      
      def PermitmeHelper.combine_multiple_urls(this_array)
          #return multiple url's for same county as one set
          count = 2
          localSites=Array.new
          this_array.each do |countyArray|
              templocalsite=PermitMeSitesByFeatureIdQuery(countyArray["id"])
              if !templocalsite.blank?
                localSites.push(templocalsite)  
              end
          end

          if localSites.blank?
            this_array.each do |d|
            templocalsite=getFeatureByCountyName(d["state_id"],d["county_name_full"])
            if !templocalsite.blank?
              localSites.push(SitesByFeatureIdQuery(templocalsite[0]["id"]))
            end
          end
          
          
          
        end
          
         this_array=localSites
          #for i in 0...this_array.length
          #    for k in 0...this_array.length
          #        if this_array[k]["county_name_full"].eql?this_array[i]["county_name_full"]
          #            this_array[i]["url"+count.to_s] = this_array[k]["url"]
          #            this_array[i]["link_title"+count.to_s] = this_array[k]["link_title"]
          #           this_array[k] = []
          #            count+= 1
          #        end
          #    end
          #end
          
          this_array
      end
      
      def PermitmeHelper.prune_vt_h1_6_counties(this_array)
          #If state is vermont, then drop any h1-h6 counties
          if @state_alpha.eql?("vt")
              fips_compare_array = ["h1","h2","h3","h4","h5","h6"]
              this_array = PermitmeHelper.prune_array(this_array, fips_compare_array)
          end
          
          this_array
      end
      
      def PermitmeHelper.prune_h4_h6_counties(this_array)
          #if any county has H4 or H6 fips_class, then check if there is another county with same name
          #if another county with same name exists, then remove H4 or H6 county
          #revisit this later
          fips_compare_array = ["h4","h6"]

          for i in 0...this_array.length
              if this_array[i]["fips_class"].eql?("h4") or this_array[i]["fips_class"].eql?("h6")
                  for k in 0...this_array.length
                      if this_array[k]["county_name_full"].eql?this_array[i]["county_name_full"] and this_array[k]["fips_class"].eql?("h1")
                          this_array[i] = []
                      end
                  end
              end
          end
          
          this_array
      end
end