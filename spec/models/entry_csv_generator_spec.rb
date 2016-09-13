require "csv"

describe EntryCSVGenerator do
  let(:first_entry) { build_stubbed(:hour) }
  let(:second_entry) { build_stubbed(:hour) }

  let(:generator) do
    EntryCSVGenerator.new([first_entry, second_entry], [])
  end

  it "generates csv" do
    csv = generator.generate
    expect(csv).to include(
      "Starting time,User,Project,Category,Client,Hours,Description")
    expect(csv.lines.count).to eq(5)
    expect(csv.lines.second.split(",").count).to eq(1)
    expect(csv.lines.last.split(",").count).to eq(7)
  end

  it "localizes the separator" do
    I18n.locale = :nl
    expect(generator.options).to include(col_sep: ";")
    I18n.locale = I18n.default_locale
    expect(generator.options).to include(col_sep: ",")
  end
end
