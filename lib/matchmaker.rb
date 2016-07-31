require_relative 'data_preparation'
require_relative 'price_scanner'
require_relative 'result_presenter'

class Matchmaker
  def initialize(parsed_input)
    @_parsed_input = parsed_input
    @_prep_content = DataPreparation.new
  end

  def prepare_content
    prep_content.assign_target_price(parsed_input)
    prep_content.assign_items_with_prices(parsed_input)
  end

  def start_scanner
    scanner = PriceScanner.new(prep_content.send(:target))
    scanner.prune_items_with_prices_exceeding_target_price(prep_content.send(:items_prices))
    @_result = scanner.analyze_input
  end

  def present_result
    result_presenter = ResultPresenter.new(result)
    result_presenter.determine_format
    result_presenter.formatted_result
  end

  def make_analysis
    prepare_content
    start_scanner
    present_result
  end

  private
  def parsed_input
    @_parsed_input
  end

  def prep_content
    @_prep_content
  end

  def result
    @_result
  end
end
