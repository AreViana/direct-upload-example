# frozen_string_literal: true

module ExceptionHandler
  extend ActiveSupport::Concern
  included do
    rescue_from CustomError, with: :custom_error
    rescue_from ArgumentError, with: :argument_error
    rescue_from ActiveRecord::RecordInvalid, with: :unprocessable_record
    rescue_from ActionController::BadRequest, with: :bad_requests
    rescue_from ActionController::ParameterMissing, with: :param_missing
  end

  private

  def custom_error(exception = {})
    render_error(exception.to_h)
  end

  def argument_error(exception)
    render_error(title: 'Argument Error', message: exception.to_s)
  end

  def unprocessable_record(exception)
    render_error(
      details: exception.record.errors.messages.to_h,
      title: 'Unprocessable entity',
      message: 'Validation failed',
      status: 422
    )
  end

  def param_missing(exception)
    render_error(title: 'Parameter Missing', message: exception.to_s)
  end

  def bad_requests(exception)
    render_error(title: 'Bad request', message: exception.to_s)
  end

  def render_error(title:, message:, status: :bad_request, details: {})
    render json: {
      error: {
        title: title,
        message: message,
        details: details
      }
    }, status: status
  end
end
