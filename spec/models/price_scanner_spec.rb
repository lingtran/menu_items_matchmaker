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

    it "can set pruned_data as an accessible variable" do
      data     = set_items_and_prices
      scanner.prune_items_with_prices_exceeding_target_price(data)
      new_size = data.size

      expect( scanner.send(:pruned_data).size ).to eq( new_size )
    end
  end

  context "find matching target price combos" do
    before(:each) do
      data             = set_items_and_prices
      scanner.prune_items_with_prices_exceeding_target_price(data)
      @all_combos      = scanner.find_all_combos
    end

    it "can return a collection of prices of all unique combinations" do
      expect( @all_combos.size ).to eq( 63 )
    end

    it "can return a collection of prices that sum exactly to target price" do
      matched_price_combos = scanner.find_target_price_combos(@all_combos)
      expected_matches     = [[{"golden omelette"=>3.0}, {"tatter tots"=>2.0}],
                              [{"golden omelette"=>3.0}, {"wedged potatoes"=>2.0}],
                              [{"golden omelette"=>3.0}, {"orange juice"=>1.0}, {"morning salad"=>1.0}],
                              [{"tatter tots"=>2.0}, {"orange juice"=>1.0}, {"wedged potatoes"=>2.0}],
                              [{"tatter tots"=>2.0}, {"morning salad"=>1.0}, {"wedged potatoes"=>2.0}]]

      expect( matched_price_combos.count ).to eq( 5 )
      expect( matched_price_combos ).to eq( expected_matches )
    end
  end

  context "#target_item_combos_exist?" do
    it "can return sets of items after finding price combos with a different data set" do
      scanner_two   = PriceScanner.new(set_another_target)
      data_set_two  = set_more_items_and_prices
      scanner_two.prune_items_with_prices_exceeding_target_price(data_set_two)
      scanner_two.assign_sets_of_items_and_prices
      matched_items = scanner_two.target_item_combos_exist?

      expect( matched_items ).to eq( [ [{ "sampler plate"=>5.8 }, { "larger sampler plate"=>9.25 }] ] )
    end
  end

  context "it cannot find a match" do
    it "returns a sad message informing that no matches were found against target price" do
      sad_message    = "Unfortunately, there is no combination of dishes that sum to the target price."
      scanner_three  = PriceScanner.new(set_sample_target)
      data_set_three = set_addtl_items_and_prices
      scanner_three.prune_items_with_prices_exceeding_target_price(data_set_three)
      scanner_three.assign_sets_of_items_and_prices
      result         = scanner_three.target_item_combos_exist?

      expect( result ).to eq( sad_message )
    end
  end

end
