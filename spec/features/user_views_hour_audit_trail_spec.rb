feature "User views Hour Audit Trail" do
  let(:subdomain) { generate(:subdomain) }
  let(:user) { build(:user, role: 'user') }
  let(:power_user) { build(:user, role: 'power-user') }
  let(:simple_entry) { create(:hour, user: user) }
  let(:power_entry) { create(:hour, user: power_user) }

  before(:each) do
    create(:account_with_schema, subdomain: subdomain, owner: user)
    add(power_user, subdomain)

  end

  context "simple user" do
    before(:each) do
      sign_in_user(user, subdomain: subdomain)
    end

    scenario "views own audit" do
      update_simple_entry

      visit hour_audits_url(simple_entry, subdomain: subdomain)
      expect(current_path).to eq "/hours/#{simple_entry.id}/audits"
    end

    scenario "doesn't view others audit" do
      update_power_entry

      visit hour_audits_url(power_entry, subdomain: subdomain)
      expect(current_path).to eq "/"
    end
  end

  context "power user" do
    before(:each) do
      sign_in_user(power_user, subdomain: subdomain)
    end

    scenario "views own audit" do
      update_power_entry

      visit hour_audits_url(power_entry, subdomain: subdomain)
      expect(current_path).to eq "/hours/#{power_entry.id}/audits"
    end

    scenario "views others audit" do
      update_simple_entry

      visit hour_audits_url(simple_entry, subdomain: subdomain)
      expect(current_path).to eq "/hours/#{simple_entry.id}/audits"
    end
  end

  private

  def update_simple_entry
    Audited.audit_class.as_user(user) do
      simple_entry.update_attribute(:value, 200)
    end
  end

  def update_power_entry
    Audited.audit_class.as_user(user) do
      power_entry.update_attribute(:value, 200)
    end
  end
end
