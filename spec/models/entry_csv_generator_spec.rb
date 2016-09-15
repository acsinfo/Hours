require "csv"

describe EntryCSVGenerator do
  let(:first_entry) { build_stubbed(:hour) }
  let(:second_entry) { build_stubbed(:hour) }

  let(:generator) do
    EntryCSVGenerator.new([first_entry, second_entry])
  end

  it "generates csv" do
    csv = generator.generate
    expect(csv).to include(
      [I18n.t("report.headers.starting_time"), I18n.t("report.headers.user"),
       I18n.t("report.headers.project"), I18n.t("report.headers.category"),
       I18n.t("report.headers.client"), I18n.t("report.headers.hours"),
       I18n.t("report.headers.description")].join(",")
    )
    expect(csv.lines.count).to eq(5)
    expect(csv.lines.second.split(",").count).to eq(1)
    expect(csv.lines.last.split(",").count).to eq(7)
  end
end