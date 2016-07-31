require 'spec_helper'
require_relative '../../lib/matchmaker'

describe "Matchmaker object" do
  context "#initialization" do
    it "sets parsed content" do
      test_file    = 'spec/support/sample_menu.txt'
      parsed_input = parse_data_file(test_file)
      matchmaker   = Matchmaker.new(parsed_input)

      expect( matchmaker.send(:parsed_input) ).to eq( parsed_input )
    end
  end

  context "steps to make analysis" do
    attr_reader :matchmaker,
                :prep_content,
                :scanner,
                :formatted_result

    before(:each) do
      test_file         = 'spec/support/sample_menu.txt'
      parsed_input      = parse_data_file(test_file)
      @matchmaker       = Matchmaker.new(parsed_input)
      @prep_content     = matchmaker.prepare_content
      @scanner          = matchmaker.start_scanner
      @formatted_result = matchmaker.present_result
    end

    it "can prepare content with setting target and items-prices values" do
      expect( prep_content.send(:target) ).to eq( 5.0 )
      expect( prep_content.send(:items_prices) ).to eq ( [{"mixed fruit"=>2.15}, {"golden omelette"=>3.0}, {"tatter tots"=>2.0}, {"orange juice"=>2.0}] )
    end

    it "can return unformatted results after data preparation" do
      expect( matchmaker.send(:result) ).to eq( scanner.send(:target_price_items_combos) )
    end

    it "can return formatted results after scanning input" do
      expected_format = "\tCombo: golden omelette, 3.0; tatter tots, 2.0\n\tCombo: golden omelette, 3.0; orange juice, 2.0"

      expect( formatted_result ).to eq( expected_format )
    end
  end

  context "#make_analysis" do
    it "returns formatted result with a different sad path data set" do
      test_file    = 'spec/support/another_sample_menu.txt'
      parsed_input = parse_data_file(test_file)
      matchmaker   = Matchmaker.new(parsed_input)
      results      = matchmaker.make_analysis

      expect( results ).to eq( sad_result )
    end
  end
end
