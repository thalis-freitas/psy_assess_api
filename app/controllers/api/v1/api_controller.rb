class Api::V1::ApiController < ApplicationController
  include AuthService

  rescue_from ActiveRecord::ActiveRecordError do |_exception|
    render json: { error: I18n.t('errors.internal_server_error') },
           status: :internal_server_error
  end
end
