namespace :queries do
  COUNTIES = [
    { name: 'Chatham County', id: 'Q384890'},
    { name: 'Fayette County', id: 'Q501115'},
    { name: 'Union County', id: 'Q491547'},
    { name: 'Cobb County', id: 'Q484247'},
    { name: 'Rabun County', id: 'Q503546'},
    { name: 'DeKalb County', id: 'Q486398'}
  ]

  desc "Build multiple query objects from a list of counties"
  task add_county_queries: :environment do
    @user = User.first
    # delete existing county queries
    Query.where(scope: 'county').find_each do |county_query|
      county_query.delete
    end
    COUNTIES.each do |row| 
      query_str = build_query_string(row[:id])
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
  QSTART = 'SELECT DISTINCT ?organization ?organizationLabel ?located_at_street_address ?coordinate_location ?phone_number ?e_mail_address WHERE { VALUES ?instance_of { wd:Q473972 wd:Q5193377 wd:Q210272 wd:Q570116 wd:Q57660343 wd:Q2668072 wd:Q188913 wd:Q15243209 wd:Q2867476 wd:Q635719 wd:Q7840289 wd:Q42998 wd:Q41710 } FILTER NOT EXISTS { ?organization wdt:P576 [] } ?organization (wdt:P31/(wdt:P279*)) ?instance_of. ?organization wdt:P131 wd:'
  QEND = '. OPTIONAL { ?organization wdt:P6375 ?located_at_street_address. } OPTIONAL { ?organization wdt:P625 ?coordinate_location. } OPTIONAL { ?organization wdt:P1329 ?phone_number. } OPTIONAL { ?organization wdt:P968 ?e_mail_address. } SERVICE wikibase:label { bd:serviceParam wikibase:language "en". } } ORDER BY ?organization LIMIT 200'
  def build_query_string(id)
    return QSTART + id + QEND
  end

end
