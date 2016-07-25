require "gpsoauth/version"
require "gpsoauth/google"
require "gpsoauth/utilities"
require "base64"
require "openssl"
require "httparty"

module Gpsoauth
	class Auth
		class << self
			B64_KEY     = ("AAAAgMom/1a/v0lblO2Ubrt60J2gcuXSljGFQXgcyZWveWLEwo6prwgi3iJIZdodyhKZQrNWp5nKJ3srRXcUW+F1BD3baEVGcmEgqaLZUNBjm057pKRI16kB0YppeGx5qIQ5QjKzsR8ETQbKLNWgRY0QRNVz34kMJR3P/LgHax/6rmf5AAAAAwEAAQ==")
			ANDROID_KEY = Google.keyFromb64(B64_KEY)
			AUTH_URL    = 'https://android.clients.google.com/auth'
			USER_AGENT  = "gpsoauth/1.0.0"

			@@cookie    = ""

			def performAuthRequest(data, cookie = @@cookie)
				response = HTTParty.post(AUTH_URL, body: data, headers: {'User-Agent': USER_AGENT, 'Cookie': cookie})
				@@cookies = response.headers['Set-Cookie'] if response.headers['Set-Cookie']
				return Google.parseAuthResponse(response.body)
			end

			def performMasterLogin(email, password, android_id, service = 'ac2dm', device_country = 'us', operatorCountry = 'us', lang = 'en', sdk_version = 17)
				data = {
			        'accountType': 'HOSTED_OR_GOOGLE',
			        'Email':   email,
			        'has_permission':  1,
			        'add_account': 1,
			        'EncryptedPasswd': Google.signature(email, password, ANDROID_KEY),
			        'service': service,
			        'source':  'android',
			        'androidId':   android_id,
			        'device_country':  device_country,
			        'operatorCountry': device_country,
			        'lang':    lang,
			        'sdk_version': sdk_version
			    }
			    return performAuthRequest(data, "")
			end

			def performOAuth(email, master_token, android_id, service, app, client_sig, device_country = 'us', operatorCountry = 'us', lang = 'en', sdk_version = 17)
				data = {
			        'accountType': 'HOSTED_OR_GOOGLE',
			        'Email':   email,
			        'has_permission':  1,
			        'EncryptedPasswd': master_token,
			        'service': service,
			        'source':  'android',
			        'androidId':   android_id,
			        'app': app,
			        'client_sig': client_sig,
			        'device_country':  device_country,
			        'operatorCountry': device_country,
			        'lang':    lang,
			        'sdk_version': sdk_version
			    }
			    return performAuthRequest(data)
			end
		end
	end
end
