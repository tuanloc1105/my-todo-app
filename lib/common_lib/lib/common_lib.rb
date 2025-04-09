# frozen_string_literal: true

require_relative "common_lib/version"
require_relative 'common_lib/uuidv7'
require_relative 'common_lib/request_logger'
require_relative 'common_lib/trace_id_middleware'

module CommonLib
  class Error < StandardError; end
  # Your code goes here...
end
