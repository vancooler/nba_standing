# Tools in this project

	* Ruby V2.0.0
	* Rails V4.1.4
	* Database: postgresql
	* Testing & report: Rspec+Simplecov

# Get start

## How it works?

1. Run the following line in console to make sure all gems are well installed
```bundle install```
2. Adjust the **config/database.yml** file to match the database credencials in your environment
3. Run the following line in console to migrate database structure
```rake db:migrate```
4. Open **localhost:3000** in browser and it will fetch the data, store in database and display all the data in tables

## How to test it?
Similar as above to make sure gems are installed and test database credencials are good. Then run the following line in console. It will generate a html file as **coverage/index.html** and you can open it in browser to see how the testing codes covers.
```COVERAGE=true bundle exec rspec```
# Limitations

## Extensible
I know it is important to make sure the core function extensible, however I am not a master with HTML scraping. The best way I came up with was creating a UI to gather the HTML elements and their ids/classes and put them into a hash and parse the HTML page with this hash. But I don't think I can finish it in 6 hours. I look forward to talking to you on it and learn something genius that I don't know.

## Testing 
I don't have much time to do testing, so I just test it with some simple test cases. If more time given, I would like to come up with more test scenarios to make sure all the edge conditions and invalid inputs are well tested. 
