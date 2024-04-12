module AuthenticationHelper
  def psychologist_token
    psychologist = create(:user, :psychologist)
    token = encode_token(user_id: psychologist.id)

    { 'Authorization' => "Bearer #{token}" }
  end
end
