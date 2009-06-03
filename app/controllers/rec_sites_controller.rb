require 'QueryHelper/StructureQuery'

class RecSitesController < ApplicationController
  
  #http://localhost:3000/rec_sites/keywords/bankruptcy
  #http://localhost:3000/rec_sites/keywords/ebay
  
  def respond_to_format(resultArray)
    respond_to do |format|
              format.html { render :text =>  resultArray.to_recSitejson }
              format.xml {render :xml => resultArray.to_recSitexml}
              format.json {render :json => resultArray.to_recSitejson}
    end
  end
      
  def keywords
    @recType='keywords'
    keywords = params[:keyword]
    @this_result = Result.new
    #if the path is /rec_sites  then show every keywords.
    if keywords.blank?
      #@queryResults= RecommendedSiteCategory.find_by_sql(RecommendedSiteQuery.getAllKeywordsQuery()) 
      @queryResults= KeywordRecommendedSiteKeyword.all(:select=>"id,keywords", :order => "id ASC")
    else
      @queryResults=KeywordRecommendedSiteKeyword.find_all_by_keywords("#{keywords}", 
      :joins =>'Left outer join keyword_recommended_sites k ON k.id= keyword_recommended_site_keywords.keyword_recommended_site_id',
      :select=>"k.title,k.description,k.url")
      #@queryResults = RecommendedSiteCategory.find_by_sql(RecommendedSiteQuery.getKeywordsQuery(keywords)) 
      @this_result.rec_sites=@queryResults
      respond_to_format(@this_result)
    end
    if @queryResults.blank?
      notFound
    end
  end
  
  #this "show" def might not needed.  Revisit again. 3/30/09 - songchoe. 
  #http://localhost:3000/rec_sites/94117
  def show
    @recType='features'
    zipcode=params[:keyword]
    @queryResults = RecommendedSiteCategory.find_by_sql(RecommendedSiteQuery.getFeaturedQueryByZipcode(zipcode))
    if @queryResults.blank?
      notFound
    end
  end
  
  # http://localhost:3000/rec_sites/20121/taxes
  def features
    zipcode=params[:keyword]
    keywords=params[:name]
    @recType='features'
    @queryResults = RecommendedSiteCategory.find_by_sql(RecommendedSiteQuery.getFeaturedQueryByZipKeywords(keywords,zipcode))
    if @queryResults.blank?
      notFound
    end
  end
  
  def notFound
    @queryResults={"NotFound"=>"No Results"}
  end
#end


  	 #http://localhost:3000/rec_sites/states/nevada
       def states
           @recType='states'
            queryResults = StateRecommendedSite.find(:all, :include => :state, :conditions => ['states.name = ?', "#{params[:name]}"])
            if queryResults.blank?
             @doc = RecommendedSiteXML.getRecommendedSiteNotFoundXML(@recType)
            else
             @doc = RecommendedSiteXML.getRecommendedSiteXML(queryResults, @recType)
            end
            render :xml => @doc
        end

     	 #http://localhost:3000/rec_sites/states
      def all_states
           @recType='states'
           queryResults = StateRecommendedSite.find(:all)
           if queryResults.blank?
              @doc = RecommendedSiteXML.getRecommendedSiteNotFoundXML(@recType)
           else
                @doc = RecommendedSiteXML.getRecommendedSiteXML(queryResults, @recType)
           end
          render :xml => @doc
      end

end
