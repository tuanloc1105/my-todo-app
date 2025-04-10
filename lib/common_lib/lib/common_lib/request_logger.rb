module CommonLib
  class RequestLogger
    def initialize(app)
      @app = app
    end

    def call(env)
      req = Rack::Request.new(env)

      req_body = req.body.read.force_encoding('UTF-8').scrub
      req.body.rewind

      req_body = req_body.gsub("\n", "").gsub("    ", "")

      trace_id = RequestStore.store[:trace_id]

      Rails.logger.info "➡️ [#{req.request_method}] [TraceID=#{trace_id}] #{req.path}"
      Rails.logger.info "🔸 Params: #{req.params.inspect}" unless req.params.empty?
      Rails.logger.info "📝 Body: #{req_body}" unless req_body.empty?

      CommonLib::MyLogger.info("asdasd")

      status, headers, response = @app.call(env)

      res_body = ""
      if response.respond_to?(:each)
        response.each { |part| res_body << part.to_s }
      else
        res_body = response.to_s
      end

      unless res_body.empty?
        res_body = res_body.gsub("\n", "").gsub("    ", "")
      end

      Rails.logger.info "⬅️ Response [#{status}] [TraceID=#{trace_id}]"
      Rails.logger.info "📦 Body: #{res_body}" unless res_body.empty?

      [status, headers, response]
    end
  end
end
