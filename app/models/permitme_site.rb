class PermitmeSite < ActiveRecord::Base
  belongs_to :feature

  def to_s
      "#{url}"
  end
end

