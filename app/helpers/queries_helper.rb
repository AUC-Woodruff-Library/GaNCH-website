module QueriesHelper
  def parse_response_headers(str)
    hash = JSON.parse(str)
    headers = hash['head']['vars']
    logger.debug "Response hash vars: #{headers.inspect}"

    return headers
  end

  def parse_response_body(str)
    hash = JSON.parse(str)
    body = hash['results']['bindings']
    return body
  end
end
