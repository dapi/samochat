# frozen_string_literal: true

# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# Управление опреаторскими проектами
# rubocop:disable Metrics/ClassLength
class ProjectsController < ApplicationController
  before_action :require_login
  before_action { @back_url = root_url }

  layout 'simple'

  helper_method :project

  def show
    @header_title = project.name
    if project.setup_errors.empty?
      render locals: { project: }, layout: 'project'
    else
      redirect_to next_step_redirect_url(project)
    end
  end

  def new
    project = find_new_project
    if project.present?
      redirect_to next_step_redirect_url(project)
    else
      project = Project.new(permitted_params)

      render next_step_view(project), locals: { project: }
    end
  end

  def edit
    render :setup_bot_token, locals: { project: }
  end

  def create
    project = find_new_project
    if project.present?
      view = next_step_view project
      flash.now[:alert] = 'Еще не все закончено. Смотрите чек-лист' if view == 'projects/group/show'
      render view, locals: { project: }, status: :unprocessable_entity
    else
      project = current_user.projects.build permitted_params.merge(owner: current_user)
      project.assign_attributes permitted_params
      project.save!
      redirect_to next_step_redirect_url(project)
    end
  rescue ActiveRecord::RecordInvalid => e
    view = next_step_view(e.record)
    flash.now[:alert] = 'Еще не все закончено. Смотрите чек-лист' if view == 'projects/group/show'
    render view, locals: { project: e.record }, status: :unprocessable_entity
  end

  def reset_bot
    raise :not_authoried unless current_user.super_admin?

    project.custom_bot.delete_webhook if project.bot_token.present?
    project.update!(bot_id: nil, bot_username: nil, bot_token: nil)
    flash[:alert] = 'Сбросили бота'
    redirect_back fallback_location: projects_path
  end

  def skip_widget
    project = current_user.projects.find params[:id]
    project.update! skip_widget_at: Time.zone.now
    redirect_to next_step_redirect_url(project)
  end

  def update
    project = current_user.projects.find params[:id]
    project.update! permitted_params
    redirect_to project_path(project)
  rescue ActiveRecord::RecordInvalid => e
    render :setup_bot_token, locals: {
      project: e.record
    }, status: :unprocessable_entity
  end

  def destroy
    raise :not_authoried unless current_user.super_admin?

    project.destroy!
    flash[:alert] = 'Проект удалили'
    redirect_back fallback_location: projects_path
  end

  private

  def find_new_project
    current_user
      .projects
      .where(host_confirmed_at: nil)
      .where.not(telegram_group_id: nil)
      .find_by(bot_token: nil)
  end

  def next_step_redirect_url(project)
    if !project.bot_installed?
      project_group_path(project)
    elsif !project.widget_installed? && !project.skip_widget_at?
      project_widget_path(project)
    else
      project_path(project)
    end
  end

  def next_step_view(project)
    if project.tariff.present?
      @back_url = new_project_path
      project.tariff.custom_bot_allowed? ? :setup_bot_token : 'projects/group/show'
    else
      @back_url = logged_in? ? projects_path : root_url
      :select_tariff
    end
  end

  def project
    @project ||= current_user.projects.find params[:id]
  end

  def permitted_params
    params
      .fetch(:project, {})
      .permit(:name, :custom_username, :url, :welcome_message, :telegram_group_id, :topic_title_template, :thread_on_start, :bot_token, :tariff_id)
  end
end
# rubocop:enable Metrics/ClassLength
