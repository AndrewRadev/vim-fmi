require 'rails_helper'

describe User do
  describe "sorting" do
    it "sorts by creation time, older users first" do
      second = create :user, created_at: 2.days.ago
      third  = create :user, created_at: 1.day.ago
      first  = create :user, created_at: 3.days.ago

      expect(User.sorted).to eq [first, second, third]
    end

    it "puts users with photos before users without photos" do
      second = create :user
      first  = create :user, :with_photo

      expect(User.sorted).to eq [first, second]
    end
  end

  describe "pagination" do
    before do
      expect(User).to receive(:paginate).with(page: 'foo', per_page: 20)
    end

    it "delegates to paginate with 20 users per page" do
      User.at_page('foo')
    end

    it "works with scopes" do
      User.students.at_page('foo')
    end
  end
end
