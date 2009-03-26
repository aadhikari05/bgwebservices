class CreateKeywordRecommendedSiteKeywords < ActiveRecord::Migration
  def self.up
    create_table :keyword_recommended_site_keywords do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :keyword_recommended_site_keywords
  end
end
