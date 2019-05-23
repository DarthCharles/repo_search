class Commands::SearchRepository

  Response = Struct.new(:repos, :status)

  def execute(query)
    perform_search(query)
  end

  private

  def perform_search(query)
    params  = {
      q:     query,
      sort:  'stars',
      order: 'desc'
    }.to_query
    url     = "https://api.github.com/search/repositories?#{params}"
    request = { method: :get, url: url }

    Response.new.tap do |r|
      begin
        raw_resp = RestClient::Request.execute(request)
        r.status = raw_resp.code
        r.repos  = parse_response(raw_resp.body)
      rescue RestClient::Exception => e
        Rails.logger.error("[Commands::SearchRepository] Error: #{e.message}")
        r.status = e.http_code
        r.repos  = []
      end
    end
  end

  def parse_response(raw_resp)
    response = JSON.parse(raw_resp).dig('items')
    response.each_with_object([]) do |repo, array|
      array << Repository.new(
        author:     repo['owner']['login'],
        name:       repo['name'],
        url:        repo['html_url'],
        language:   repo['language'],
        stars:      repo['stargazers_count'],
        updated_at: DateTime.parse(repo['updated_at'])
      )
    end
  end
end