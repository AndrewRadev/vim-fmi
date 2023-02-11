class RegistrationMailer < ActionMailer::Base
  default({
    from: "#{Rails.application.config.short_course_name} <#{Rails.application.config.course_email}>",
    reply_to: Rails.application.config.course_email,
  })

  def confirmation(sign_up)
    @activation_url = activation_url(sign_up.token, only_path: false)

    mail({
      to: sign_up.email,
      subject: 'Потвърждение на регистрация',
    })
  end

  def activation(user)
    @email = user.email

    mail({
      to: user.email,
      subject: 'Успешна регистрация'
    })
  end
end
