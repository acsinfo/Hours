class BillableList
  attr_reader :clients, :hours_entries

  def initialize(hours_entries)
    @hours_entries = hours_entries

    @clients = Client.eager_load(projects: [hours: [:user, :category]])
                     .where( "hours.id in (?)", hours_entries.map(&:id))
                     .by_last_updated
  end
end
