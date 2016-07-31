require_relative 'file_operations'
require_relative 'matchmaker'

parsed_input = FileOperations.process_file ARGV[0]
puts "Successfully read menus"

puts "Processing menu content for delicious combinations..."

matchmaker = Matchmaker.new(parsed_input)
results    = matchmaker.make_analysis

FileOperations.write_to_file(results)

puts "Result(s) that match target price of #{parsed_input.first }:\n"
puts "#{results}"
puts "You can also visit the file path '#{'data/found_combos.txt'}' to reference the result(s)."
