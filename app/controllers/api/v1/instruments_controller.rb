class Api::V1::InstrumentsController < Api::V1::ApiController
  before_action :authorize
  before_action :set_instrument, only: :show

  def index
    @instruments = Instrument.select(:id, :name, :description)
    render json: @instruments
  end

  def show
    render json: @instrument, include: [questions: { include: :options }]
  end

  def create
    @instrument = Instrument.new(instrument_params)
    if @instrument.save
      render json: @instrument, include: [questions: { include: :options }],
             status: :created
    else
      render json: @instrument.errors, status: :unprocessable_entity
    end
  end

  private

  def instrument_params
    params.require(:instrument)
          .permit(:name, :description, questions_attributes: [
                    :id, :text, :_destroy, { options_attributes: %i[
                      id
                      text
                      score_value
                      _destroy
                    ] }
                  ])
  end

  def set_instrument
    @instrument = Instrument.includes(questions: :options).find(params[:id])
  end
end
