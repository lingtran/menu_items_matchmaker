require 'spec_helper'
require_relative '../../lib/file_operations'

describe "FileOperations object" do
  context "processing a text file" do
    it "can read the contents of a text file" do
      test_file = 'spec/support/sample_menu.txt'
      result = FileOperations.process_file(test_file)

      expect( result.class ).to eq(Array)
    end

    it "can parse the content" do
      content        = "$5.00\nmixed fruit,$2.15\ngolden omelette,$3.00\ntatter tots,$2.00\norange juice,$2.00\n"
      parsed_content = ["$5.00", "mixed fruit,$2.15", "golden omelette,$3.00", "tatter tots,$2.00", "orange juice,$2.00"]

      expect( FileOperations.parse(content) ).to eq(parsed_content)
    end
  end

  context "write to a file" do
    it "can write to a new file with results (whether sad or happy)" do
      test_content = "this is test content"
      new_file     = 'data/found_combos.txt'

    # If the test suite was ran after running the program or if this is not the first time test suite is ran, this line will fail. Resulting data file can be deleted, run test suite, and this line will pass.
      expect( File.exists?(new_file) ).to eq(false)

      FileOperations.write_to_file(test_content)

      expect( File.exists?(new_file) ).to eq(true)
      expect( File.read(new_file) ).to eq(test_content)
    end
  end
end
