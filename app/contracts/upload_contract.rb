class UploadContract < Dry::Validation::Contract
  params do
    required(:byte_size).filled(:integer)
    required(:checksum).filled(:string)
    required(:content_type).filled(included_in?: ['image/png', 'image/jpg', 'image/jpeg'])
    required(:filename).filled(:string)
    optional(:metadata).hash
    optional(:folder).filled(:string)
    optional(:expiration_time).filled(:integer)
  end
end
