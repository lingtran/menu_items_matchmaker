require 'spec_helper'
require_relative '../../lib/data_preparation'

describe "DataPreparation object" do
  before(:each) do
    @parsed_input     = parse_data_file('spec/support/sample_menu.txt')
    @prepared_content = DataPreparation.new
  end

  context "#assign_target_price" do
    it "can assign target value as a float" do
      target = @prepared_content.assign_target_price(@parsed_input)

      expect( @parsed_input.first.class ).to eq( String )
      expect( target ).not_to eq( @parsed_input.first.class )
      expect( @prepared_content.send(:target) ).to eq( target )
    end
  end

  context "#assign_items_with_prices" do
    it "can assign menu items and prices to a retrievable data structure" do
      stored_data = @prepared_content.assign_items_with_prices(@parsed_input)
      target      = @prepared_content.assign_target_price(@parsed_input)

      expect( stored_data.size ).to eq( 4 )
      expect( stored_data.first.keys ).not_to include( target )
      expect( @prepared_content.send(:items_prices) ).to eq( stored_data )
    end
  end

  context "#convert_to_float" do
    it "can convert string with dollar sign to float" do
      content       = DataPreparation.new
      dollar_string = "$5.00"
      result        = content.convert_to_float(dollar_string)

      expect( result.class ).to eq( Float )
      expect( result ).not_to eq( dollar_string )
    end
  end

  context "#convert_to_integer" do
    it "can format converted float to integer" do
      content       = DataPreparation.new
      dollar_string = "$5.00"
      result        = content.convert_to_integer(dollar_string)

      expect( result.class ).to eq( Fixnum )
      expect( result ).not_to eq( dollar_string )
      expect( result ).to eq( 500 )
    end
  end
end
