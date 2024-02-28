class User < ApplicationRecord
    validates :username, presence: true, allow_blank: false
    validates :bio, presence: true, allow_blank: false

end
