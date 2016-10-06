class EntriesController < ApplicationController
  include CSVDownload

  rescue_from ArgumentError, :with => :datetime_format_error

  def index
    @user = User.find_by_slug(params[:user_id])

    if current_user.role == 'power-user' || current_user == @user
      @hours_entries = @user.hours.by_starting_time.page(params[:hours_pages]).per(20)

      respond_to do |format|
        format.html { @hours_entries }
        format.csv do
          send_csv(
            name: @user.name,
            hours_entries: @user.hours.by_starting_time)
        end
      end
    else
      redirect_to root_path, notice: t("restricted")
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

  def parsed_time(datetime)
    Time.strptime(datetime, I18n.t('time.formats.default'))
  end

  def datetime_format_error
    redirect_to :back, notice: I18n.t('invalid_datetime')
  end
end
