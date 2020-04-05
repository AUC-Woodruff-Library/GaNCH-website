json.extract! query, :id, :title, :request, :response, :created_at, :updated_at
json.url query_url(query, format: :json)
