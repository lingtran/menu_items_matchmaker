class PriceScanner
  attr_reader :target

  def initialize(target)
    @target = target
  end

  def prune_items_with_prices_exceeding_target_price(input)
    @_pruned_data = input.delete_if { |item| item.values.first > target }
  end

  def extract_prices
    pruned_data.map { |item| item.values }.flatten
  end

  def ascending_sort_of_prices(extracted_prices)
    extracted_prices.sort
  end

  def set_combinations(collection, length)
    collection.combination(length).to_a
  end

  def find_all_price_combos(sorted_prices)
    sorted_prices.map.with_index(2) { |i| set_combinations(sorted_prices, i) }.flatten(1).uniq! || []
  end

  def find_target_price_combos(all_price_combos)
    all_price_combos.group_by { |combo| combo.reduce(0.0, :+) }[target]
  end

  def match_item_by_price(price)
    pruned_data.find_all { |item| item.has_value?(price) }
  end

  def find_a_set_of_items(single_combo)
    single_combo.map { |price| match_item_by_price(price) }.flatten.compact.uniq
  end

  def assign_sets_of_matched_target_prices
    extracted_prices      = extract_prices
    sorted_prices         = ascending_sort_of_prices(extracted_prices)
    all_combos            = find_all_price_combos(sorted_prices)
    @_target_price_combos = find_target_price_combos(all_combos)
  end

  def assign_sets_of_items_and_prices
    @_target_item_combos = target_price_combos.map { |combo| find_a_set_of_items(combo) }
  end

  def target_item_combos_exist?
    if target_item_combos.empty?
      return "Unfortunately, there is no combination of dishes that sum to the target price."
    else
      target_item_combos
    end
  end

  def analyze_input
    assign_sets_of_matched_target_prices
    assign_sets_of_items_and_prices
    target_item_combos_exist?
  end

  private
    def pruned_data
      @_pruned_data
    end

    def target_price_combos
      @_target_price_combos || []
    end

    def target_item_combos
      @_target_item_combos || []
    end
end
