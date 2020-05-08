class UserContract < Dry::Validation::Contract
  EMAIL_REGREX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i.freeze

  params do
    required(:full_name).filled(:string)
    required(:email).filled(:string)
    required(:email).value(format?: EMAIL_REGREX)
    optional(:avatar).filled(:string)
    optional(:avatar).value(size?: 122)
    optional(:linkedin).filled(:string)
  end
end
