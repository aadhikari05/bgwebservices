class StateRecommendedSiteKeyword < ActiveRecord::Base
  belongs_to :state_recommended_site

  def name
    "#{keywords}"
  end     
end
