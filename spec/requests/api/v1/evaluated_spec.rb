require 'rails_helper'

describe 'Evaluated API', type: :request do
  context 'GET /api/v1/evaluated' do
    it 'returns a list of evaluated users with their attributes' do
      create_list(:user, 5)

      get '/api/v1/evaluated', headers: psychologist_token

      expect(response).to have_http_status(:success)
      expect(json[:evaluated].count).to eql(5)

      json[:evaluated].each do |load|
        expect(load.keys).to include(*%i[name cpf email birth_date])
      end
    end
  end
end
