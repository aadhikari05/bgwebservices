require 'QueryHelper/StructureQuery'
require 'XmlHelper/StructureXml'
require 'rexml/document'
  
class RecSitesController < ApplicationController
include REXML

	def initialize
          #@header= '<recommended_site_search>'
          #@footer= '</recommended_site_search>'
	end

	 #http://localhost:3000/rec_sites/keywords/bankruptcy
     def keywords
         @recType='keywords'
          keywords = params[:id]
	     queryResults = RecommendedSiteCategory.find_by_sql(RecommendedSiteQuery.getKeywordsQuery(keywords))
          if queryResults.blank?
           @doc = RecommendedSiteXML.getRecommendedSiteNotFoundXML(@recType)
          else
           @doc = RecommendedSiteXML.getRecommendedSiteXML(queryResults, @recType)
          end
          render :xml => @doc
      end

	 #this "show" def might not needed.  Revisit again. 3/30/09 - songchoe. 
     #http://localhost:3000/rec_sites/94117
	def show
        @recType='features'
		zipcode=params[:id]
     	queryResults = RecommendedSiteCategory.find_by_sql(RecommendedSiteQuery.getFeaturedQueryByZipcode(zipcode))
	    if queryResults.blank?
           @doc = RecommendedSiteXML.getRecommendedSiteNotFoundXML(@recType)
        else
           @doc = RecommendedSiteXML.getRecommendedSiteXML(queryResults, @recType)
        end  

        render :xml => @doc
     end

	 # http://localhost:3000/rec_sites/20121/taxes
     # http://localhost:3000/rec_sites/ebay
     def features
		zipcode=params[:id]
		keywords=params[:name]
        @recType='features'
     	queryResults = RecommendedSiteCategory.find_by_sql(RecommendedSiteQuery.getFeaturedQueryByZipKeywords(keywords,zipcode))
	    if queryResults.blank?
           @doc = RecommendedSiteXML.getRecommendedSiteNotFoundXML(@recType)
        else
           @doc = RecommendedSiteXML.getRecommendedSiteXML(queryResults, @recType)
        end
	   
        render :xml => @doc
     end
end
