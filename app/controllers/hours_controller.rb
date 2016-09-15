class HoursController < EntriesController
  def create
    @entry = Hour.new(entry_params)
    @entry.user = current_user

    if @entry.save
      redirect_to root_path, notice: t("entry_created.hours")
    else
      redirect_to root_path, notice: @entry.errors.full_messages.join(". ")
    end
  end

  def update
    if resource.update_attributes(entry_params)
      redirect_to user_entries_path(current_user), notice: t("entry_saved")
    else
      redirect_to edit_hour_path(resource), notice: t("entry_failed")
    end
  end

  def edit
    super
    resource
  end

  private

  def resource
    @hours_entry ||= current_user.hours.find(params[:id])
  end

  def entry_params
    params.require(:hour).
      permit(:project_id, :category_id, :value, :description, :starting_time, :ending_time).
      merge(starting_time: parsed_time(params[:hour][:starting_time])).
      merge(ending_time: parsed_time(params[:hour][:ending_time]))
  end
end
