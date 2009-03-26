class RecommendedSiteCategory < ActiveRecord::Base
	has_many :keyword_recommended_sites, :foreign_key => "category_id"
end
