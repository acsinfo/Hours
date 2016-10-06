feature "User views Entry Audit Trail" do
  let(:subdomain) { generate(:subdomain) }
  let(:user) { build(:user, role: 'user') }
  let(:power_user) { build(:user, role: 'power-user') }
  let(:hours_entry) { create(:hour, user: user, value: 100) }

  before(:each) do
    create(:account_with_schema, subdomain: subdomain, owner: user)
    add(power_user, subdomain)
  end

  context "simple user" do
    before(:each) do
      sign_in_user(user, subdomain: subdomain)
    end

    scenario "views own audit" do
      visit user_entries_url(user, subdomain: subdomain)
      expect(current_path).to eq "/users/#{user.slug}/entries"
    end

    scenario "doesn't view others audit" do
      visit user_entries_url(power_user, subdomain: subdomain)
      expect(current_path).to eq "/"
    end

    scenario "links to hours audit path" do
      update_hours_entry

      visit user_entries_url(user, subdomain: subdomain)
      last_entry = page.find(".entries-table .info-row:first-child")
      expect(last_entry).to have_content("changes")
    end

    scenario "displays hours audit trail" do
      update_hours_entry

      visit hour_audits_url(hours_entry, subdomain: subdomain)
      last_change = page.find(".audit:last-child")
      expect(last_change.find(".changes")).to have_content changed_value(100, 200)
    end
  end

  context "power user" do
    before(:each) do
      sign_in_user(power_user, subdomain: subdomain)
    end

    scenario "views own audit" do
      visit user_entries_url(power_user, subdomain: subdomain)
      expect(current_path).to eq "/users/#{power_user.slug}/entries"
    end

    scenario "views others audit" do
      visit user_entries_url(user, subdomain: subdomain)
      expect(current_path).to eq "/users/#{user.slug}/entries"
    end
  end

  private

  def changed_value(value1, value2)
    I18n.t("audits.from") + " " +
      value1.to_s + " " +
      I18n.t("audits.to") + " " +
      value2.to_s
  end

  def update_hours_entry
    Audited.audit_class.as_user(user) do
      hours_entry.update_attribute(:value, 200)
    end
  end
end
