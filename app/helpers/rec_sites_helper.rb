module RecSitesHelper
  
  ####################################################
  # H E L P E R   F U N C T I O N S
  ####################################################
  def RecSitesHelper.find_by_keywords(keywords)
    @queryResults=RecSitesHelper.getKeywordRecommendedSiteKeywords(keywords)
  end
  
  def RecSitesHelper.KeywordRecommendedSiteKeyword
    RecSitesHelper.getKeywordRecommendedSiteKeywordAll
  end
    
  ####################################################
  # RecommendedSite   Q U E R I E S
  ####################################################
  def RecSitesHelper.getKeywordRecommendedSitesByKeyword(keywords)
      strQuery = "select url, title, description,  krsk.keywords, rsc.name as category, orders, master_term "
      strQuery += "from keyword_recommended_sites krs "
      strQuery += "left join recommended_site_categories rsc on rsc.id = krs.category_id "
      strQuery += "left join keyword_recommended_site_keywords krsk on krsk.keyword_recommended_site_id = krs.id "
      strQuery += "where (krsk.keywords = ?) and url is not null"
    KeywordRecommendedSiteKeyword.find_by_sql([strQuery,keywords])            
  end
  
  def RecSitesHelper.getAllKeywordRecommendedSites()
      strQuery  = "SELECT krs.id, url, title, description, orders, rsc.name as category, master_term "
      strQuery += "FROM keyword_recommended_sites krs "
      strQuery += "left join recommended_site_categories rsc on rsc.id = krs.category_id"
      KeywordRecommendedSite.find_by_sql(strQuery)            
  end
  
  def RecSitesHelper.getKeywordsBySiteID(site_id)
      KeywordRecommendedSiteKeyword.find(:all, :select => "keywords", :conditions => ["keyword_recommended_site_id = ?", site_id])
  end
  
  def RecSitesHelper.getRecommendedSitesByCategory(category)
      strQuery= "SELECT k.id, url, title, description, name as category, orders, master_term "
      strQuery += "FROM keyword_recommended_sites k "
      strQuery += "left join recommended_site_categories rsc on k.category_id = rsc.id "
      strQuery += "WHERE (rsc.name = '"+category+"') and url is not null"
    KeywordRecommendedSiteKeyword.find_by_sql(strQuery)            
  end
  
  def RecSitesHelper.getRecommendedSitesByDomain(domain)
      strQuery= "SELECT k.id, url, title, description, name as category, orders, master_term "
      strQuery += "FROM keyword_recommended_sites k "
      strQuery += "left join recommended_site_categories rsc on k.category_id = rsc.id "
      strQuery += "WHERE (k.url like 'http://www."+domain+"%') and url is not null"
      KeywordRecommendedSiteKeyword.find_by_sql(strQuery)            
  end
  
  def RecSitesHelper.getRecommendedSitesByMasterTerm(master_term)
      strQuery= "SELECT k.id, url, title, description, name as category, orders, master_term "
      strQuery += "FROM keyword_recommended_sites k "
      strQuery += "left join recommended_site_categories rsc on k.category_id = rsc.id "
      strQuery += "WHERE (k.master_term = '"+master_term+"') and url is not null"
    KeywordRecommendedSiteKeyword.find_by_sql(strQuery)            
  end
  
  def RecSitesHelper.getFeaturedQueryByZipKeywords(keywords, zipcode)
      strQuery= "select k.id, k.title, k.description, k.url "
      strQuery += "from feature_recommended_site ref, feature_recommended_sites k, recommended_site_categories r, "
      strQuery += "feature_recommended_site_keywords kk "
      strQuery += "where k.id in "
      strQuery += "(select feature_recommended_site_id from feature_recommended_site_keywords "
      strQuery += "where keywords='"+keywords+"') and k.category_id =r.id and k.id in "
      strQuery += "(select feature_recommended_site_id from feature_recommended_site "
      strQuery += "where feature_id in "
      strQuery += "(select feature_id from zipcodes where zip='"+zipcode+"') and feature_recommended_site_id=k.id) and "
      strQuery += "k.id=kk.feature_recommended_site_id and kk.feature_recommended_site_id=ref.feature_recommended_site_id "
      strQuery += "and kk.keywords='"+keywords+"' order by k.orders"
      RecommendedSiteCategory.find_by_sql(strQuery)            
  end
 
  #########################################################
  # S Q L   Q U E R I E S   T O   S I N G L E   T A B L E S
  #########################################################

  def RecSitesHelper.getStateRecommendedSite(state_name)
    StateRecommendedSite.find(:all, :include => :state, :conditions => ['states.name = ?', state_name])
  end
  
  def RecSitesHelper.getAllStateRecommendedSite
    StateRecommendedSite.find(:all)
  end
  
  def RecSitesHelper.getKeywordRecommendedSiteKeywordAll
    KeywordRecommendedSiteKeyword.all(:select=>"id,keywords", :order => "id ASC")
  end

end
