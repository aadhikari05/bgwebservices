module PermitmeHelper
  

        ####################################################
        # H E L P E R   F U N C T I O N S
        ####################################################
        def PermitmeHelper.get_all_permitme_sites(state_and_feature_array, business_type_id, query_type)
            @this_result = Result.new

            # Making this new @state_and_feature_array for prune_unincorporated_area only for now.  
            # unincorporated area can be from diferrent fips_feat_id
            # but currently findAllCountySitesByFeatureAndState=>getCountiesByFeature(state_id, fips_feature_id) 
            # uses fips_features_id only.
            # dallas,tx has one city with 5 counties(same fips_feature_id), but 
            # for (georgetown, id) has two features with different fips_feat_id.
            # so if each feature gets into the PermitmeHelper.prune_unincorporated_areas 
            # @state_and_feature_array will be used and spit out county_array
            # this way I don't touch other structures.  schoe 5/21/09
            @state_and_feature_array=state_and_feature_array

            if !query_type.eql?("permitme_by_state_only") and !query_type.eql?("all_permitme_by_state")
                for ss in 0...state_and_feature_array.length
                    if state_and_feature_array[ss]["fips_class"] != "C7"
                        #Get County Sites
                        #Fixed so that the county result gets into one permit me item.(Example springfield, va)
                        #as local county site is the only values that are not shared.
                        #This can be changed to 3 different items.  schoe 5/20/09 
                        if query_type.eql?("permitme_by_county")
                            sites = findAllSitesByFeatureId(state_and_feature_array[ss]["feature_id"])
                            tempCountySites = Array.new
                            tempCountySites << sites
                        else
                            tempCountySites = findAllCountySitesByFeatureAndState(state_and_feature_array[ss]["state_id"], state_and_feature_array[ss]["fips_feat_id"], state_and_feature_array[ss]["feature_id"])
                        end
                  
                        tempCountySites.each do |tc|
                            tc.each do |site|
                                site["state"] = state_and_feature_array[ss]["state_name"]
                                site["county"] = state_and_feature_array[ss]["county_name_full"]
                            end
                            @this_result.county_sites.push(tc)
                        end
                    end
                    
                    #Get Primary Local Sites
                    @this_result.local_sites = findAllSitesByFeatureId(state_and_feature_array[ss]["feature_id"])
                    @this_result.local_sites.each do |site|
                        site["state"] = state_and_feature_array[ss]["state_name"]
                        site["county"] = state_and_feature_array[ss]["county_name_full"]
                    end
                end
            end

            if !query_type.eql?("all_permitme_by_state")
                @this_result = get_state_business_type_permitme_sites(@this_result, state_and_feature_array[0]["state_id"], business_type_id)
                @this_result.sites_for_business_type.each do |site|
                  if !site["state"].nil?
                    site["state"] = state_and_feature_array[ss]["state_name"]
                    site["county"] = state_and_feature_array[ss]["county_name_full"]
                  end
                end
            else
                state_id = state_and_feature_array[0]["state_id"]
                @this_result.state_sites = PermitMeResultsByStateQuery(state_id)
                @this_result.state_sites.each do |site|
                  if !site["state"].nil?
                    site["state"] = state_and_feature_array[ss]["state_name"]
                    site["county"] = state_and_feature_array[ss]["county_name_full"]
                  end
                end
            end

            @this_result
        end

        def PermitmeHelper.get_state_business_type_permitme_sites(this_result, state_id, business_type_id)
            #Add State Results
            this_result.state_sites = PermitMeResultsByStateQuery(state_id)

            #Added check for link_title is blank for state_sites. 
            #If link_title is blank, makes it equal to empty string, so it doesn't get sent as a nil object 
            #and doesn't break sort in to_xml.
            for counter in 0...this_result.state_sites.length
                if this_result.state_sites[counter]["link_title"].nil?
                    this_result.state_sites[counter]["link_title"] = ""
                end
            end

            #Add Business Type Results
            this_result.sites_for_business_type = PermitMeResultsByBusinessTypeQuery(state_id, business_type_id)

            for counter in 0...this_result.sites_for_business_type.length
                if this_result.sites_for_business_type[counter]["link_title"].nil?
                    this_result.sites_for_business_type[counter]["link_title"] = ""
                end
            end

            this_result
        end

        def PermitmeHelper.get_all_business_type_permitme_sites(business_type)
          @this_result = Result.new

            #Add Business Type Results
            @this_result.sites_for_business_type = PermitMeResultsByBusinessTypeOnly(business_type)

            @this_result
        end

        def PermitmeHelper.get_all_category_permitme_sites(category)
          @this_result = Result.new

            #Add Business Type Results
            @this_result.sites_for_category = PermitMeResultsByCategoryOnly(category)

            @this_result
        end

        #########################################################
        # S Q L   Q U E R I E S   T O   S I N G L E   T A B L E S
        #########################################################
        def PermitmeHelper.getBusinessTypeIdFromBusinessType(business_type)
            PermitmeSubcategory.find(:all, :select => "id", :conditions => ["isExclusive=1 and isActive=1 and name = ?",business_type])
        end

        def PermitmeHelper.getFeatureAndStatebyZip(zip)
            strSQL = "select f.state_id, s.name as state_name, f.fips_feat_id, z.feature_id, f.county_name_full, f.fips_class "
            strSQL += "from features f "
            strSQL += "left join zipcodes z on z.feature_id = f.id "
            strSQL += "left join states s on s.id = f.state_id "
            strSQL += "where z.sequence = 1 and z.feature_id = f.id and county_seq = 1 and zip = ?"
            Feature.find_by_sql([strSQL,zip])
        end

        def PermitmeHelper.getFeatureAndStatebyFeature(feature)
            Feature.find(:all, :select => "id, state_id, fips_feat_id", :conditions => ["county_seq = 1 and feat_name = ?",feature])
        end

        def PermitmeHelper.getFeatureAndStatebyCountyAndState (feature, state_id)
            strSQL = "SELECT f.id as feature_id, state_id, fips_feat_id, s.name as state_name, county_name_full FROM `features` f "
            strSQL += "left join states s on state_id = s.id "
            strSQL += "WHERE (fips_class like 'H%' and feat_name = ? and state_id = ?)"
            Feature.find_by_sql([strSQL,feature, state_id])
        end
        
        def PermitmeHelper.getStateIDFromStateAlpha(state_alpha)
            State.find(:all, :select => "id as state_id", :conditions => ["alpha = ?",state_alpha])
        end

        def PermitmeHelper.getStateAlphaFromStateID(state_id)
            State.find(:all, :select => "alpha as state_alpha", :conditions => ["id = ?",state_id])
        end

        def PermitmeHelper.getStateNameFromStateID(state_id)
            State.find(:all, :select => "name as state_name", :conditions => ["id = ?",state_id])
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
            strQuery = "select id, state_id, fips_class, feat_name,county_name_full,majorfeature, fips_feat_id "
            strQuery += "from features where county_seq = 1 and feat_name = ? "
        		strQuery +=	"union select features.id, state_id, fips_class, feat_name, county_name_full, majorfeature, "
            strQuery += "fips_feat_id from features, alternate_names "
        		strQuery += "where feature_id = features.id and county_seq = 1 and name = ?"
        		Feature.find_by_sql([strQuery,feature_name,alternate_name])
        end

        def  PermitmeHelper.PermitMeFeatureWithStateMappingQuery(feature_name, alternate_name, state_id)
            strQuery = "select s.name as state_name, features.id as feature_id, state_id, fips_class, "
        		strQuery += "feat_name, county_name_full, majorfeature, fips_feat_id "
        		strQuery += "from features "
        		strQuery += "left join states s on state_id = s.id "
        		strQuery += "where county_seq = 1 and feat_name = ? and state_id = ? "
        		strQuery += "union "
        		strQuery += "select s.name as state_name, features.id as feature_id, state_id, fips_class, "
        		strQuery += "feat_name, county_name_full, majorfeature, fips_feat_id "
        		strQuery += "from features "
        		strQuery += "left join alternate_names an on an.feature_id = features.id "
        		strQuery += "left join states s on features.state_id = s.id "
        		strQuery += "where feature_id = features.id and county_seq = 1 and an.name = ? and state_id = ?"
        		Feature.find_by_sql([strQuery,feature_name,state_id,alternate_name,state_id])
      	end

        def PermitmeHelper.PermitMeResultsByStateQuery(state_id)
            strQuery = "select states.name as state_name, c.name as category, "
            strQuery += "s.name as business_type, "
            strQuery += "sec.name as section, rg.description as resource_group_description, "
            strQuery += "p.url, p.link_title, p.link_description "
        		strQuery += "from permitme_resource_groups rg join permitme_resources p on p.permitme_resource_group_id = rg.id "
        		strQuery += "left join permitme_categories c on rg.permitme_category_id <=> c.id "
        		strQuery += "left join permitme_subcategories s on rg.permitme_subcategory_id <=> s.id "
        		strQuery += "left join permitme_sections sec on rg.permitme_section_id <=> sec.id "
        		strQuery += "left join states on state_id <=> states.id "
        		strQuery += "where state_id= ? "
        		strQuery += "and(s.isActive = 1 or s.isActive is null) "
        		strQuery += "order by permitme_category_id, permitme_subcategory_id, permitme_section_id"
        		PermitmeResourceGroup.find_by_sql([strQuery,state_id])
        end

        def PermitmeHelper.PermitMeResultsByBusinessTypeQuery(state_id, business_type_id)
            strQuery = "select states.name as state_name, c.name as category, "
            strQuery += "s.name as business_type, "
            strQuery += "sec.name as section, rg.description as resource_group_description, "
            strQuery += "p.url, p.link_title, p.link_description "
        		strQuery += "from permitme_resource_groups rg join permitme_resources p on p.permitme_resource_group_id = rg.id "
        		strQuery += "left join permitme_categories c on rg.permitme_category_id <=> c.id "
        		strQuery += "join permitme_subcategories s on rg.permitme_subcategory_id <=> s.id "
        		strQuery += "left join permitme_sections sec on rg.permitme_section_id <=> sec.id "
        		strQuery += "left join states on states.id = rg.state_id "            
        		strQuery += "where state_id= ? "
        		strQuery += "and(s.id = ?) "
        		strQuery += "and(s.isActive = 1 or s.isActive is null) "
        		strQuery += "order by permitme_category_id, permitme_subcategory_id, permitme_section_id"
        		PermitmeResourceGroup.find_by_sql([strQuery,state_id,business_type_id])
        end

        def PermitmeHelper.PermitMeResultsByBusinessTypeOnly(business_type)
            strQuery = "select states.name as state, c.name as category, "
            strQuery += "s.name as business_type, "
            strQuery += "sec.name as section, rg.description as resource_group_description, "
            strQuery += "p.url, p.link_title, p.link_description from permitme_resources p "
          	strQuery += "left join permitme_resource_groups rg on p.permitme_resource_group_id <=> rg.id "
          	strQuery += "left join permitme_categories c on rg.permitme_category_id <=> c.id "
          	strQuery += "left join permitme_subcategories s on rg.permitme_subcategory_id <=> s.id "
          	strQuery += "left join permitme_sections sec on rg.permitme_section_id <=> sec.id "
        		strQuery += "left join states on states.id = rg.state_id "            
          	strQuery += "where (s.name like ?) and (s.isActive = 1 or s.isActive is null) "
          	strQuery += "order by permitme_category_id, permitme_subcategory_id, permitme_section_id"
        		PermitmeResourceGroup.find_by_sql([strQuery,'%'+business_type+'%'])
        end

        def PermitmeHelper.PermitMeResultsByCategoryOnly(category)
            strQuery = "select states.name as state, c.name as category, "
            strQuery += "s.name as business_type, "
            strQuery += "sec.name as section, rg.description as resource_group_description, "
            strQuery += "p.url, p.link_title, p.link_description from permitme_resources p "
          	strQuery += "left join permitme_resource_groups rg on p.permitme_resource_group_id <=> rg.id "
          	strQuery += "left join permitme_categories c on rg.permitme_category_id <=> c.id "
          	strQuery += "left join permitme_subcategories s on rg.permitme_subcategory_id <=> s.id "
          	strQuery += "left join permitme_sections sec on rg.permitme_section_id <=> sec.id "
        		strQuery += "left join states on states.id = rg.state_id "            
          	strQuery += "where (c.name like ?) and (s.isActive = 1 or s.isActive is null) "
          	strQuery += "order by permitme_category_id, permitme_subcategory_id, permitme_section_id"
        		PermitmeResourceGroup.find_by_sql([strQuery,'%'+category+'%'])
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
            
            counties.collect  {|county|
                if !county.nil?
                    county_name = county["county_name_full"]
                    state_id = county["state_id"]
                    state_name = PermitmeHelper.getStateAlphaFromStateID(state_id)
                    if !county[0].nil?
                        county[0]["link_title"] = county_name + ", " + state_name[0]["state_alpha"]
                    end
                else
                    counties.delete(county)
                end
            }
            
            counties = process_rules(counties)
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
          # The following loop is necessary for this perticular structure as 
          # unincorporated area can be from diferrent fips_feat_id
          # but currently findAllCountySitesByFeatureAndState=>getCountiesByFeature(state_id, fips_feature_id) 
          # uses fips_features_id only.
          # dallas,tx has one city with 5 counties(same fips_feature_id), but for (georgetown, id) 
          # has two features with different fips_feat_id.
          # so if each feature gets into the PermitmeHelper.prune_unincorporated_areas @state_and_feature_array 
          # will be used and spit out county_array
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
                  sites_by_feature_id = SitesByFeatureIdQuery(templocalsite[0]["id"])
                  sites_by_feature_id
                  localSites.push(sites_by_feature_id)
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