# frozen_string_literal: true

require 'aws-sdk-s3'

Aws.config.update(
  {
    region: ENV.fetch('S3_REGION'),
    credentials: Aws::Credentials.new(
      ENV.fetch('S3_KEY_ID'),
      ENV.fetch('S3_SECRET_KEY')
    )
  }
)

S3_BUCKET = Aws::S3::Resource.new.bucket(ENV.fetch('S3_BUCKET'))
