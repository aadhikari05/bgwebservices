require 'QueryHelper/StructureQuery'
require 'rexml/document'
  
class RecSitesController < ApplicationController
include REXML

     def keywords
          @header= '<recommended_site_search>'
          @footer= '</recommended_site_search>'
          keywords = params[:id]
	     string=''
	     @queryResults = RecommendedSiteCategory.find_by_sql(RecommendedSiteQuery.getKeywordsQuery(keywords))
	     @queryResults.each do |c|
		  string = string+<<EOF      
		       <recommended_site recType="keywords">
		       <title>#{c.title}</title>
		       <url>#{c.url}</url>
		       <description>#{c.description}</description>
		       </recommended_site>
EOF
             end

          @doc = Document.new @header+string+@footer
          render :xml => @doc
      end

	def 
end
