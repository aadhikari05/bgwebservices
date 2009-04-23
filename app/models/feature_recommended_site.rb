class FeatureRecommendedSite < ActiveRecord::Base
  has_many :feature_recommended_site_keywords
  belongs_to :recommended_site_category, 
       :foreign_key => "category_id"
  has_and_belongs_to_many :features, :join_table => "feature_recommended_site", :foreign_key => "feature_recommended_site_id", :association_foreign_key => "feature_id"
end
