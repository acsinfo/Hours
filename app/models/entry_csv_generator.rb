require "csv"

class EntryCSVGenerator
  def self.generate(hours_entries)
    new(hours_entries).generate
  end

  def initialize(hours_entries)
    @hours_report = Report.new(hours_entries)
  end

  def generate
    CSV.generate(options) do |csv|
      csv << []
      csv << [I18n.translate("report.headers.hours")]
      fill_fields("hours", csv)
    end
  end

  def options
    CSV::DEFAULT_OPTIONS
  end

  def get_fields(entry, entry_type)
    fields = [entry.starting_time, entry.user, entry.project]
    fields.push [entry.category]
    fields.push [entry.client, entry.value]
    fields.push [entry.description]
    fields.flatten
  end

  def fill_fields(entry_type, csv)
    report = instance_variable_get("@#{entry_type}_report")
    csv << report.headers(entry_type)
    report.each_row do |entry|
      csv << get_fields(entry, entry_type)
    end
  end
end
