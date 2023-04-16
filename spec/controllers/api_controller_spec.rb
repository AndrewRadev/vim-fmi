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
    it "fetches an incomplete task with no filetype by its solution token" do
      solution = create :solution
      task = solution.task

      get :task, params: { token: solution.token }
      expect(json_response).to eq({
        input: task.input,
        output: task.output,
        version: '0.1.16',
        file_extension: nil,
      })
    end

    it "fetches an incomplete task with a filetype" do
      task = create :task, file_extension: 'rb'
      solution = create :solution, task: task

      get :task, params: { token: solution.token }
      expect(json_response.fetch(:file_extension)).to eq 'rb'
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

  describe "GET vimrc.json" do
    it "fetches a user's vimrc" do
      user_token = create :user_token, :activated
      user = user_token.user
      vimrc = create :vimrc, user: user
      revision = create :vimrc_revision, vimrc: vimrc, body: '" Custom vimrc'

      get :vimrc, params: { token: user_token.body }

      expect(response.status).to eq 200
      expect(json_response).to eq({ body: '" Custom vimrc', revision_id: revision.id })
    end

    it "returns nil for a missing vimrc" do
      user_token = create :user_token, :activated
      user = user_token.user

      get :vimrc, params: { token: user_token.body }

      expect(response.status).to eq 200
      expect(json_response).to eq({ body: nil, revision_id: nil })
    end

    it "returns an error for a missing or inactive token" do
      inactive_user_token = create :user_token

      get :vimrc, params: { token: inactive_user_token.body }
      expect(response.status).to eq 400

      get :vimrc, params: { token: 'nonexistent' }
      expect(response.status).to eq 400
    end
  end

  describe "PUT solution.json" do
    it "updates an incomplete solution by its token" do
      solution = create :solution
      expect(solution).not_to be_completed_at

      params = { challenge_id: solution.token, entry: Base64.encode64('solution'), user_token: 'anything' }
      put :solution, params: params
      solution.reload

      expect(response.status).to eq 200
      expect(solution).to be_completed_at
      expect(solution.vimrc_revision_id).to be_nil
    end

    it "sets a solution's vimrc_revision" do
      revision = create :vimrc_revision
      solution = create :solution
      expect(solution).not_to be_completed_at

      params = {
        challenge_id:      solution.token,
        entry:             Base64.encode64('solution'),
        user_token:        'anything',
        vimrc_revision_id: revision.id.to_s,
      }
      put :solution, params: params
      solution.reload

      expect(response.status).to eq 200
      expect(solution).to be_completed_at
      expect(solution.vimrc_revision).to eq revision
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
