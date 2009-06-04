# == Schema Information
# Schema version: 20090604175814
#
# Table name: results
#
#  id         :integer         not null, primary key
#  query_id   :integer
#  record_id  :integer
#  score      :integer
#  start_time :integer
#  end_time   :integer
#  price      :integer
#  layovers   :integer
#  start_city :string(255)
#  end_city   :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Result < ActiveRecord::Base
  belongs_to :query
end
