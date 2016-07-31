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

  def calculate_sum_of(combo)
    combo.reduce(0) { |sum, item| sum += item.values.first }
  end

  def find_target_price_items_combos(all_combos)
    all_combos.group_by { |combo| calculate_sum_of(combo) }[target]
  end

  def assign_sets_of_items_and_prices
    all_combos                  = find_all_combos
    @_target_price_items_combos = find_target_price_items_combos(all_combos)
  end

  def target_price_items_combos_exist?
    if target_price_items_combos.nil?
      return "\tUnfortunately, there is no combination of dishes that sum to the target price."
    else
      target_price_items_combos
    end
  end

  def analyze_input
    assign_sets_of_items_and_prices
    target_price_items_combos_exist?
  end

  private
    def pruned_data
      @_pruned_data
    end

    def target_price_items_combos
      @_target_price_items_combos
    end
end
