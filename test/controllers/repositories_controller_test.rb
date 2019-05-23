require 'test_helper'

class RepositoriesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get root_url
    assert_response :success
  end

  test "should get search" do
    expected_body = {
      items:
        [
          {
            name:       'ruby',
            url:        'www.ruby.com',
            language:   'ruby',
            stars:      5,
            updated_at: Time.now,
            owner:      {
              login: 'theinternet'
            }
          }
        ]
    }.to_json
    RestClient::Request.stubs(execute: stub(code: 200, body: expected_body))
    get repositories_search_url, params: { search: { query: 'ruby' } }
    assert_response :success
  end

end
