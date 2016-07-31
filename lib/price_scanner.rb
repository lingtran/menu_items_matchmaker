class PriceScanner
  attr_reader :target

  def initialize(target)
    @target = target
  end

  def prune_items_with_prices_exceeding_target_price(input)
    @_pruned_data = input.delete_if { |item| item.values.first > target }
  end

  def set_combinations(collection, length)
    collection.combination(length).to_a
  end

  def find_all_combos
    pruned_data.map.with_index(1) { |_e, i| set_combinations(pruned_data, i) }.flatten(1).uniq
  end

  def find_target_price_combos(all_combos)
    all_combos.group_by { |combo| combo.reduce(0) {|sum, item| sum += item.values.first } }[target]
  end

  def assign_sets_of_items_and_prices
    all_combos           = find_all_combos
    @_target_item_combos = find_target_price_combos(all_combos)
  end

  def target_item_combos_exist?
    if target_item_combos.nil?
      return "Unfortunately, there is no combination of dishes that sum to the target price."
    else
      target_item_combos
    end
  end

  def analyze_input
    assign_sets_of_items_and_prices
    target_item_combos_exist?
  end

  private
    def pruned_data
      @_pruned_data
    end

    def target_item_combos
      @_target_item_combos
    end
end
