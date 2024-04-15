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
      get '/api/v1/evaluated/999999', headers: psychologist_token

      expect(response).to have_http_status(:not_found)
    end
  end

  context 'POST /api/v1/evaluated' do
    it 'creates a new evaluated user' do
      user_attributes = attributes_for(:user)

      post '/api/v1/evaluated', params: { evaluated: user_attributes },
                                headers: psychologist_token

      expect(response).to have_http_status(:created)
      expect(json[:cpf]).to eq(user_attributes[:cpf])
      expect(json[:email]).to eq(user_attributes[:email])

      expect(json.keys)
        .to include(*%i[id name cpf email birth_date])
    end

    it 'does not allow creating a psychologist' do
      psychologist_attributes = attributes_for(:user, :psychologist)

      post '/api/v1/evaluated', params: { evaluated: psychologist_attributes },
                                headers: psychologist_token

      created_user = User.find_by(email: psychologist_attributes[:email])
      expect(created_user.role).not_to eq('psychologist')
    end
  end

  context 'PUT /api/v1/evaluated/:id' do
    it 'updates an evaluated user' do
      evaluated = create(:user)
      updated_name = 'Updated Name'

      put "/api/v1/evaluated/#{evaluated.id}",
          params: { evaluated: { name: updated_name } },
          headers: psychologist_token

      expect(response).to have_http_status(:success)
      expect(json[:name]).to eq(updated_name)
      expect(json[:email]).to eq(evaluated.email)
      expect(json[:cpf]).to eq(evaluated.cpf)

      expect(json.keys)
        .to include(*%i[id name cpf email birth_date])
    end

    it 'returns not found if user is a psychologist' do
      psychologist = create(:user, :psychologist)
      create(:user)

      put "/api/v1/evaluated/#{psychologist.id}",
          params: { evaluated: { name: 'Updated Name' } },
          headers: psychologist_token

      expect(response).to have_http_status(:not_found)
    end

    it 'returns not found if user is not found' do
      put '/api/v1/evaluated/999999',
          params: { evaluated: { name: 'Updated Name' } },
          headers: psychologist_token

      expect(response).to have_http_status(:not_found)
    end
  end

  context 'GET /api/v1/evaluated/:id/instruments' do
    it 'returns all instruments applied to the evaluated' do
      evaluated = create(:user)
      instruments = create_list(:instrument, 3)

      instruments.each do |instrument|
        create(:evaluation, evaluated:, instrument:)
      end

      get "/api/v1/evaluated/#{evaluated.id}/instruments",
          headers: psychologist_token

      expect(response).to have_http_status(:success)
      expect(json.length).to eq(3)
      expect(json[0].keys).to include(*%i[instrument_id status name])
    end

    it 'returns no instruments if evaluated has none applied' do
      evaluated = create(:user)

      get "/api/v1/evaluated/#{evaluated.id}/instruments",
          headers: psychologist_token

      expect(response).to have_http_status(:success)
      expect(json).to be_empty
    end

    it 'returns a not found status if the evaluated does not exist' do
      get '/api/v1/evaluated/999/instruments', headers: psychologist_token

      expect(response).to have_http_status(:not_found)
    end
  end
end
