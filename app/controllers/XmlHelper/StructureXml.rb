require 'rexml/document'

module RecommendedSiteXML
include REXML
	
	def RecommendedSiteXML.getRecommendedSiteXML(queryResults, recType)
		string='<recommended_site_searches>'
          
		queryResults.each do |c|
				  string = string+<<EOF      
					  <recommended_site_search id="#{c.id}">
				       <recommended_site recType="#{recType}">
					  <title>#{c.title}</title>
					  <url>#{c.url}</url>
					  <description>#{c.description}</description>
					  </recommended_site>
					  </recommended_site_search>
				       
EOF
		end
          string = string+'</recommended_site_searches>'
		doc = Document.new string
		return doc	
	end
	
	def RecommendedSiteXML.getRecommendedSiteNotFoundXML(recType)
	string=''
	 string = string+<<EOF      
				       <recommended_site_search>
					  <recommended_site recType="#{recType}">
					  <notFound>Not Found</notFound>
					  </recommended_site>
				       </recommended_site_search>
EOF
	end
end


