class PriceScanner
  attr_reader :target

  def initialize(target)
    @target = target
  end

  def prune_items_with_prices_exceeding_target_price(input)
    @_pruned_data = input.delete_if { |item| item.values.first > target }
  end

  def set_combinations
    @_combos = (0..target).map { |i| [] }
  end

  def set_values_combos_counter
    @_values_combos_counter = (0..target).map { |i| {i=>0} }
  end

  def set_up
    set_combinations
    set_values_combos_counter
  end

  def increment_counter(index)
    values_combos_counter[index][index] += 1
  end

  def find_up_to_target_price_combinations
    pruned_data.each do |item|
      values_combos_counter.each_with_index do |value, index|
        if index == 0
          next
        elsif is_divisible?(index, item)
          set_combo_for_index_divisible_by_item_price(index, item)
        elsif is_greater_than_item_price?(index, item)
          diff = get_difference(index, item)
          set_combos_for_index_with_combos_at_difference(diff, index, item)
        else
          next
        end
      end
    end
  end

  def find_target_price_items_combos
    combos[target]
  end

  def is_divisible?(index, item)
    (index % item.values.first) == 0
  end

  def set_combo_for_index_divisible_by_item_price(index, item)
    increment_counter(index)
    q = divide_index_by_item_price(index, item)
    combos[index] << [ {q => item} ]
  end

  def is_greater_than_item_price?(index, item)
    index > item.values.first
  end

  def get_difference(index, item)
    index - item.values.first
  end

  def set_combos_for_index_with_combos_at_difference(diff, index, item)
    combos[diff].each do |combo|
      increment_counter(index)
      if item_already_included_in_combo?(combo, item)
        combos[index] << determine_retain_or_update_combo(combo, item, index)
      else
        combos[index] << [ combo, { 1 => item } ].flatten
      end
    end
    combos[index]
  end

  def assign_combos_at_different_values
    find_up_to_target_price_combinations
    @_target_price_items_combos = find_target_price_items_combos
  end

  def target_price_items_combos_exist?
    if target_price_items_combos.empty?
      return "\tUnfortunately, there is no combination of dishes that sum to the target price."
    else
      target_price_items_combos
    end
  end

  def analyze_input
    set_up
    assign_combos_at_different_values
    target_price_items_combos_exist?
  end

  private
    def pruned_data
      @_pruned_data
    end

    def combos
      @_combos
    end

    def values_combos_counter
      @_values_combos_counter
    end

    def target_price_items_combos
      @_target_price_items_combos
    end

    def divide_index_by_item_price(index, item)
      index/(item.values.first)
    end

    def item_already_included_in_combo?(combo, item)
      combo.any? { |option| option.values.include?(item) }
    end

    def determine_retain_or_update_combo(combo, item, index)
      new_combo = set_new_combo(combo, item)

      if new_price_greater_than_index?(new_combo, index)
        combo
      else
        new_combo
      end
    end

    def set_new_combo(combo, item)
      new_combo = initialize_combo(combo)
      new_q     = increment_quantity(new_combo, item)
      remove_old_option(new_combo, item)
      new_combo << { new_q => item }
    end

    def initialize_combo(combo)
      Array.new.replace(combo)
    end

    def increment_quantity(combo, item)
      combo.find { |option| option.values.include?(item) }.keys.first + 1
    end

    def remove_old_option(combo, item)
      combo.delete_if { |option| option.values.include?(item) }
    end

    def new_price_greater_than_index?(new_combo, index)
      get_price(new_combo) > index
    end

    def get_price(combo)
      combo.reduce(0) { |sum, item| sum += (item.keys.first * item.values.first.values.first) }
    end
end
