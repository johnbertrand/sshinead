require 'active_directory'
require 'optparse'
require 'rubygems'
require 'pp'

settings = {
    :host => '',
    :base => '',
    :port => 389,
    :auth => {
      :method => :simple,
      :username => "",
      :password => ""
    }
}


options = {}
parser = OptionParser.new do |opts|
  opts.banner = "Usage: ad_ssh [options]"
 
  opts.on("-e", "--email email" , "Email Address") do |v|
    options[:email] = v
  end

end

parser = OptionParser.new do |opts|
  opts.banner = "Usage: ad_ssh [options]"
 
  opts.on("-g", "--group group" , "Group List") do |v|
    options[:email] = v
  end

end

parser.parse!
puts ARGV[0]



p options[:email]

ActiveDirectory::Base.setup(settings)

# ActiveDirectory::User.find(:all)
key=ActiveDirectory::User.find(:first, :userprincipalname => options[:email]).extensionattribute1
puts "#{options[:email]}\t#{key}"

# ActiveDirectory::Group.find(:all)