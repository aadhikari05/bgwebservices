module PermitmeHelper
  
#	featureAltNameMappingQuery = new PermitMeFeatureAltNameMappingQuery(ds);
	
#	sitesByFeatureIdQuery = new SitesByFeatureIdQuery(ds);
	
#	permitMeCountySpecsByNameQuery = new CountySpecsByNameQuery(ds);
#	permitMeSitesByFeatureIdQuery = new PermitMeSitesByFeatureIdQuery(ds);
#	permitMeFeatureWithStateMappingQuery = new PermitMeFeatureWithStateMappingQuery(ds);

  def CountySpecsByNameQuery
    strQuery = "select id, fips_class from features where feat_name = ? and state_id = ?"
  end
  
  def SitesByFeatureIdQuery
    strQuery = "select id,description, url,name, feature_id from sites where feature_id = ? and is_primary = 1 and url is not null"
  end
  
  def  PermitMeSitesByFeatureIdQuery
    strQuery = "select id,description, url,name, feature_id from permitme_sites where feature_id = ? and url is not null"
  end
  
  def  PermitMeFeatureAltNameMappingQuery
    strQuery = "select features.id, fips_class, state_id, feat_name,county_name_full,majorfeature, fips_feat_id from features,alternate_names where alternate_names.feature_id = features.id and county_seq = 1 and name = ?"
  end

  def  PermitMeFeatureMappingQuery
    strQuery = "select id, state_id, fips_class, feat_name,county_name_full,majorfeature, fips_feat_id from features where county_seq = 1 and feat_name = ? "
		strQuery +=	"union select features.id, state_id, fips_class, feat_name,county_name_full,majorfeature, fips_feat_id from features, alternate_names "
		strQuery += "where feature_id = features.id and county_seq = 1 and name = ?"
  end

  def  PermitMeFeatureWithStateMappingQuery
    strQuery = "select id, state_id, fips_class, feat_name,county_name_full,majorfeature, fips_feat_id from features where county_seq = 1 and feat_name = ? "
		strQuery += "and state_id = ? union select features.id, state_id, fips_class, feat_name,county_name_full,majorfeature, fips_feat_id from features, alternate_names "
		strQuery += "where feature_id = features.id and county_seq = 1 and name = ? and state_id = ?"
	end

  def findAllFeatureSitesByFeatureAndState (feature_id, state_alpha)
    foundSites = findAllSitesByFeatureId(feature_id)
 		if (foundSites != null) {
      			for (LocalSite site: foundSites){
      				site.setStateAbbrev(thisState.getAbbreviation());
      				site.setFeatureName(thisFeature.getName());
     				site.setFipsClass(thisFeature.getFipsClass());
   				}
   			}
   			
   	return foundSites;
  end
  
  def  findAllSitesByFeatureId
    foundSites = permitMeSitesByFeatureIdQuery.execute(parms)
    
    if (foundSites == null || foundSites.size() == 0) {
			
			foundSites =  sitesByFeatureIdQuery.execute(parms);
		}
		
  end

  def  findAllCountySitesByFeatureAndState  (Feature thisFeature, State thisState)
    List<County> counties = getCountiesByFeature(thisFeature) # special case for st.louis
		List<LocalSite> localSites = new ArrayList<LocalSite>();
		
		for (County c : counties) {
			
			// Special case for St. Louis because the St. is abbreviated in the county name
			// This is the fix for SBA-255
			
			if (c.getName().matches("^St\\.(.)*")) {
				c.setName(c.getName().replaceFirst("St\\.","Saint"));
			}
			
			parms[0] = c.getName();
			List<CountySpec> countySpecs = permitMeCountySpecsByNameQuery.execute(parms);
			
			if (countySpecs != null && countySpecs.size() > 0) {
				CountySpec thisSpec = countySpecs.get(0);
				Integer id = (Integer) thisSpec.id;
				c.setId(id);
			
				// For this county id get all the site and set the name for each
				List<LocalSite> sitesForThisCounty = this.findAllSitesByFeatureId(id);
			
				if (sitesForThisCounty != null && sitesForThisCounty.size() > 0) {
				
					for (LocalSite site:sitesForThisCounty) {
					
						site.setFeatureName(c.getName());
						site.setStateAbbrev(thisState.getAbbreviation());
						site.setFipsClass(thisSpec.fips_class);
					}
				
					localSites.addAll(sitesForThisCounty);
				}
			
				else {// no sites found
				
					localSites.add(createDummyLocalSite(thisState, c, thisSpec.fips_class)); // Because no site was found for this county
				
				}
			} // end if countyIds
			
			else {
				
				localSites.add(createDummyLocalSite(thisState, c,null)); // Because no spec was found for this county
			}
		}
		
		return localSites;
  end
end