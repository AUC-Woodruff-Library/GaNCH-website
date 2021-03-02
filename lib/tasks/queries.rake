namespace :queries do
  require_relative '../data/counties'
  require_relative '../data/regions'

  desc "Build multiple query objects from a list of counties"
  task add_county_queries: :environment do
    @user = User.first
    # delete existing county queries
    Query.where(scope: 'county').find_each do |county_query|
      county_query.delete
    end
    Counties::IDS.each do |row| 
      query_str = build_query_string(row[:id], row[:name])
      title = row[:name]

      # create a new Query record for the county
      @query = Query.new
      @query.title = title
      @query.request = query_str
      @query.scope = 'county'
      @query.user = @user
      @query.save!

      WikidataQueryJob.perform_now(@query, @user)

      # don't crowd Wikidata's query interface
      sleep(15.seconds)
    end
  end

  desc "Build multiple region (grouped) query objects from a set of lists"
  task add_region_queries: :environment do
    @user = User.first
    @regions = Query.where(scope: 'region')
    # do not do this if regions already exist, or you can't find a user
    if !@regions.empty?
      return
    elsif @user.nil?
      return
    else
      Regions::GEMA_REGIONS.each do |region|
        title = region[:name]
        counties = region[:counties]

        # build parens-wrapped series of id/name pairs for query
        query_str = build_region_query_string(counties)

        # create a new Query record for the region
        @query = Query.new
        @query.title = title
        @query.request = query_str
        @query.scope = 'region'
        @query.user = @user
        @query.save!

        WikidataQueryJob.perform_now(@query, @user)

        # don't crowd Wikidata's query interface
        sleep(1.minutes)
      end
    end
  end

  private
  QSTART = 'SELECT DISTINCT ?organization ?organizationLabel ?street_address ?coordinate_location ?phone_number ?e_mail_address ?website ?Facebook_ID ?Twitter_username ?county WHERE { VALUES (?located_in_the_administrative_territorial_entity ?county) { '
  QEND = ' } VALUES ?instance_of { wd:Q473972 wd:Q5193377 wd:Q210272 wd:Q570116 wd:Q57660343 wd:Q2668072 wd:Q188913 wd:Q15243209 wd:Q2867476 wd:Q635719 wd:Q7840289 wd:Q42998 wd:Q41710 } FILTER(NOT EXISTS { ?organization wdt:P576 _:b15. }) ?organization (wdt:P31/(wdt:P279*)) ?instance_of; (wdt:P131+) ?located_in_the_administrative_territorial_entity. OPTIONAL { ?organization wdt:P6375 ?street_address. } OPTIONAL { ?organization wdt:P625 ?coordinate_location. } OPTIONAL { ?organization wdt:P1329 ?phone_number. } OPTIONAL { ?organization wdt:P968 ?e_mail_address. } OPTIONAL { ?organization wdt:P856 ?website. } OPTIONAL { ?organization wdt:P2013 ?Facebook_ID. } OPTIONAL { ?organization wdt:P2002 ?Twitter_username. } SERVICE wikibase:label { bd:serviceParam wikibase:language "en". } } ORDER BY (?organization) LIMIT 10000'
  def build_query_string(id, name)
    query_str = QSTART + "(wd:" + id + " \"#{name}\" ) " + QEND
    return query_str
  end

  def build_region_query_string(objs)
    # build parens-wrapped series of id/name pairs for query
    county_string = String.new
    objs.each do |obj|
      q_pair = "(wd:#{obj[:id]} \"#{obj[:name]}\") "
      county_string << q_pair
    end
    return QSTART + county_string + QEND
  end

end
