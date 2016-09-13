feature "User Report" do
  let(:subdomain) { generate(:subdomain) }
  let(:user) { build(:user) }

  before(:each) do
    create(:account_with_schema, subdomain: subdomain, owner: user)
    sign_in_user(user, subdomain: subdomain)
  end

  scenario "views all entries" do
    hour = create(:hour, value: 1000)
    visit reports_url(subdomain: subdomain)

    expect(page).to have_content(hour.value)
    expect(page).to have_content(I18n.t("entries.download_csv"))
    expect(page).to have_selector(".info-row")
  end
end
