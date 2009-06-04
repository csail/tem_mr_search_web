# == Schema Information
# Schema version: 20090604175814
#
# Table name: queries
#
#  id            :integer         not null, primary key
#  start_city    :string(255)
#  end_city      :string(255)
#  layover_cost  :integer
#  time_cost     :integer
#  duration_cost :integer
#  created_at    :datetime
#  updated_at    :datetime
#

class Query < ActiveRecord::Base
  has_many :results
end
