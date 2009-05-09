module PermitmeHelper
  
    def CountySpecsByNameQuery (feature_name, state_id)
        Feature.find(:all, :select => "id, fips_class", :conditions => ["feat_name = ? and state_id = ?",feature_name, state_id])
    end

    def SitesByFeatureIdQuery (feature_id)
        Site.find(:all, :select => "id,description, url,name, feature_id", :conditions => ["feature_id = ? and is_primary = 1 and url is not null",feature_id])
    end

    def  PermitMeSitesByFeatureIdQuery (feature_id)
        PermitmeSite.find(:all, :select => "id,description, url,name, feature_id", :conditions => ["feature_id = ? and url is not null",feature_id])
    end

    def  PermitMeFeatureAltNameMappingQuery (alternate_name)
        Feature.find_by_sql("select features.id, fips_class, state_id, feat_name,county_name_full,majorfeature, fips_feat_id from features,alternate_names where alternate_names.feature_id = features.id and county_seq = 1 and name = ?",alternate_name)
    end

    def  PermitMeFeatureMappingQuery (feature_name, alternate_name)
        strQuery = "select id, state_id, fips_class, feat_name,county_name_full,majorfeature, fips_feat_id from features where county_seq = 1 and feat_name = ? "
    		strQuery +=	"union select features.id, state_id, fips_class, feat_name,county_name_full,majorfeature, fips_feat_id from features, alternate_names "
    		strQuery += "where feature_id = features.id and county_seq = 1 and name = ?"
    		Feature.find_by_sql(strQuery,[feature_name,alternate_name])
    end

    def  PermitMeFeatureWithStateMappingQuery (feature_name, alternate_name, state_id)
        strQuery = "select id, state_id, fips_class, feat_name,county_name_full,majorfeature, fips_feat_id from features where county_seq = 1 and feat_name = ? "
    		strQuery += "and state_id = ? union select features.id, state_id, fips_class, feat_name,county_name_full,majorfeature, fips_feat_id from features, alternate_names "
    		strQuery += "where feature_id = features.id and county_seq = 1 and name = ? and state_id = ?"
    		Feature.find_by_sql(strQuery,[feature_name,alternate_name,state_id])
  	end

    def findAllFeatureSitesByFeatureAndState (feature_id, state_alpha)
      foundSites = findAllSitesByFeatureId(feature_id)
    # May not be needed    
    # 		if foundSites.length > 0 
    #    		for (LocalSite site: foundSites)
    #    				site.setStateAbbrev(thisState.getAbbreviation())
    #    				site.setFeatureName(thisFeature.getName())
    #   				site.setFipsClass(thisFeature.getFipsClass())
    # 			end
    #   	end	
     	return foundSites
    end

    def  findAllSitesByFeatureId (feature_id)
      foundSites = permitMeSitesByFeatureIdQuery(feature_id)

      if foundSites?nil
    			foundSites =  sitesByFeatureIdQuery.execute(parms)
    	end

      return foundSites
    end

    def getCountiesByFeature (state_id, fips_feature_id)
    		Feature.find(:all, :select => "county_name_full", :conditions => ["state_id = ? and fips_feat_id=? and county_name_full is not null", state_id, fips_feature_id])
    end
  
    def permitMeCountySpecsByNameQuery (feature_id)
        PermitmeSite.Find(:all, :select => "id,description, url,name, feature_id", :conditions => ["feature_id = ? and url is not null", feature_id])
    end
  
        def  findAllCountySitesByFeatureAndState  (fips_feature_id, state_id)
    #        counties = getCountiesByFeature (state_id, fips_feature_id)
    #    		localSites = Array.new

     #       for counties.each do |county|
                # Special case for St. Louis because the St. is abbreviated in the county name
    #            if (county.matches("^St\\.(.)*")) 
    #                county(county.replaceFirst("St\\.","Saint"));
    #            end

    #            parms[0] = county
     #           countySpecs = permitMeCountySpecsByNameQuery (feature_id)

     #           if (countySpecs != null && countySpecs.size() > 0) 
     #               CountySpec thisSpec = countySpecs.get(0)
    #                Integer id = (Integer) thisSpec.id
    #                county.setId(id)

                    # For this county id get all the site and set the name for each
    #                List<LocalSite> sitesForThisCounty = this.findAllSitesByFeatureId(id)

    #                if (sitesForThisCounty != null && sitesForThisCounty.size() > 0) 

    #                   for (LocalSite site:sitesForThisCounty) 
    #                        site.setFeatureName(county.getName())
    #                        site.setStateAbbrev(thisState.getAbbreviation())
    #                        site.setFipsClass(thisSpec.fips_class)
    #                   end

     #                   localSites.addAll(sitesForThisCounty)
    #                else 
    #                    localSites.add(createDummyLocalSite(thisState, c, thisSpec.fips_class)) 
    #                end

    #            else 
                    #countySpecs is null
     #               localSites.add(createDummyLocalSite(thisState, c,null)) 
    #            end

     #        end

    #          return localSites
    end
 

end