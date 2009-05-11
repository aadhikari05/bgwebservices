class PermitmeController < ApplicationController
  
    def permitme_by_zip
        #http://localhost:3000/permitme/by_zip/child%20care%20services/22209.xml
        #We take the zip and use it to get state_id and fips_feature_id for a particular zip
        #using getFeatureAndStatebyZip for now, change to findAllCountySitesByFeatureAndState and save to countyResults array
        @state_and_feature = getFeatureAndStatebyZip (params[:zip])
        @county_sites = Array.new
        @local_sites = Array.new
        @state_sites = Array.new
        
        @business_type_id = getBusinessTypeIdFromBusinessType (params[:business_type])
        
        #We pass the state_id and fips_feat_id to the function below to get the list of County Sites
        for ss in 0...@state_and_feature.length
            #Get County Sites
            @county_sites << findAllCountySitesByFeatureAndState (@state_and_feature[ss]["state_id"], @state_and_feature[ss]["fips_feat_id"], @state_and_feature[ss]["feature_id"])
            
            #Get Primary Local Sites
            @local_sites << findAllSitesByFeatureId (@state_and_feature[ss]["feature_id"])

            #Add State Results
            @state_sites << PermitMeResultsByBusinessTypeQuery (@state_and_feature[ss]["state_id"], @business_type_id)
        end
        
        #Creating the Array that will hold the final resultset
#        @queryResults = Array.new
        @queryResults = [{"county_sites" => @county_sites}, {"local_sites" => @local_sites}, {"state_sites" => @state_sites}]
        respond_to do |format|
            format.xml {render :xml => @queryResults}
            format.json {render :json => @queryResults}
        end
    end

    def permitme_by_state_only
        #http://localhost:3000/permitme/state_only/child%20care%20services/il.xml
        @queryResults = PermitmeResource.find_by_sql(["select Link_Title, Url from permitme_resources where permitme_resource_group_id in (select id from permitme_resource_groups where permitme_subcategory_id in (select id from permitme_subcategories where isExclusive=1 and isActive=1 and name = ?) and state_id in (select id from states where alpha=?))",params[:business_type],params[:alpha]])

        respond_to_format (@queryResults)
    end

    def permitme_by_state_and_feature
        #http://localhost:3000/permitme/state_and_city/child%20care%20services/il/baldwin.xml
        @queryResults = PermitmeResource.find_by_sql(["select Link_Title, Url from permitme_resources where permitme_resource_group_id in (select id from permitme_resource_groups where permitme_subcategory_id in (select id from permitme_subcategories where isExclusive=1 and isActive=1 and name = ?) and state_id in (select distinct(f.state_id) from features f, states s where f.feat_name like ? and s.alpha=? and f.state_id = s.id))",params[:business_type],"%"+params[:feature]+"%",params[:alpha]])

        respond_to_format (@queryResults)
    end
  
    def respond_to_format (resultArray)
        respond_to do |format|
          format.xml {render :xml => resultArray}
          format.json {render :json => resultArray}
        end
    end
    
    def getBusinessTypeIdFromBusinessType (business_type)
        PermitmeSubcategory.find(:all, :select => "id", :conditions => ["isExclusive=1 and isActive=1 and name = ?",business_type])
    end

      def getFeatureAndStatebyZip (zip)
        Feature.find_by_sql(["select state_id, fips_feat_id, feature_id from features,zipcodes where zipcodes.sequence = 1 and zipcodes.feature_id = features.id and county_seq = 1 and zip = ?",zip])
#          Feature.find_by_sql(["select features.id, fips_class, state_id, feat_name,county_name_full,majorfeature, fips_feat_id from features,zipcodes where zipcodes.sequence = 1 and zipcodes.feature_id = features.id and county_seq = 1 and zip = ?",zip])
#          Feature.find(:all, :select => "feat_name, state_id", :joins => "LEFT OUTER JOIN `zipcodes` ON zipcodes.feature_id = features.id", :conditions => ["zipcodes.zip = ?",zip])
      end

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
      		Feature.find_by_sql([strQuery,feature_name,alternate_name])
      end

      def  PermitMeFeatureWithStateMappingQuery (feature_name, alternate_name, state_id)
          strQuery = "select id, state_id, fips_class, feat_name,county_name_full,majorfeature, fips_feat_id from features where county_seq = 1 and feat_name = ? "
      		strQuery += "and state_id = ? union select features.id, state_id, fips_class, feat_name,county_name_full,majorfeature, fips_feat_id from features, alternate_names "
      		strQuery += "where feature_id = features.id and county_seq = 1 and name = ? and state_id = ?"
      		Feature.find_by_sql([strQuery,feature_name,alternate_name,state_id])
    	end

      def PermitMeResultsByStateQuery (state_id)
          strQuery = "select rg.id, state_id, c.name as category, s.name as subcategory, sec.name as section, rg.description, p.URL, p.link_title "
      		strQuery += "from permitme_resource_groups rg join permitme_resources p on p.permitme_resource_group_id = rg.id "
      		strQuery += "left join permitme_categories c on rg.permitme_category_id <=> c.id "
      		strQuery += "left join permitme_subcategories s on rg.permitme_subcategory_id <=> s.id "
      		strQuery += "left join permitme_sections sec on rg.permitme_section_id <=> sec.id "
      		strQuery += "where state_id= ? "
      		strQuery += "and (s.isExclusive <=> 0 or s.isExclusive is null) "
      		strQuery += "and (s.isActive = 1 or s.isActive is null) "
      		strQuery += "order by permitme_category_id, permitme_subcategory_id, permitme_section_id"
      		PermitmeResourceGroup.find_by_sql([strQuery,state_id])
      end
      
      def PermitMeResultsByBusinessTypeQuery (state_id, business_type_id)
          strQuery = "select rg.id, state_id, c.name as category, s.name as subcategory, sec.name as section, rg.description, p.URL, p.link_title "
      		strQuery += "from permitme_resource_groups rg join permitme_resources p on p.permitme_resource_group_id = rg.id "
      		strQuery += "left join permitme_categories c on rg.permitme_category_id <=> c.id "
      		strQuery += "join permitme_subcategories s on rg.permitme_subcategory_id <=> s.id "
      		strQuery += "left join permitme_sections sec on rg.permitme_section_id <=> sec.id "
      		strQuery += "where state_id= ? and url is not null "
      		strQuery += "and (s.id = ?) "
      		strQuery += "and (s.isActive = 1 or s.isActive is null) "
      		strQuery += "order by permitme_category_id, permitme_subcategory_id, permitme_section_id"
      		PermitmeResourceGroup.find_by_sql([strQuery,state_id,business_type_id])
      end
      
      def findAllFeatureSitesByFeatureAndState (feature_id, state_alpha)
        foundSites = findAllSitesByFeatureId (feature_id)
      # May not be needed
      #-------------------   
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
        foundSites = PermitMeSitesByFeatureIdQuery(feature_id)

        if foundSites.empty?
      			foundSites =  SitesByFeatureIdQuery(feature_id)
      	end

        return foundSites
      end

      def permitMeCountySpecsByNameQuery (feature_id)
          PermitmeSite.find(:all, :select => "id,description, url,name, feature_id", :conditions => ["feature_id = ? and url is not null", feature_id])
      end

      def getCountiesByFeature (state_id, fips_feature_id)
      		Feature.find(:all, :select => "id, county_name_full, fips_class", :conditions => ["state_id = ? and fips_feat_id=? and county_name_full is not null", state_id, fips_feature_id])
      end

      def  findAllCountySitesByFeatureAndState  (state_id, fips_feature_id,feature_id)
          #The following will return id, county_name_full and fips_class
          counties = getCountiesByFeature (state_id, fips_feature_id)
          localSites = Array.new

          counties.each do |county|
                # Special case for St. Louis because the St. is abbreviated in the county name
    #           if (county.matches("^St\\.(.)*")) 
     #               county(county.replaceFirst("St\\.","Saint"));
      #          end

                # get county specs like id,description, url,name, feature_id from feature_id
                countySpecs = permitMeCountySpecsByNameQuery (feature_id.to_i)

                for currentSpec in 0...countySpecs.length
                      #For this county id get all the sites and set the name for each
                    sitesForThisCounty = this.findAllSitesByFeatureId(countySpecs[currentSpec]["id"])

#                    if sitesForThisCounty.length > 0
#                       for site in sitesForThisCounty
#                            site.setFeatureName(countySpecs[currentSpec]["county_name_full"]county[.getName()])
#                            site.setStateAbbrev(countySpecs[currentSpec]["abbreviation"]thisState.getAbbreviation())
#                            site.setFipsClass(countySpecs[currentSpec]["fips_class"]thisSpec.fips_class)
#                       end

                        localSites << sitesForThisCounty
#                    else 
#                        localSites << (createDummyLocalSite(thisState, c, thisSpec.fips_class)) 
#                    end
                end
         end

        return localSites
    end

end