class Feature < ActiveRecord::Base
  has_and_belongs_to_many :feature_recommended_sites, :join_table => "feature_recommended_site", :foreign_key => "feature_id", :association_foreign_key => "feature_recommended_site_id"
  has_many :zipcodes
  has_many :sites
  has_many :site_filters
  has_many :alternate_names
  has_many :permitme_sites

end
