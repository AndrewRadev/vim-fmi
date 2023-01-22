require 'rails_helper'

describe StudentSignUp do
  it "validates faculty number isn't taken by an existing user" do
    create :user, faculty_number: 'taken'
    sign_up = StudentSignUp.new faculty_number: 'taken'

    expect(sign_up).not_to be_valid
    expect(sign_up.errors).to include :faculty_number
  end

  describe ".with_token" do
    it "looks up a signup by token" do
      sign_up = create :student_sign_up, token: 'token'
      expect(StudentSignUp.with_token('token')).to eq sign_up
    end

    it "never finds empty tokens" do
      create :student_sign_up, token: nil
      create :student_sign_up, token: ''

      expect(StudentSignUp.with_token(nil)).to be_nil
      expect(StudentSignUp.with_token('')).to be_nil
    end
  end

  describe "assigning to an email address" do
    let(:sign_up) { create :student_sign_up }

    it "updates the email to the assigned one" do
      sign_up.assign_to('peter@example.org')
      expect(sign_up.email).to eq 'peter@example.org'
    end

    it "generates a random token" do
      sign_up.assign_to('peter@example.org')
      expect(sign_up.token).to match /^[a-z0-9]{40}$/
    end
  end

  describe "generating fake faculty numbers" do
    it "returns 'x00001' if no fakes in the database" do
      expect(StudentSignUp.next_fake_faculty_number).to eq 'x00001'
    end

    it "increments the largest fake faculty number if one exists" do
      create :user, faculty_number: 'x00041'
      create :user, faculty_number: 'x00004'

      expect(StudentSignUp.next_fake_faculty_number).to eq 'x00042'
    end

    it "checks the faculty numbers in sign-ups" do
      create :user,    faculty_number: 'x00001'
      create :student_sign_up, faculty_number: 'x00002'

      expect(StudentSignUp.next_fake_faculty_number).to eq 'x00003'
    end
  end
end
