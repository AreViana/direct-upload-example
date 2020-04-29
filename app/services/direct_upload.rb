# frozen_string_literal: true

# This service contains different methods to make an AWS request creating a signed URL
class DirectUpload < BaseService
  def initialize(blob_args, **options)
    @blob_args = blob_args.to_h.deep_symbolize_keys
    @expiration_time = options[:expiration_time] || 10.minutes
    @folder = options[:folder]
  end

  def call
    blob = create_blob

    response = signed_url(blob)
    # response = post_request_for_presigned_url(blob.key)
    # response = put_request_for_presigned_url(blob.key)
    response[:blob_signed_id] = blob.signed_id
    response
  end

  private

  attr_reader :blob_args, :expiration_time, :folder

  def create_blob
    blob = ActiveStorage::Blob.create_before_direct_upload!(blob_args)

    blob.update_attribute(:key, "#{folder}/#{blob.key}") if folder.present?

    blob
  end

  #-------Using Active Storage------
  # AWS PUT request with headers
  def signed_url(blob)
    response_signature(
      blob.service_url_for_direct_upload,
      headers: blob.service_headers_for_direct_upload
    )
  end

  #-------Using SDK-----------------
  # AWS POST request with XML Response
  def post_request_for_presigned_url(key)
    presigned_url = S3_BUCKET.presigned_post(
      key: key,
      signature_expiration: (Time.now.utc + expiration_time),
      success_action_status: '201',
      metadata: {
        'original-filename' => '${filename}'
      }
    )

    response_signature(
      presigned_url.url,
      fields: presigned_url.fields
    )
  end

  # AWS PUT request without headers
  def put_request_for_presigned_url(key)
    object = S3_BUCKET.object(key)
    presigned_url = object.presigned_url(
      :put, acl: 'public-read',
      expires_in: expiration_time.to_i
    )
    uri = URI.parse(presigned_url)

    response_signature(
      uri,
      public_url: object.public_url
    )
  end

  def response_signature(url, **params)
    {
      direct_upload: {
        url: url
      }.merge(params)
    }
  end
end
