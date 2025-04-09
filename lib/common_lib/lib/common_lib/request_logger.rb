module CommonLib
  class RequestLogger
    def initialize(app)
      @app = app
    end

    def call(env)
      req = Rack::Request.new(env)

      # Đọc body 1 lần vì rack input là IO stream
      req_body = req.body.read.force_encoding('UTF-8').scrub
      req.body.rewind # Reset stream sau khi đọc xong

      trace_id = RequestStore.store[:trace_id]

      Rails.logger.info "➡️ [#{req.request_method}] [TraceID=#{trace_id}] #{req.path}"
      Rails.logger.info "🔸 Params: #{req.params.inspect}" unless req.params.empty?
      Rails.logger.info "📝 Body: #{req_body}" unless req_body.empty?

      status, headers, response = @app.call(env)

      # Đọc response body
      res_body = ""
      if response.respond_to?(:each)
        response.each { |part| res_body << part.to_s }
      else
        res_body = response.to_s
      end

      Rails.logger.info "⬅️ Response [#{status}] [TraceID=#{trace_id}]"
      Rails.logger.info "📦 Body: #{res_body}" unless res_body.empty?

      [status, headers, response]
    end
  end
end
