class Mailer < ActionMailer::Base
  default from: "classificados@fe.up.pt"

  def evaluate_ad(ad)
    @user = ad.partner
    @ad = ad
    @url  = show_rate_owner_ad_path(@ad.id)
    mail(:to => @user.email, :subject => I18n.t('site_name') + ": " + I18n.t('ad.subject_email_evaluate_ad'))
  end
end
