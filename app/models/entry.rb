class Entry < ActiveRecord::Base
  self.abstract_class = true

  include Twitter::Extractor

  validates :user, :project, :starting_time, presence: true

  audited allow_mass_assignment: true

  has_one :client, through: :project

  belongs_to :user, touch: true
  belongs_to :project, touch: true
end
