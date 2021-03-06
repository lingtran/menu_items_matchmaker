### Context 
Given a data file in which the target price is stated in the first line of it, the menu items matchmaker is able to return results showcasing different combinations of menu items that sum to the target price. 

Program runs in the command line. See commands below to perform stated actions.

### Get program by cloning down repo
> `git clone https://github.com/lingtran/menu_items_matchmaker.git`

### Install Dependencies
> `bundle install`

### Run the program
> `ruby lib/runner.rb {PATH_TO_DATA_FILE.txt}`

To run existing data file in program:
> `ruby lib/runner.rb data/menu.txt`

### Test suite

To run all tests:
> `rspec`

To run a particular test file:
> `rspec spec/models/SPEC_FILENAME.rb`

To run a particular test within a test file:
> `rspec spec/{SPEC_FILENAME.rb}:{LINE_NUMBER_WHERE_TEST_STARTS}`
