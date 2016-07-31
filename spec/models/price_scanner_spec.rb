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

  context "break down input to handle prices" do
    before(:each) do
      @data             = set_items_and_prices
      scanner.prune_items_with_prices_exceeding_target_price(@data)
      @extracted_prices = scanner.extract_prices
      @sorted_prices    = scanner.ascending_sort_of_prices(@extracted_prices)
    end

    it "can extract prices from pruned input of items" do
      expect( @extracted_prices.length ).to eq( @data.length )
      expect( @extracted_prices.first ).to eq( @data.first["mixed fruit"] )
    end

    it "can sort extracted prices from lowest value to highest value" do
      expect( @sorted_prices.first ).to eq( @extracted_prices.min )
      expect( @sorted_prices.last ).to eq( @extracted_prices.max )
    end
  end

  context "find target matching price combos" do
    before(:each) do
      data             = set_items_and_prices
      scanner.prune_items_with_prices_exceeding_target_price(data)
      extracted_prices = scanner.extract_prices
      @sorted_prices   = scanner.ascending_sort_of_prices(extracted_prices)
      @all_combos      = scanner.find_all_price_combos(@sorted_prices)
    end

    it "can return a collection of prices of all unique combinations" do
      expect( @all_combos.size ).to eq( 18 )
    end

    it "can return a collection of prices that sum exactly to target price" do
      matched_price_combos = scanner.find_target_price_combos(@all_combos)

      expect( matched_price_combos.count ).to eq( 2 )
      expect( matched_price_combos ).to eq( [ [2.00, 3.00], [1.00, 1.00, 3.00] ] )
    end
  end

  context "find matched items to reflect matched target price combos" do
    it "can find a single set of items given a subset of combos" do
      scanner.prune_items_with_prices_exceeding_target_price(set_items_and_prices)
      subset_of_target_price_combos = [[2.00, 3.00], [1.00, 1.00, 3.00]].first
      matched_items                 = scanner.find_a_set_of_items(subset_of_target_price_combos)

      expect( matched_items ).to eq( [{ "tatter tots"=>2.0 }, { "golden omelette"=>3.0 }] )
    end

    it "can assign all subsets of items given collective target price combos" do
      scanner.prune_items_with_prices_exceeding_target_price(set_items_and_prices)
      scanner.assign_sets_of_matched_target_prices
      matched_items = scanner.assign_sets_of_items_and_prices

      expect( matched_items ).to eq( [ [{ "tatter tots"=>2.0 }, { "golden omelette"=>3.0 }], [{ "orange juice"=>1.0 }, { "morning salad"=>1.0 }, { "golden omelette"=>3.0 }] ] )
    end
  end

  context "#target_item_combos_exist?" do
    it "can return sets of items after finding price combos with a different data set" do
      scanner_two    = PriceScanner.new(set_another_target)
      data_set_two   = set_more_items_and_prices
      scanner_two.prune_items_with_prices_exceeding_target_price(data_set_two)
      scanner_two.assign_sets_of_matched_target_prices
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
      scanner_three.assign_sets_of_matched_target_prices
      scanner_three.assign_sets_of_items_and_prices
      result         = scanner_three.target_item_combos_exist?

      expect( result ).to eq( sad_message )
    end
  end

end
