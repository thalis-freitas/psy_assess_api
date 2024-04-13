class Api::V1::ApiController < ApplicationController
  include AuthService

  rescue_from ActiveRecord::ActiveRecordError do |_exception|
    render json: { error: I18n.t('errors.internal_server_error') },
           status: :internal_server_error
  end

  rescue_from ActiveRecord::RecordNotFound do |msg|
    render json: { message: msg }, status: :not_found
  end
end
