xml.instruct!
x=1
xml.recommended_site_searches{ 
  for recommended_site_search in @queryResults
    xml.recommended_site_search("id" => x) do
      xml.recommended_site("recType" => @recType ) do
        xml.title(recommended_site_search.title)
        xml.url(recommended_site_search.url)
        xml.description(recommended_site_search.description)
        xml.keywords(recommended_site_search.keywords)
        xml.category(recommended_site_search.category)
        xml.orders(recommended_site_search.orders)
        x=x+1
      end
    end
  end
}
