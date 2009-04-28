class PermitmeCategory < ActiveRecord::Base
  has_many :permitme_resource_groups
end