require 'QueryHelper/StructureQuery'

class RecSitesController < ApplicationController
  
  #http://localhost:3000/rec_sites/keywords/bankruptcy
  #http://localhost:3000/rec_sites/keywords/ebay
  def keywords
    @recType='keywords'
    keywords = params[:keyword]
    
    #if the path is /rec_sites  then show every keywords.
    if keywords.blank?
      @queryResults= RecommendedSiteCategory.find_by_sql(RecommendedSiteQuery.getAllKeywordsQuery()) 
    else
      @queryResults = RecommendedSiteCategory.find_by_sql(RecommendedSiteQuery.getKeywordsQuery(keywords)) 
    end 
  end
  
  #this "show" def might not needed.  Revisit again. 3/30/09 - songchoe. 
  #http://localhost:3000/rec_sites/94117
  def show
    @recType='features'
    zipcode=params[:keyword]
    @queryResults = RecommendedSiteCategory.find_by_sql(RecommendedSiteQuery.getFeaturedQueryByZipcode(zipcode))
  end
  
  # http://localhost:3000/rec_sites/20121/taxes
  def features
    zipcode=params[:keyword]
    keywords=params[:name]
    @recType='features'
    @queryResults = RecommendedSiteCategory.find_by_sql(RecommendedSiteQuery.getFeaturedQueryByZipKeywords(keywords,zipcode))
  end
end