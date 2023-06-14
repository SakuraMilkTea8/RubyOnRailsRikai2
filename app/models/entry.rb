class Entry < ApplicationRecord
    belongs_to :blog
    has_many :comments, dependent: :destroy
end
