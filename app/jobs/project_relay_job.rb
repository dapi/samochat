# frozen_string_literal: true

# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# Пушает в канал изменения проекта
#
class ProjectRelayJob < ApplicationJob
  queue_as :default

  def perform(project, previous_changes = {})
    ProjectsChannel.broadcast_to(
      project.id,
      project: project.as_json,
      previous_changes:,
      group_setup_page: ProjectsController.render(partial: 'projects/group/setup', locals: { project: })
    )
  end
end
