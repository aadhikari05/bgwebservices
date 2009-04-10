class StateRecommendedSite < ActiveRecord::Base
  has_many :state_recommended_site_keywords
  belongs_to :state
  belongs_to :recommended_site_category, 
       :foreign_key => "category_id"
    
end
