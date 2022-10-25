if defined?(EmailValidator)
    # or just a few options
    EmailValidator.default_options.merge!({ domain: 'mydomain.com' })
  end