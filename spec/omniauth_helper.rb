def omniauth_omniauth_intercom
  OmniAuth.config.test_mode = true
  OmniAuth.config.mock_auth[:intercom] = OmniAuth::AuthHash.new({
    :provider => 'intercom',
    :uid => '342324',
    :info => {
      :email => 'john.dev@intercom.io',
      :name => 'John Dev'
    },
    :credentials => {
      :token => 'dG9rOmNdrWt0ZjtgzzE0MDdfNGM5YVe4MzsmXzFmOGd2MDhiMfJmYTrxOtA=',
      :expires => false
    },
    :extra => {
      :raw_info => {
        :email => 'john.dev@intercom.io',
        :name => 'John Dev'
        :type => 'admin',
        :id => '342324',
        :email_verified => true,
        :app => {
          :id_code => 'abc123',
          :type => 'app',
          :secure => true,
          :timezone => "Dublin",
          :name => "Cadet-Test"
        },
        :avatar => {
          :image_url => "https://static.intercomassets.com/avatars/343616/square_128/me.jpg?1454165491"
        }
      }
    }
  })
  end
