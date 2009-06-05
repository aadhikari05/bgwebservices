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
  def RecSitesHelper.getKeywordRecommendedSiteKeywords(keywords)
    KeywordRecommendedSiteKeyword.find_all_by_keywords("#{keywords}", 
    :joins =>'Left outer join keyword_recommended_sites k ON k.id= keyword_recommended_site_keywords.keyword_recommended_site_id',
    :select=>"k.title,k.description,k.url")
  end
  
  def RecSitesHelper.getFeaturedQueryByZipKeywords(keywords, zipcode)
    strQuery= "select k.id, k.title, k.description, k.url from feature_recommended_site ref, feature_recommended_sites k, recommended_site_categories r, " + 
                 " feature_recommended_site_keywords kk where k.id in(select feature_recommended_site_id from feature_recommended_site_keywords where "+
                 " keywords='"+keywords+"') and k.category_id =r.id and k.id in (select feature_recommended_site_id from feature_recommended_site"+
                 " where feature_id in (select feature_id from zipcodes where zip='"+zipcode+"')and feature_recommended_site_id=k.id) and "+
                 " k.id=kk.feature_recommended_site_id and kk.feature_recommended_site_id=ref.feature_recommended_site_id and kk.keywords='"+keywords+"' order "+ 
                 " by k.orders";
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
