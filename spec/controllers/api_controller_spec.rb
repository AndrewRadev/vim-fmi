require 'rails_helper'

describe ApiController do
  def json_response
    JSON.parse(response.body).deep_symbolize_keys
  end

  describe "GET user_setup.json" do
    it "activates a token and renders its user data" do
      user_token = create :user_token
      user = user_token.user

      get :user_setup, params: { token: user_token.body }

      expect(json_response).to eq({
        id: user.id,
        faculty_number: user.faculty_number,
        token: user_token.body
      })
    end

    it "returns an error for a missing or activated token" do
      user_token = create :user_token, :activated
      user = user_token.user

      get :user_setup, params: { token: user_token.body }

      expect(response.status).to eq 400
      expect(json_response).to have_key(:message)
    end
  end

  describe "GET task.json" do
    it "fetches an incomplete task by its solution token" do
      solution = create :solution
      task = solution.task

      get :task, params: { token: solution.token }

      expect(json_response).to eq({
        input: task.input,
        output: task.output,
        version: '0.2.0',
      })
    end

    it "returns an error for a missing or completed solution" do
      solution = create :solution, :completed
      task = solution.task

      get :task, params: { token: solution.token }

      expect(response.status).to eq 400
      expect(json_response).to have_key(:message)

      get :task, params: { token: 'nonexistent' }

      expect(response.status).to eq 400
      expect(json_response).to have_key(:message)
    end

    it "returns an error for a closed task" do
      task = create :task, closes_at: 1.day.ago
      solution = create :solution, task: task

      get :task, params: { token: solution.token }

      expect(response.status).to eq 400
      expect(json_response).to have_key(:message)
    end
  end

  describe "PUT solution.json" do
    it "updates an incomplete solution by its token" do
      solution = create :solution

      params = { challenge_id: solution.token, entry: Base64.encode64('solution'), user_token: 'anything' }
      put :solution, params: params

      expect(response.status).to eq 200
    end

    it "returns an error for a missing or completed solution" do
      solution = create :solution, :completed

      put :solution, params: { challenge_id: solution.token, entry: 'solution' }

      expect(response.status).to eq 400
      expect(json_response).to have_key(:message)

      get :solution, params: { challenge_id: 'nonexistent', entry: 'solution' }

      expect(response.status).to eq 400
      expect(json_response).to have_key(:message)
    end
  end
end
