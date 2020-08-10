namespace :queries do
  require_relative '../data/counties'

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

      @query = Query.new
      @query.title = title
      @query.request = query_str
      @query.scope = 'county'
      @query.user = @user
      @query.save!

      WikidataQueryJob.perform_now(@query, @user)
    end
  end

  private
  QSTART = 'SELECT DISTINCT ?organization ?organizationLabel ?street_address ?coordinate_location ?phone_number ?e_mail_address ?website ?Facebook_ID ?Twitter_username ?county WHERE { VALUES (?located_in_the_administrative_territorial_entity ?county) { (wd:'
  QEND = ') } VALUES ?instance_of { wd:Q473972 wd:Q5193377 wd:Q210272 wd:Q570116 wd:Q57660343 wd:Q2668072 wd:Q188913 wd:Q15243209 wd:Q2867476 wd:Q635719 wd:Q7840289 wd:Q42998 wd:Q41710 } FILTER(NOT EXISTS { ?organization wdt:P576 _:b15. }) ?organization (wdt:P31/(wdt:P279*)) ?instance_of; wdt:P131 ?located_in_the_administrative_territorial_entity. hint:Prior hint:runFirst "true"^^xsd:boolean. OPTIONAL { ?organization wdt:P6375 ?street_address. } OPTIONAL { ?organization wdt:P625 ?coordinate_location. } OPTIONAL { ?organization wdt:P1329 ?phone_number. } OPTIONAL { ?organization wdt:P968 ?e_mail_address. } OPTIONAL { ?organization wdt:P856 ?website. } OPTIONAL { ?organization wdt:P2013 ?Facebook_ID. } OPTIONAL { ?organization wdt:P2002 ?Twitter_username. } SERVICE wikibase:label { bd:serviceParam wikibase:language "en". } } ORDER BY (?organization) LIMIT 10000'
  def build_query_string(id, name)
    query_str = QSTART + id + ' ' + QEND
    return QSTART + id + " \"#{name}\"" + QEND
  end

end
