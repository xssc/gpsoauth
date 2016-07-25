module Gpsoauth
  class Utils
    class << self
      def bytesToLong(s)
      	return s.bytes.inject {|a, b| (a << 8) + b }
      end

      def divmod(bn, v)
        bn = bn.to_s.to_i if bn.is_a?(OpenSSL::BN)
        return bn.divmod(v)
      end

      def serialize_number(n, min_size=nil)
        res = []
        n, mod = divmod(n, 256)
        while mod > 0 || n > 0
          res << mod
          n, mod = divmod(n, 256)
        end
        res = res.reverse
        if min_size
          if res.size < min_size
            res = Array.new(min_size - res.size, 0) + res
          end
        end
        return res
      end
    end
  end
end