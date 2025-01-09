module TurboStreamActionsHelper
  def close_modal
    turbo_stream_action_tag :close_modal
  end

  def open_modal(modal_id)
    turbo_stream_action_tag :open_modal, modal_id: modal_id
  end

  def upsert_modal(modal_id, partial: nil, locals: {})
    html_content = ApplicationController.renderer.render(partial: partial, locals: locals)
    turbo_stream_action_tag :upsert_modal, modal_id: modal_id, html: html_content
  end

  def refresh_textarea(selector)
    turbo_stream_action_tag :refresh_textarea, selector: selector
  end
end

Turbo::Streams::TagBuilder.prepend(TurboStreamActionsHelper)
