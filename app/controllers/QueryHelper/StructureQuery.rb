module RecommendedSiteQuery
	def RecommendedSiteQuery.getKeywordsQuery(keywords)
	    returnQuery = "select k.id,k.orders,kk.keywords, k.master_term, k.title, k.description, r.name category, k.url from  keyword_recommended_sites k, recommended_site_categories r, keyword_recommended_site_keywords kk where k.id in (select keyword_recommended_site_id from keyword_recommended_site_keywords where keywords='"+keywords+"') and k.category_id=r.id and kk.keyword_recommended_site_id=k.id and kk.keywords='"+keywords+"' order by k.orders"
	end
end
