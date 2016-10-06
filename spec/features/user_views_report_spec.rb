feature "User Report" do
  let(:subdomain) { generate(:subdomain) }
  let(:user) { build(:user, role: 'user')  }
  let(:power_user) { build(:user, role: 'power-user') }

  before(:each) do
    create(:account_with_schema, subdomain: subdomain, owner: user)
    add(power_user, subdomain)
  end

  context "simple user" do
    before(:each) do
      sign_in_user(user, subdomain: subdomain)
    end

    scenario "views own entries" do
      user_hour = create(:hour, user: user, description: 'simple hour')
      power_user_hour = create(:hour, user: power_user, description: 'power hour')
      visit reports_url(subdomain: subdomain)

      expect(page).to have_content(user_hour.description)
      expect(page).to have_no_content(power_user_hour.description)
      expect(page).to have_content(I18n.t("entries.download_csv"))
      expect(page).to have_selector(".info-row")
    end

    context "invalid from date" do
      scenario "an error message is displayed" do
        visit reports_url(subdomain: subdomain)

        fill_in "entry_filter_from_date", with: "99/02/2014"
        click_button (I18n.t("billables.buttons.filter"))

        expect(page).to have_content (I18n.t("invalid_date"))
      end
    end

    context "invalid to date" do
      scenario "an error message is displayed" do
        visit reports_url(subdomain: subdomain)

        fill_in "entry_filter_to_date", with: "99/02/2014"
        click_button (I18n.t("billables.buttons.filter"))

        expect(page).to have_content (I18n.t("invalid_date"))
      end
    end
  end

  context "power user" do
    before(:each) do
      sign_in_user(power_user, subdomain: subdomain)
    end

    scenario "views own entries" do
      user_hour = create(:hour, user: user, description: 'simple hour')
      power_user_hour = create(:hour, user: power_user, description: 'power hour')
      visit reports_url(subdomain: subdomain)

      expect(page).to have_content(user_hour.description)
      expect(page).to have_content(power_user_hour.description)
      expect(page).to have_content(I18n.t("entries.download_csv"))
      expect(page).to have_selector(".info-row")
    end
  end
end
