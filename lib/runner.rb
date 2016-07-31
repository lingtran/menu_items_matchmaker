require_relative 'file_operations'
require_relative 'data_preparation'
require_relative 'price_scanner'
require_relative 'result_presenter'

parsed_input = FileOperations.process_file ARGV[0]
puts "Successfully read menus"

puts "Processing menu content for delicious combinations..."

prepared_content = DataPreparation.new
target           = prepared_content.assign_target_price(parsed_input)
items_prices     = prepared_content.assign_items_with_prices(parsed_input)

scanner          = PriceScanner.new(target)
scanner.prune_items_with_prices_exceeding_target_price(items_prices)
result           = scanner.analyze_input

result_presenter = ResultPresenter.new(result)
result_presenter.determine_format
content = result_presenter.formatted_result

FileOperations.write_to_file(content)

puts "Result(s):\n"
puts "\t#{content}"
puts "You can also visit the file path '#{'data/found_combos.txt'}' to reference the result(s)."
