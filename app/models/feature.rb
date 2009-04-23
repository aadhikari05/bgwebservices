class Feature < ActiveRecord::Base
  has_and_belongs_to_many :feature_recommended_sites, :join_table => "feature_recommended_site", :foreign_key => "feature_id", :association_foreign_key => "feature_recommended_site_id"

end
