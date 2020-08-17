# for testing/QA of email routines
ActionMailer::Base.register_interceptor(SandboxEmailInterceptor)
