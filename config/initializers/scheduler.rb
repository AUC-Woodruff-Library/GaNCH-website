require 'rufus-scheduler'
require 'rake'

scheduler = Rufus::Scheduler.singleton

# avoid creating scheduler in console and rake tasks
return if defined?(Rails::Console) || Rails.env.test? || File.split($0).last == 'rake'

# test scheduler is up and running
# scheduler.every '1m' do

#   Rails.logger.info "hello, it's #{Time.now}"
#   Rails.logger.flush
# end

# use only if you need to run Rake without console access
# scheduler.at '2020/08/16 19:30:00' do
#   Rails.logger.info("Running db:migrate")
#   Ganch::Application.load_tasks
#   begin
#     Rake::Task['db:migrate'].invoke
#     Rails.logger.info("db:migrate complete")
#   rescue
#     Rails.logger.error("db:migrate was unable to run successfully!!")
#   end
# end

# load counties during initial startup
scheduler.at '2020/08/20 12:00:00' do
  no_counties_loaded = Query.where(scope: 'county').size
  if no_counties_loaded == 0
    Rails.logger.info("Running queries:add_county_queries ")
    Rake::Task['queries:add_county_queries '].invoke
  end
end

# get latest data from Wikidata for our objects
if Rails.env.production?
  # refresh every day, five minutes after midnight
  scheduler.cron '5 0 * * *' do
    refresh_queries
  end
end

if Rails.env.dev? || Rails.env.development?
  scheduler.every '1h' do
    refresh_queries
  end
end


def refresh_queries
  url = Rails.configuration.wikidata_url
  sparql = SPARQL::Client.new("#{url}/sparql")

  queries = Query.all
  queries.each do |query| 
    throw if query.nil? || query.request.nil?
    request = query.request
    response = sparql.query(request)

    if !response.nil?

      # convert response to JSON and save
      updated_response = response.to_json
      Rails.logger.info("Updating Wikidata response for query object #{query.id}")
      query.update(response: updated_response, queried_at: DateTime.current)

      # scrape query response for email recipients
      Rails.logger.debug("Sending response for recipient processing.")
      Recipient.scrape(query) unless query.response.empty?
    end
  end
end