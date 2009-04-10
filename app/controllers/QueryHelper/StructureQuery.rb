module RecommendedSiteQuery
	def RecommendedSiteQuery.getKeywordsQuery(keywords)
	    returnQuery = "select k.id,k.orders,kk.keywords, k.master_term, k.title, k.description, r.name category, k.url from  keyword_recommended_sites k, recommended_site_categories r, keyword_recommended_site_keywords kk where k.id in (select keyword_recommended_site_id from keyword_recommended_site_keywords where keywords='"+keywords+"') and k.category_id=r.id and kk.keyword_recommended_site_id=k.id and kk.keywords='"+keywords+"' order by k.orders"
	end

     def RecommendedSiteQuery.getFeaturedQueryByZipKeywords(keywords, zipcode)
returnQuery= "select k.id, k.orders, kk.keywords,k.master_term, k.title, k.description, r.name category, k.url from
feature_recommended_site ref, feature_recommended_sites k, recommended_site_categories r,feature_recommended_site_keywords kk
where k.id in(select feature_recommended_site_id from feature_recommended_site_keywords where keywords='"+keywords+"') and
k.category_id =r.id and k.id in (select feature_recommended_site_id from feature_recommended_site where feature_id in (select feature_id from zipcodes where zip='"+zipcode+"')
and feature_recommended_site_id=k.id) and k.id=kk.feature_recommended_site_id and
kk.feature_recommended_site_id=ref.feature_recommended_site_id and kk.keywords='"+keywords+"' order by k.orders";
		
	end

     def RecommendedSiteQuery.getFeaturedQueryByZipcode(zipcode)
returnQuery= "select k.id, k.orders, kk.keywords,k.master_term, k.title, k.description, r.name category, k.url from
feature_recommended_site ref, feature_recommended_sites k, recommended_site_categories r,feature_recommended_site_keywords kk
where k.id in(select feature_recommended_site_id from feature_recommended_site_keywords where keywords='--GENERAL--') and
k.category_id =r.id and k.id in (select feature_recommended_site_id from feature_recommended_site where feature_id in (select feature_id from zipcodes where zip='"+zipcode+"')
and feature_recommended_site_id=k.id) and k.id=kk.feature_recommended_site_id and
kk.feature_recommended_site_id=ref.feature_recommended_site_id and kk.keywords='--GENERAL--' order by k.orders";
		
	end

	def RecommendedSiteQuery.getStatesQuery(states)
	    returnQuery = "select k.id,k.orders,kk.keywords, k.master_term, k.title, k.description, r.name category, k.url from  state_recommended_sites k, recommended_site_categories r, state_recommended_site_keywords kk where k.id in (select state_recommended_site_id from state_recommended_site_keywords where keywords='"+states+"') and k.category_id=r.id and kk.state_recommended_site_id=k.id and kk.keywords='"+states+"' order by k.orders"
	end


end
