# frozen_string_literal: true

class Api::DirectUploadController < ApplicationController
  def create
    response = DirectUpload.call(blob_params, url_params)
    render json: response
  end

  private

  def blob_params
    params.require(:file).permit(:filename, :byte_size, :checksum, :content_type, metadata: {})
  end

  def url_params
    params.fetch(:url, {}).permit(:folder, :expiration_time)
  end
end
