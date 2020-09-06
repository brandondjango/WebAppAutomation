#require 'cuke_cataloger'
#
#desc 'Catalogs feature files with test case tags'
#namespace :catalog do
#  desc 'Catalogs feature files with test case tags'
#  task :id_tests, [:directory, :prefix] do |t, args|
#    puts "Tagging tests in '#{args[:directory]}' with tag '#{args[:prefix]}'\n"
#
#
#
#    our_db_indexes = []
#    File.open("support/rakefiles/cuke/highest_test_case.txt", "r") do |f|
#      f.each_line do |line|
#        our_db_indexes.push(line)
#      end
#    end
#
#    tagger = CukeCataloger::UniqueTestCaseTagger.new
#    our_local_indexes = tagger.determine_known_ids(args[:directory], args[:prefix])
#
#    starting_ids_hash = tagger.send(:default_start_indexes, our_db_indexes + our_local_indexes)
#
#    tagger.tag_tests(args[:directory], args[:prefix], starting_ids_hash)
#  end
#end
#