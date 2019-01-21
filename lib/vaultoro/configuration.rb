module Vaultoro
  class Configuration
    attr_writer :credentials

    def api_key
      Vaultoro.credentials[Vaultoro.environment][:api_key]
    end

    def api_key=(value)
      Vaultoro.credentials[Vaultoro.environment][:api_key] = value
    end

    def api_secret
      Vaultoro.credentials[Vaultoro.environment][:api_secret]
    end

    def api_secret=(value)
      Vaultoro.credentials[Vaultoro.environment][:api_secret] = value
    end

    def api_uri
      Vaultoro.credentials[Vaultoro.environment][:api_uri]
    end

    def api_uri=(value)
      Vaultoro.credentials[Vaultoro.environment][:api_uri] = value
    end

    def api_version
      Vaultoro.credentials[Vaultoro.environment][:api_version]
    end

    def api_version=(value)
      Vaultoro.credentials[Vaultoro.environment][:api_version] = value
    end

    def credentials
      @credentials ||= {
        :production => {
          :api_key => ENV['VAULTORO_API_KEY'],
          :api_secret => ENV['VAULTORO_API_SECRET'],
          :api_uri => "https://api.vaultoro.com",
          :api_version => 1
        },
        :test => {
          :api_key => "testapi",
          :api_secret => "testpass",
          :api_uri => "https://api.vaultoro.com",
          :api_version => 1
        },
        :development => {
          :api_key => "testapi",
          :api_secret => "testpass",
          :api_uri => "https://api.vaultoro.com",
          :api_version => 1
        }
      }
    end

    def environment
      @environment ||= :production
    end

    def environment=(value)
      @environment = value.is_a?(String) ? value.to_sym : value
    end

    def environments
      Vaultoro.credentials.keys
    end
  end
end
