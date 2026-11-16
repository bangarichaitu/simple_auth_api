Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    # origins 'http://localhost:5173'
    origins 'https://9eef-2409-4091-8018-f001-598e-8b00-147-66fd.ngrok-free.app'

    resource '*',
      headers: :any,
      methods: %i[get post put patch delete options head]
  end
end

