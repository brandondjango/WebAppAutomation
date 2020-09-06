require 'require_all'
require 'yaml'
require_rel '../../lib/db/base.rb'



namespace :db do
  desc 'Connects to the databases'
  task :connect do
    test_data_db_config = YAML.load_file("lib/db/test_data.yml")

    #Database::BaseDB.establish_connection(test_data_db_config)
  end
end
