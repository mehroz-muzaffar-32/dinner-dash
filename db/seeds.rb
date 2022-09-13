# frozen_string_literal: true

Rails.logger = Logger.new(STDOUT)

Dir[Rails.root.join('db/seeds/*.rb')].sort.each do |file|
  Rails.logger.info("Processing #{file.split('/').last}")
  require file
end

