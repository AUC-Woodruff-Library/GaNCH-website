require 'rufus-scheduler'

scheduler = Rufus::Scheduler.singleton

# avoid creating scheduler in console and rake tasks
return if defined?(Rails::Console) || Rails.env.test? || File.split($0).last == 'rake'

# test schedular is up and running
# scheduler.every '1m' do

#   Rails.logger.info "hello, it's #{Time.now}"
#   Rails.logger.flush
# end

# get latest data from Wikidata for our objects
scheduler.every '1h' do
  url = Rails.configuration.wikidata_url
  sparql = SPARQL::Client.new("#{url}/sparql")

  queries = Query.all
  queries.each do |query| 
    throw if query.nil? || query.request.nil?
    request = query.request
    response = sparql.query(request)

    if !response.nil?

      # convert response to JSON and save
      query.response = response.to_json
      Rails.logger.info("Updating Wikidata response for query object #{query.id}")
      query.save!
    end
  end
end