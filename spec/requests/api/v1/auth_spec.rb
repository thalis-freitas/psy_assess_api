require 'rails_helper'

describe Api::V1::AuthController, type: :request do
  describe 'POST /api/v1/login' do
    context 'with valid email and password' do
      before do
        @user = create(:user, :psychologist)
        post '/api/v1/login',
             params: { user: { email: @user.email, password: @user.password } }
      end

      it { expect(response).to have_http_status(:ok) }

      it 'returns an authentication token' do
        expect(json).to have_key(:token)
      end

      it 'returns user with expected attributes' do
        expect(json[:user].keys).to include(*%i[id name email role])

        expect(json[:user].keys).not_to include(*%i[password])
      end
    end

    context 'with invalid email or password' do
      before do
        post '/api/v1/login',
             params: { user: { email: 'user', password: 'wrong_password' } }
      end

      it { expect(response).to have_http_status(:unprocessable_entity) }

      it 'returns an authentication error' do
        expect(json[:errors]).to include('Usuário ou senha inválidos')
      end
    end
  end
end
