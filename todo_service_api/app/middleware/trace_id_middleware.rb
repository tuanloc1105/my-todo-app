require 'securerandom'

class TraceIdMiddleware
  def initialize(app)
    @app = app
  end

  def call(env)
    trace_id = SecureRandom.uuid
    RequestStore.store[:trace_id] = trace_id

    # Rails.logger.info "🔎 TraceID: #{trace_id}"

    status, headers, response = @app.call(env)

    # Optional: gắn trace_id vào response header cho client biết
    headers['X-Trace-Id'] = trace_id

    [status, headers, response]
  ensure
    RequestStore.clear!
  end
end
