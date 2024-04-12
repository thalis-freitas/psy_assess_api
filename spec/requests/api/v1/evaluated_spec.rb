require 'rails_helper'

describe 'Api::V1::EvaluatedController', type: :request do
  context 'GET /api/v1/evaluated' do
    it 'returns a list of evaluated users with their attributes' do
      create_list(:user, 5)

      get '/api/v1/evaluated', headers: psychologist_token

      expect(response).to have_http_status(:success)
      expect(json[:evaluated].count).to eq(5)

      json[:evaluated].each do |e|
        expect(e.keys).to include(*%i[name cpf email birth_date])
      end
    end

    it 'handles internal server error' do
      allow(User).to receive(:where).and_raise(ActiveRecord::QueryCanceled)
      create_list(:user, 5)

      get '/api/v1/evaluated', headers: psychologist_token

      expect(response).to have_http_status(:internal_server_error)
      expect(json).to include(error: I18n.t('errors.internal_server_error'))
    end
  end

  context 'GET /api/v1/evaluated/:id' do
    it 'returns the correct attributes of a specific evaluated' do
      user = create(:user)

      get "/api/v1/evaluated/#{user.id}", headers: psychologist_token

      expect(response).to have_http_status(:success)
      expect(json[:evaluated][:id]).to eq(user.id)
      expect(json[:evaluated][:email]).to eq(user.email)

      expect(json[:evaluated].keys)
        .to include(*%i[id name cpf email birth_date])
    end

    it 'returns not found if user is a psychologist' do
      psychologist = create(:user, :psychologist)

      get "/api/v1/evaluated/#{psychologist.id}", headers: psychologist_token

      expect(response).to have_http_status(:not_found)
    end

    it 'returns not found if user is not found' do
      get "/api/v1/evaluated/999999", headers: psychologist_token

      expect(response).to have_http_status(:not_found)
    end
  end
end
