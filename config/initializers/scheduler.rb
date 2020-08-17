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

# get latest data from Wikidata for our objects
scheduler.every '15m' do
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
