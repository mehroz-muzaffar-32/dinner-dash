# frozen_string_literal: true

Rails.logger = Logger.new($stdout)

Dir[Rails.root.join('db/seeds/*.rb')].sort.each do |file|
  Rails.logger.info("Processing #{file.split('/').last}")
  require file
end
