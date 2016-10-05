feature "User views personal report" do
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

    scenario "views own report" do
      visit user_url(user, subdomain: subdomain)
      expect(current_path).to eq "/users/#{user.slug}"
    end

    scenario "views last week" do
      visit user_url(user, subdomain: subdomain)
      click_link I18n.t("report.weekly")
      expect(page).to have_content(I18n.t("report.hours_per_day", count: 7))
    end

    scenario "doesn't view others report" do
      visit user_url(power_user, subdomain: subdomain)
      expect(current_path).to eq "/"
    end
  end

  context "power user" do
    before(:each) do
      sign_in_user(power_user, subdomain: subdomain)
    end

    scenario "views own report" do
      visit user_url(power_user, subdomain: subdomain)
      expect(current_path).to eq "/users/#{power_user.slug}"
    end

    scenario "views others report" do
      visit user_url(user, subdomain: subdomain)
      expect(current_path).to eq "/users/#{user.slug}"
    end
  end
end
