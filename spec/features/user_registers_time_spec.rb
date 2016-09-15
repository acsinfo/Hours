feature "User registers time" do
  let(:subdomain) { generate(:subdomain) }

  before(:each) do
    @user = build(:user)
    create(:account_with_schema, subdomain: subdomain, owner: @user)
    sign_in_user(@user, subdomain: subdomain)

    create(:project, name: "CAPP11")
    create(:project, name: "Conversations")

    create(:category, name: "Design")
    create(:category, name: "Consultancy")

    visit root_url(subdomain: subdomain)
  end

  context "without taggings" do
    scenario "track time for a project" do
      within ".tab-header-and-content-left" do
        fill_in_entry
        click_button (I18n.t("helpers.submit.create"))
      end

      expect(page).to have_content (I18n.t("entry_created.hours"))
    end

    scenario "validates that hours are integers" do
      within ".tab-header-and-content-left" do
        fill_in_entry(hours: 0.5)
        click_button (I18n.t("helpers.submit.create"))
      end
      expect(page).to have_content(
        I18n.t("activerecord.attributes.hour.value") + " must be an integer")
    end
  end

  context "with taggings" do
    scenario "track time for a project with tags" do
      within ".tab-header-and-content-left" do
        fill_in_entry
        fill_in "hour_description",
                with: "Did some #pairprogramming with Hugo #internal"

        click_button (I18n.t("helpers.submit.create"))
      end

      expect(page).to have_content (I18n.t("entry_created.hours"))
      expect(Hour.last.tags.count).to eq(2)
    end
  end

  context "new entry" do
    scenario "can set starting time" do
      expect(page).to have_selector("input[id='hour_starting_time']")
    end

    scenario "cannot set ending time" do
      expect(page).not_to have_selector("input[id='hour_ending_time']")
    end
  end

  context "open entry" do
    before do
      @starting_time = I18n.l(DateTime.now - 1.hour)
      entry = create(:hour, user: @user, starting_time: @starting_time)
      visit root_url(subdomain: subdomain)
    end

    scenario "can set ending time" do
      expect(page).to have_selector("input[id='hour_ending_time']")
    end

    scenario "complete the entry" do
      expect(find_field("hour_starting_time").value).to eq(@starting_time)
      
      ending_time = I18n.l(DateTime.now)
      fill_in "hour_starting_time", with: ending_time
      click_button (I18n.t("helpers.submit.update"))

      expect(page).to have_content (I18n.t("entry_saved"))
    end
  end

  def fill_in_entry(hours: 4)
    select "Conversations", from: "Project"
    select "Design", from: "Category"
    fill_in "hour_value", with: hours
    fill_in "hour_starting_time", with: "01/02/2014 08:00"
  end
end
