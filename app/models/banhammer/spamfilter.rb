module Banhammer
  class SpamFilter < ApplicationRecord
    validates presence: :type
  end
end
