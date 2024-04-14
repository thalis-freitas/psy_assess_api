class EvaluationMailer < ApplicationMailer
  default from: 'psy@assess.com'

  def send_instrument(evaluation)
    @evaluation = evaluation
    mail(to: @evaluation.evaluated.email,
         subject: I18n.t('links.instrument_evaluation_link'))
  end
end
