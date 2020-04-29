# frozen_string_literal: true

module ExceptionHandler
  extend ActiveSupport::Concern
  included do
    rescue_from ActiveRecord::RecordInvalid, with: :unprocessable_record
    rescue_from ActionController::BadRequest, with: :bad_requests
    rescue_from ActionController::ParameterMissing, with: :param_missing
  end

  private

  def unprocessable_record(exception)
    render_error(
      'Unprocessable entity',
      'Validation failed',
      422,
      exception.record.errors.messages.as_json
    )
  end

  def param_missing(exception)
    render_error('Parameter Missing', exception.to_s, :bad_request)
  end

  def bad_requests(exception)
    render_error('Bad request', exception.to_s, :bad_request)
  end

  def render_error(title = '', message = '', status = 500, errors = {})
    render json: {
      error: {
        title: title,
        message: message,
        details: errors
      }
    }, status: status
  end
end
