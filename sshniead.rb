require 'active_directory'
require 'optparse'
require 'rubygems'
require 'pp'

settings = {
    :host => 'sfdc01.plos.org',
    :base => 'dc=plos,dc=org',
    :port => 389,
    :auth => {
      :method => :simple,
      :username => "XXXXXx",
      :password => "XXXXXX"
    }
}


options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: ad_ssh [options]"
  opts.on("-e", [Text], "Email Address") do |v|
    options[:verbose] = v
  end
end.parse!

p options
p ARGV



email=ARGV[0]

# Basic usage
ActiveDirectory::Base.setup(settings)

# ActiveDirectory::User.find(:all)
key=ActiveDirectory::User.find(:first, :userprincipalname => email).extensionattribute1
puts "#{email}\t#{key}"

# ActiveDirectory::Group.find(:all)