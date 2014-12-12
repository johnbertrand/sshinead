require 'active_directory'
require 'optparse'
require 'rubygems'
require 'pp'

settings = {
    :host => 'example.com',
    :base => 'dc=dc,dc=org',
    :port => 389,
    :auth => {
      :method => :simple,
      :username => "USERNAME",
      :password => "PASSWD"
    }
}

ActiveDirectory::Base.setup(settings)




def get_user (user)
        return ActiveDirectory::User.find(:first, :userprincipalname => user)
end

def get_group(group)
    return ActiveDirectory::Group.find(:first,:name=>group)
end


def show_key (user)
    ad_user=get_user(user)
    puts ad_user.get_attr("extensionattribute1")
end

def show_group (group)
        ad_group = get_group(group)
        if ad_group != nil
          unless ad_group.get_attr("member").nil?
              ad_group.get_attr("member").each do |m|
                  puts m.get_attr("distinguishedname")
                  puts m.get_attr("extensionattribute1")
              end
          end
        else
          #puts "Empty Group"
        end
end

def set_key(user, key)
    ad_user = get_user (user)
    unless ad_user.nil?
        ad_user.update_attribute("extensionattribute1", key) 
    end
end

def add_to_group(group, user)
    ad_group = get_group(group)
    ad_user = get_user (user)

    unless ad_group.nil? || ad_user.nil?
        ad_group.add(ad_user)
    end
end

def remove_from_group(group, user)
    ad_group = get_group(group)
    ad_user = get_user (user)

    unless ad_group.nil? || ad_user.nil?
        ad_group.remove(ad_user)
    end
end

def usage()
    puts "sshinead.rb [options]"
    puts "Key operations"
    puts "--get-key user"
    puts "--add-key -u user -k key"
    

    puts "Group Operations"
    puts "--get-group group"
    puts "--add-to-group -g group -u user"
    puts "--remove-from-group -g group -u user"

    puts "Outout formats"
    puts "--out [chef,ansible] "


end
opt_struct = OpenStruct.new
opt_struct.user=nil
opt_struct.group=nil
opt_struct.key=nil

opt_struct.get_key=false
opt_struct.get_group=false
opt_struct.add_key=false
opt_struct.add_to_group=false
opt_struct.remove_from_group=false

parser = OptionParser.new do |opts|
  opts.banner = "Usage: ad_ssh [options]"

  opts.on("-u user", "--user user") do |user|
    opt_struct.user = user
  end

  opts.on("-g group", "--group group") do |group|
    opt_struct.group = group
  end

  opts.on("-k key", "--key key") do |key|
    opt_struct.key = key
  end
  

  opts.on("--get-key user") do |user|
        opt_struct.user = user
        opt_struct.get_key = true
  end

  opts.on("--get-group group") do |group|
        opt_struct.group = group
        opt_struct.get_group=true
  end

  opts.on("--set-key") do |key|
    opt_struct.set_key = true
  end
  
  opts.on("--add-to-group") do |key|
    opt_struct.add_to_group = true
  end

   opts.on("--remove-from-group") do |key|
    opt_struct.remove_from_group = true
  end

end

parser.parse!




if opt_struct.get_key
    show_key(opt_struct.user)
    exit
end

if opt_struct.get_group
    show_group(opt_struct.group)
    exit
end

if opt_struct.set_key
    set_key(opt_struct.user, opt_struct.key)
    exit
end

if opt_struct.add_to_group
    add_to_group(opt_struct.group, opt_struct.user)
    exit
end

if opt_struct.remove_from_group
    remove_from_group(opt_struct.group, opt_struct.user)
    exit
end

usage

