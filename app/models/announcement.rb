# == Schema Information
#
# Table name: announcements
#
#  id         :bigint           not null, primary key
#  body       :text
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Announcement < ApplicationRecord
  self.per_page = 10

  validates :title, presence: true
  validates :body,  presence: true

  class << self
    def reverse_chronological
      order('created_at DESC')
    end

    def page(number)
      reverse_chronological.paginate(page: number, per_page: per_page)
    end

    def latest(number)
      reverse_chronological.limit(number)
    end
  end
end
