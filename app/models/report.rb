class Report
  def initialize(entries)
    @entries = entries.map { |e| ReportEntry.new(e) }
  end

  def headers(entry_type)
    header = %w(
      starting_time
      ending_time
      user
      project
      category
      client
      hours
      description)
    header.map do |headers|
      I18n.translate("report.headers.#{headers}")
    end
  end

  def each_row(&block)
    @entries.each(&block)
  end
end