# app/models/static_page.rb
class StaticPage < ApplicationRecord
    validates :title, presence: true, uniqueness: true
    validates :content, presence: true
  
    def self.find_by_title(title)
      find_by(title: title)
    end
  
    def self.ransackable_attributes(auth_object = nil)
        ["content", "created_at", "id", "title", "updated_at"]
      end
  end
  