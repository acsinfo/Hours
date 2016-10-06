# == Schema Information
#
# Table name: hours
#
#  id             :integer          not null, primary key
#  project_id     :integer          not null
#  category_id    :integer          not null
#  user_id        :integer          not null
#  value          :integer
#  starting_time  :datetime         not null
#  ending_time    :datetime
#  created_at     :datetime
#  updated_at     :datetime
#  description    :string
#  billed         :boolean          default("false")
#

class Hour < Entry
  include PgSearch
  pg_search_scope :search_by_description, :against => :description

  audited allow_mass_assignment: true

  belongs_to :category

  has_many :taggings, inverse_of: :hour
  has_many :tags, through: :taggings

  validates :category, presence: true

  accepts_nested_attributes_for :taggings

  scope :by_last_created_at, -> { order("created_at DESC") }
  scope :by_starting_time, -> { order("starting_time DESC") }
  scope :billable, -> { where("billable").joins(:project) }
  scope :with_clients, -> {
    where.not("projects.client_id" => nil).joins(:project)
  }
  scope :open_per_user, ->(user_id) { where(user_id: user_id, ending_time: nil) }
  scope :by_last_created_per_user, ->(user_id) { where(user_id: user_id).order("created_at DESC") }

  before_save :set_tags_from_description

  def tag_list
    tags.map(&:name).join(", ")
  end

  def self.query(params, includes = nil)
    EntryQuery.new(self.includes(includes).by_starting_time, params, "hours").filter
  end

  def time
    if ending_time
      ending_time - starting_time
    else
      0
    end
  end

  private

  def set_tags_from_description
    tagnames = extract_hashtags(description)
    self.tags = tagnames.map do |tagname|
      Tag.where("name ILIKE ?", tagname.strip).first_or_initialize.tap do |tag|
        tag.name = tagname.strip
        tag.save!
      end
    end
  end
end
