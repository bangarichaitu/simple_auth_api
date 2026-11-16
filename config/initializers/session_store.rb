# Be sure to restart your server when you modify this file.

dev_or_test_env = Rails.env.development? || Rails.env.test?
Rails.application.config.session_store :cookie_store, key: '_simple_auth_api_session_new', same_site: dev_or_test_env ? :lax : :none, secure: !dev_or_test_env
