require 'rexml/document'

module RecommendedSiteXML
include REXML
	
	def RecommendedSiteXML.getRecommendedSiteXML(queryResults, recType)
		string=''
          
		queryResults.each do |c|
				  string = string+<<EOF      
				       <recommended_site_search>
					  <recommended_site recType="#{recType}">
					  <title>#{c.title}</title>
					  <url>#{c.url}</url>
					  <description>#{c.description}</description>
					  </recommended_site>
				       </recommended_site_search>
EOF
		end
		doc = Document.new string
		return doc	
	end
end


