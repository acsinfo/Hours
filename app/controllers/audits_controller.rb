require "audit_history"

class AuditsController < ApplicationController
  def index
    if current_user.role == 'power-user' || (params.key?(:hour_id) && hour.user == current_user)
      @history = AuditHistory.new(audit_log)
    else
      redirect_to root_path, notice: t("restricted")
    end
  end

  private

  def audit_log
    case
    when params.key?(:hour_id)
      return hour_log
    when params.key?(:project_id)
      return project_log
    end
  end

  def hour
    Hour.find(params[:hour_id])
  end

  def hour_log
    hour.audits
  end

  def project_log
    Project.find_by_slug(params[:project_id]).audits
  end
end
