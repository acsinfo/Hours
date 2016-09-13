class Report
  def initialize(entries)
    @entries = entries.map { |e| ReportEntry.new(e) }
  end

  def headers(entry_type)
    if entry_type == "mileages"
      header = %w(date user project client mileages billable billed)
    else
      header = %w(
        starting_time
        user
        project
        category
        client
        hours
        description)
    end
    header.map do |headers|
      I18n.translate("report.headers.#{headers}")
    end
  end

  def each_row(&block)
    @entries.each(&block)
  end
end
