#3rd party first
require('require_all')
require 'page-object'

require 'socket'
hostname = Socket.gethostname

#second party
require_rel 'common_env.rb'

#project related, requires go in order
require_rel('../step_definitions')
require_rel('../hooks')
World(PageObject::PageFactory)

#Environment Variables


#print hostname
print "\nhostname is: " + hostname + "\n"

#@driver_folder = "#{__dir__}/driver"
#ENV['PATH'] = "#{@driver_folder}:#{ENV['PATH']}"

