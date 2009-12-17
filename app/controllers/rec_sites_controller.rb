require 'QueryHelper/StructureQuery'

class RecSitesController < ApplicationController
  
  def respond_to_format(resultArray)
    respond_to do |format|
      format.html { render :text =>  resultArray.to_recSitejson }
      format.xml {render :xml => resultArray.to_recSitexml}
      format.json {render :json => resultArray.to_recSitejson}
    end
  end
  
  #http://localhost:3000/rec_sites/keywords/bankruptcy
  #http://localhost:3000/rec_sites/keywords/ebay.xml
  def keywords
      @recType='keywords'
      keywords = params[:keyword]
      @this_result = Result.new

      @queryResults=RecSitesHelper.getKeywordRecommendedSiteKeywords(keywords)
      @this_result.rec_sites=@queryResults
      respond_to_format(@this_result)
  end
  
  #http://localhost:3000/rec_sites/all_sites/keywords.xml
  def all_keyword_sites
      @recType='keywords'
      @this_result = Result.new
      @queryResults=RecSitesHelper.getAllKeywordRecommendedSites()
      @this_result.rec_sites=@queryResults
      respond_to_format(@this_result)
  end
  
  #http://localhost:3000/rec_sites/category/financing.xml
  def category
    @recType='category'
    category = params[:category]
    @this_result = Result.new
    @queryResults=RecSitesHelper.getRecommendedSitesByCategory(category)
    @this_result.rec_sites=@queryResults
    respond_to_format(@this_result)
  end
  
  #http://localhost:3000/rec_sites/domain/business.xml
  def domain
    @recType='domain'
    domain = params[:domain]
    @this_result = Result.new
    @queryResults=RecSitesHelper.getRecommendedSitesByDomain(domain)
    @this_result.rec_sites=@queryResults
    respond_to_format(@this_result)
  end
  
  #http://localhost:3000/rec_sites/features/20121/taxes.xml
  def features
    zipcode=params[:zip]
    keywords=params[:keyword]
    @this_result = Result.new
    
    @recType='features'
    @queryResults = RecSitesHelper.getFeaturedQueryByZipKeywords(keywords, zipcode)
    @queryResults = RecSitesHelper.cleanEmptyResults(@queryResults)
    @this_result.rec_sites=@queryResults
    respond_to_format(@this_result)
  end
  
  #http://localhost:3000/rec_sites/states/florida.xml
  def states
    @this_result = Result.new
    @recType='states'
    queryResults = RecSitesHelper.getStateRecommendedSite(params[:keyword])
    queryResults = RecSitesHelper.cleanEmptyResults(queryResults)
    @this_result.rec_sites=queryResults
    respond_to_format(@this_result)
  end
  
  #http://localhost:3000/rec_sites/states.xml
  def all_states
    @recType='states'
    @this_result = Result.new
    queryResults = RecSitesHelper.getAllStateRecommendedSite
    queryResults = RecSitesHelper.cleanEmptyResults(queryResults)
    @this_result.rec_sites=queryResults
    respond_to_format(@this_result)
  end
end