class Account < ApplicationRecord
  attribute :balance, :decimal
  attribute :access_token, :string
end
