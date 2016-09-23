# == Schema Information
#
# Table name: clients
#
#  id                :integer          not null, primary key
#  name              :string           default(""), not null
#  description       :string           default("")
#  created_at        :datetime
#  updated_at        :datetime
#

class Client < ActiveRecord::Base
  validates :name, presence: true,
                   uniqueness: { case_sensitive: false }
  scope :by_name, -> { order("lower(name)") }
  scope :by_last_updated, -> { order("clients.updated_at DESC") }
  has_many :projects

  has_many :hours, through: :projects
end
