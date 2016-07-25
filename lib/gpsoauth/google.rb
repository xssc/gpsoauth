module Gpsoauth
	class Google
		class << self
			def keyFromb64(key)
				binaryKey = Base64.decode64(key)
				i 		  = Utils.bytesToLong(binaryKey[0..3])
				mod 	  = Utils.bytesToLong(binaryKey[4..3+i])

				j   	  = Utils.bytesToLong(binaryKey[i+4..i+7])
				exponent  = Utils.bytesToLong(binaryKey[i+8..i+7+j])

				key   = OpenSSL::PKey::RSA.new
				key.e = OpenSSL::BN.new(exponent)
				key.n =  OpenSSL::BN.new(mod)

				return key
			end

			def keyToStuct(key)
			  modulus = key.n
			  exponent = key.e
			  return Utils.serialize_number(modulus.num_bytes, 4) + Utils.serialize_number(modulus) + Utils.serialize_number(exponent.num_bytes, 4) + Utils.serialize_number(exponent)
			end

			def parseAuthResponse(text)
				responseData = Hash.new
				text.split("\n").each do |line|
					if line == nil
						next
					end
					key, _, val = line.partition('=')
					responseData[key] = val
				end
				return responseData
			end

			def signature(email, password, key)
				signature = "\x00"
				struct = keyToStuct(key).pack('c*')
				signature = signature + OpenSSL::Digest::SHA1.digest(struct)[0...4]
				encryptedLogin = key.public_encrypt(email + "\x00" + password, OpenSSL::PKey::RSA::PKCS1_OAEP_PADDING)
				signature = signature + encryptedLogin
				return Base64.urlsafe_encode64(signature)
			end
		end
	end
end
