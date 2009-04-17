xml.instruct!
x=1
xml.recommended_site_searches{ 
  for recommended_site_search in @queryResults
    xml.recommended_site_search("id" => x) do
      xml.recommended_site("recType" => @recType ) do
        xml.title(recommended_site_search.title)
        xml.url(recommended_site_search.url)
        xml.description(recommended_site_search.description)
        x=x+1
      end
    end
  end
}
