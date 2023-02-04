# == Schema Information
#
# Table name: vouchers
#
#  id         :bigint           not null, primary key
#  claimed_at :datetime
#  code       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint
#
# Indexes
#
#  index_vouchers_on_user_id  (user_id)
#
class Voucher < ApplicationRecord
  belongs_to :user, optional: true

  def claimed?
    user_id?
  end

  class << self
    def create_codes(codes)
      codes.split(/\s+/).each do |code|
        create!(code: code)
      end
    end

    def claim(user, code)
      voucher = find_by(code: code)
      return false if voucher.nil? or voucher.claimed?

      voucher.update!(user_id: user.id, claimed_at: Time.current)
    end
  end
end
