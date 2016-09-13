class EntriesController < ApplicationController
  include CSVDownload

  def index
    @user = User.find_by_slug(params[:user_id])
    @hours_entries = @user.hours.by_date.page(params[:hours_pages]).per(20)
    @mileages_entries = @user.mileages.by_date.page(
      params[:mileages_pages]).per(20)

    respond_to do |format|
      format.html { @mileages_entries + @hours_entries }
      format.csv do
        send_csv(
          name: @user.name,
          hours_entries: @user.hours.by_date,
          mileages_entries: @user.mileages.by_date)
      end
    end
  end

  def destroy
    resource.destroy
    redirect_to user_entries_path(current_user) + "##{controller_name}",
                notice: t("entry_deleted.#{controller_name}")
  end

  def edit
    @entry_type = set_entry_type
  end

  private

  def set_entry_type
    params[:controller]
  end

  def parsed_date(entry_type)
    Time.strptime(params[entry_type][:date], "%d/%m/%Y %H:%M")
  end
end
