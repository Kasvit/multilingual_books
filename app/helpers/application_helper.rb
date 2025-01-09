# frozen_string_literal: true

module ApplicationHelper

  def current_namespace?(namespace)
    request.path.match?(%r{/#{namespace}})
  end
end
