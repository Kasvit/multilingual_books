# frozen_string_literal: true

module ApplicationHelper
  def current_namespace?(namespace)
    request.path.match?(%r{/#{namespace}})
  end

  def open_modal(title, content, footer = nil)
    turbo_stream.replace "modal", partial: "shared/modal", locals: {
      title: title,
      content: content,
      footer: footer
    }
  end

  def close_modal
    turbo_stream.replace "modal", "<div id='modal' class='modal' style='display:none;'></div>"
  end
end
