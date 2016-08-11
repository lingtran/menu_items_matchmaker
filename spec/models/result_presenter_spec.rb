require 'spec_helper'
require_relative '../../lib/result_presenter'

describe "ResultPresenter object" do
  context "#initialization" do
    it "can be instantiated with a given result" do
      result_presenter = ResultPresenter.new(happy_result)

      expect( result_presenter.result ).to eq( happy_result )
    end
  end

  context "#happy_path" do
    it "can format data when there are results" do
      result_presenter = ResultPresenter.new(happy_result)
      result           = result_presenter.happy_path
      expected_format  = "\tCombo: 1, golden omelette (3.0); 1, tatter tots (2.0)\n\tCombo: 5, orange juice (1.0)\n\tCombo: 5, morning salad (1.0)"

      expect( result ).to eq( expected_format)
    end
  end

  context "#determine_format" do
    it "can format data based on #happy_path" do
      result_presenter = ResultPresenter.new(happy_result)
      result_presenter.determine_format
      expected_format  = "\tCombo: 1, golden omelette (3.0); 1, tatter tots (2.0)\n\tCombo: 5, orange juice (1.0)\n\tCombo: 5, morning salad (1.0)"

      expect( result_presenter.formatted_result ).to eq( expected_format)
    end

    it "can leave sad message when there are no results" do
      result_presenter = ResultPresenter.new(sad_result)
      result_presenter.determine_format

      expect( result_presenter.formatted_result ).to eq( sad_result)
    end
  end
end
