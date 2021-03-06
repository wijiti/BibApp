class Notifier < ActionMailer::Base

  def import_review_notification(user, import_id)
    with_setup_and_mailing(user) do
      @subject = "BibApp - Batch import ready for review"
      @user = user
      @import_id = import_id
    end
  end

  def batch_import_persons_notification(user_id, results, filename = "Unknown")
    @user = User.find(user_id)
    with_setup_and_mailing(@user) do
      @subject = "BibApp Synapse - batch upload of persons has completed"
      @email = @user.email
      @results = results
      @filename = filename
    end
  end

  def error_summary(exception, clean_backtrace, params, session)
    with_setup_and_mailing do
      @recipients = $SYSADMIN_EMAIL
      @from = $SYSADMIN_EMAIL
      @subject = "BibApp - Exception summary: #{Time.now.strftime('%B %d, %Y')}"
      @exception = exception
      @clean_backtrace = clean_backtrace
      @params = params
      @session = session
    end
  end

  protected

  #do setup and emailing while yielding to a block in between to do any additional
  #actions, set up instance variables, etc.
  def with_setup_and_mailing(user = nil)
    @recipients = user.email if user
    @from = "BibApp <no-reply@bibapp.org>"
    yield
    mail(:to => @recipients, :subject => @subject, :from => @from)
  end

end
