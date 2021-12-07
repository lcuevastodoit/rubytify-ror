# frozen_string_literal: true

# spec/controllers/api/v1/artists_controller_spec.rb
# please us "bundle exec rspec -f d" to run this spec
# - /api/v1/artists
require 'rails_helper'

RSpec.describe Api::V1::ArtistsController do
  describe 'testing api/v1/artists', type: :request do
    before { get 'http://localhost/api/v1/artists' }
    it 'returns http success' do
      expect(response).to have_http_status(:success)
    end
    it 'JSON body response contains data attribute in root' do
      json_response = JSON.parse(response.body)
      expect(json_response.keys).to eq(['data'])
    end
  end
end
