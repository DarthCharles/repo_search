class Commands::SearchRepositoryTest < ActiveSupport::TestCase
  let(:command) { Commands::SearchRepository.new }

  describe '#execute' do
    it 'returns an array of repositories if request is successful' do
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

      result = command.execute('pokemon')
      assert_equal 1, result.repos.count
      assert_equal 200, result.status
    end

    it 'returns empty array if there was an error with request' do
      RestClient::Request.stubs(:execute).raises(RestClient::Exception)
      result = command.execute('pokemon')
      assert_empty result.repos
    end
  end
end