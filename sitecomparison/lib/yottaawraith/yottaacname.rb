require 'net/dns'


class YottaaCName

  def getdig(hostname)



    packet = Net::DNS::Resolver.start("#{hostname}")
    packet.each_cname do |name|

      name = name.chop
      return name
      #puts "Cleaned up cname: #{name}"

    end


  end


end