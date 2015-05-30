module FancyAppMailer
  class ApplicationMailer < ActionMailer::Base
    default from: Rails.configuration.sender_email
  end
end
