require 'spec_helper'
require_relative '../../lib/price_scanner'

describe "PriceScanner object" do
  attr_reader :scanner,
              :target

  before(:each) do
    @scanner = PriceScanner.new(set_sample_target)
    @target  = @scanner.target
  end

  context "#initialization" do
    it "sets the target" do
      expect( scanner.target ).to eq( set_sample_target )
    end
  end

  context "#prune_items_with_prices_exceeding_target_price" do
    it "can prune input by rejecting items with prices greater than target price" do
      data          = set_items_and_prices
      original_size = data.size

      expect { scanner.prune_items_with_prices_exceeding_target_price(data) }.to change{ data.count }.by(-1)
      expect( data.size ).not_to eq( original_size )
    end

    it "can set pruned_data as an accessible method" do
      data = set_items_and_prices

      scanner.prune_items_with_prices_exceeding_target_price(data)

      new_size = data.size

      expect( scanner.send(:pruned_data).size ).to eq( new_size )
    end
  end

  context "set combos and value_combos_counter collections" do
    it "can set a combos collection for all possible collections leading up to target value" do
      combos = scanner.set_combinations

      expect( combos.class ).to eq( Array )
      expect( combos.length - 1 ).to eq( target )
      expect( scanner.send(:combos) ).to eq( combos )
    end

    it "can set a value_combos_counter that counts number of combos per value leading up to target value" do
      values_combos_counter = scanner.set_values_combos_counter

      expect( values_combos_counter.class ).to eq( Array )
      expect( values_combos_counter.length - 1 ).to eq( target )
      expect( scanner.send(:values_combos_counter) ).to eq( values_combos_counter )
    end
  end

  context "#increment_counter" do
    it "increments the values_combos_counter by 1" do
      scanner.set_values_combos_counter

      values_combos_counter = scanner.send(:values_combos_counter)
      index                 = target

      expect( values_combos_counter[index][index] ).to eq( 0 )

      expect { scanner.increment_counter(index) }.to change{ values_combos_counter[index][index] }.by(1)
    end
  end

  context "find matching target price combos" do
    attr_reader :combos,
                :data

    before(:each) do
      @data = set_items_and_prices

      scanner.prune_items_with_prices_exceeding_target_price(data)
      scanner.set_up

      @combos = scanner.send(:combos)
    end

    it "can set a combination for an index number that is divisible by item's price" do
      index = 200
      item  = data[2]

      expect( scanner.is_divisible?(index, item) ).to eq( true )

      result = scanner.set_combo_for_index_divisible_by_item_price(index, item)

      expect( result ).to eq( [ [{1=>{"tatter tots"=>200}}] ] )
      expect( result ).to eq( combos[index] )
    end

    it "can set combinations for an index based on difference between index and item price" do
      index = 300
      item  = data[2]
      diff  = scanner.get_difference(index, item)

      scanner.set_combo_for_index_divisible_by_item_price(100, data[3])
      scanner.set_combo_for_index_divisible_by_item_price(100, data[4])
      expect( scanner.is_greater_than_item_price?(index, item) ).to eq( true )

      result = scanner.set_combos_for_index_with_combos_at_difference(diff, index, item)

      expect( result ).to eq( [[{1=>{"orange juice"=>100}}, {1=>{"tatter tots"=>200}}], [{1=>{"morning salad"=>100}}, {1=>{"tatter tots"=>200}}]] )
      expect( result ).to eq( combos[index] )
    end

    it "can find target price items combos" do
      result        = scanner.assign_combos_at_different_values
      expect_result = [
                       [{1=>{"golden omelette"=>300}}, {1=>{"tatter tots"=>200}}],
                       [{5=>{"orange juice"=>100}}],
                       [{5=>{"morning salad"=>100}}],
                       [{1=>{"golden omelette"=>300}}, {1=>{"wedged potatoes"=>200}}],
                       [{3=>{"orange juice"=>100}}, {1=>{"wedged potatoes"=>200}}],
                       [{3=>{"morning salad"=>100}}, {1=>{"wedged potatoes"=>200}}],
                       [{1=>{"orange juice"=>100}}, {2=>{"wedged potatoes"=>200}}],
                       [{1=>{"morning salad"=>100}}, {2=>{"wedged potatoes"=>200}}]
                     ]

      expect( result ).to eq( expect_result )
      expect( result.length ).to eq( 8 )
      expect( {target => result.length} ).to eq( scanner.send(:values_combos_counter)[target] )
      expect( result ).to eq( scanner.send(:target_price_items_combos) )
    end
  end


  context "#target_item_combos_exist?" do
    it "can return sets of items after finding price combos with a different data set" do
      target_two    = set_another_target
      scanner_two   = PriceScanner.new(target_two)
      data_set_two  = set_more_items_and_prices

      scanner_two.prune_items_with_prices_exceeding_target_price(data_set_two)
      scanner_two.set_up
      scanner_two.assign_combos_at_different_values

      matched_items   = scanner_two.target_price_items_combos_exist?
      expected_result = [
                          [{7=>{"mixed fruit"=>215}}],
                          [{1=>{"mixed fruit"=>215}}, {2=>{"hot wings"=>355}}, {1=>{"sampler plate"=>580}}],
                          [{1=>{"sampler plate"=>580}}, {1=>{"larger sampler plate"=>925}}]
                        ]

      expect( matched_items ).to eq( expected_result )
    end
  end

  context "it cannot find a match and #analyze_input" do
    it "returns a sad message informing that no matches were found against target price" do
      sad_message    = "\tUnfortunately, there is no combination of dishes that sum to the target price."
      scanner_three  = PriceScanner.new(set_sample_target)
      data_set_three = set_addtl_items_and_prices

      scanner_three.prune_items_with_prices_exceeding_target_price(data_set_three)

      result = scanner_three.analyze_input

      expect( result ).to eq( sad_message )
    end
  end

end
