feature "User manages their own hours" do
  let(:subdomain) { generate(:subdomain) }
  let(:user) { build(:user) }

  before(:each) do
    create(:account_with_schema, subdomain: subdomain, owner: user)
    sign_in_user(user, subdomain: subdomain)
  end

  scenario "views their hours overview" do
    2.times { create(:hour, user: user) }
    click_link I18n.t("navbar.entries")

    expect(page.title).to eq("#{user.full_name} | Hours")
    expect(page).to have_content("#{user.first_name}'s entries")
    expect(page).to have_content(user.hours.last.project.name)
  end

  scenario "views their hours overview with a yearly filter" do
    2.times { create(:hour, user: user) }
    click_link I18n.t("titles.users.index")
    click_link user.full_name
    click_link I18n.t("report.yearly")

    expect(page).to have_content(I18n.t("charts.hours_per_week"))
  end

  scenario "autolinks tags in description" do
    create(:hour, user: user, description: "#hashtags are #awesome")

    click_link I18n.t("navbar.entries")

    expect(page).to have_link("#hashtags")
  end

  scenario "sees entry attributes in edit field by default" do
    entry = create(
      :hour,
      user: user,
      description: "met a new prospect for lunch")

    click_link I18n.t("navbar.entries")
    click_link I18n.t("entries.index.edit")

    expect(page).to have_select("hour_project_id", selected: entry.project.name)
    expect(page).to have_select(
      "hour_category_id",
      selected: entry.category.name)
    expect(find_field("hour_starting_time").value).to eq(I18n.l(entry.starting_time))
    expect(find_field("hour_description").value).to eq(entry.description)
  end

  scenario "edits an entry" do
    new_project = create(:project)
    new_category = create(:category)
    new_starting_time = I18n.l(DateTime.current)
    new_description = "did some awesome #uxdesign"
    edit_entry(new_project, new_category, new_starting_time, new_description)

    click_link I18n.t("entries.index.edit")

    expect(page).to have_select("hour_project_id", selected: new_project.name)
    expect(page).to have_select("hour_category_id", selected: new_category.name)
    expect(find_field("hour_starting_time").value).to eq(new_starting_time.to_s)
    expect(find_field("hour_description").value).to eq(new_description)
  end

  scenario "can not edit someone elses entries" do
    other_user = create(:user)
    create(:hour, user: other_user)

    visit user_entries_url(other_user, subdomain: subdomain)
    expect(page).to_not have_content(I18n.t("entries.index.edit"))
  end

  private

  def edit_entry(new_project, new_category,
                  new_starting_time, new_description)
    create(:hour, user: user)
    click_link I18n.t("navbar.entries")
    click_link I18n.t("entries.index.edit")

    select(new_project.name, from: "hour_project_id")
    select(new_category.name, from: "hour_category_id")
    fill_in "hour_starting_time", with: new_starting_time
    fill_in "hour_description", with: new_description

    click_button I18n.t("helpers.submit.update")
  end
end
