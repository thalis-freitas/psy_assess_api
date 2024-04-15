require 'rails_helper'

RSpec.describe EvaluationMailer, type: :mailer do
  context 'send_instrument' do
    it 'renders the headers' do
      evaluation = create(:evaluation, evaluated: create(:user),
                                       instrument: create(:instrument))

      mail = EvaluationMailer.send_instrument(evaluation)

      expect(mail.subject).to eq(I18n.t('links.instrument_evaluation_link'))
      expect(mail.to).to eq([evaluation.evaluated.email])
      expect(mail.from).to eq(['psy@assess.com'])
    end

    it 'renders the body' do
      evaluation = create(:evaluation, evaluated: create(:user),
                                       instrument: create(:instrument))

      mail = EvaluationMailer.send_instrument(evaluation)

      expect(mail.body.encoded).to include(evaluation.token)
    end
  end
end
