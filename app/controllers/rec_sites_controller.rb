require 'QueryHelper/StructureQuery'
require 'builder'

class RecSitesController < ApplicationController
  
  def initialize
    @xml = Builder::XmlMarkup.new(:indent => 2)
  end
  
  #http://localhost:3000/rec_sites/keywords/bankruptcy
  #http://localhost:3000/rec_sites/keywords/ebay
  def keywords
    @recType='keywords'
    keywords = params[:keyword]
    @queryResults = RecommendedSiteCategory.find_by_sql(RecommendedSiteQuery.getKeywordsQuery(keywords)) 
    render :template => 'recommendedSiteResult.builder'
  end
  
  #this "show" def might not needed.  Revisit again. 3/30/09 - songchoe. 
  #http://localhost:3000/rec_sites/94117
  def show
    @recType='features'
    zipcode=params[:keyword]
    @queryResults = RecommendedSiteCategory.find_by_sql(RecommendedSiteQuery.getFeaturedQueryByZipcode(zipcode))
    render :template => 'recommendedSiteResult.builder'
  end
  
  # http://localhost:3000/rec_sites/20121/taxes
  
  def features
    zipcode=params[:keyword]
    keywords=params[:name]
    @recType='features'
    @queryResults = RecommendedSiteCategory.find_by_sql(RecommendedSiteQuery.getFeaturedQueryByZipKeywords(keywords,zipcode))
    render :template => 'recommendedSiteResult.builder'    
  end
end
