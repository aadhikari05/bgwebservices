class CreateRecommendedSiteCategories < ActiveRecord::Migration
  def self.up
    create_table :recommended_site_categories do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :recommended_site_categories
  end
end
