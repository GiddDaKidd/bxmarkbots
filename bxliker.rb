require 'watir' # Crawler
require 'pry' # Ruby REPL
require 'rb-readline' # Ruby IRB
require 'awesome_print' # Console output
require_relative 'igcredsz' # Pulls in login credentials from credentials.rb

username = $username
password = $password
like_counter = 750
num_of_rounds = 5
MAX_LIKES = 1500

# Open Browser, Navigate to Login page
browser = Watir::Browser.new :chrome, switches: ['--incognito']
browser.goto "instagram.com/accounts/login/"

# Navigate to Username and Password fields, inject info
ap "Logging in..."
browser.text_field(:name => "username").set "#{username}"
browser.text_field(:name => "password").set "#{password}"

# Click Login Button
browser.button(:class => ["_qv64e", "_gexxb", "_4tgw8", "_njrw0"]).click
sleep(1)
puts "We're in #DaWebCrawlLifeMayne"

# Close modal window
browser.button(:class => ["_dbnr9"]).click
sleep(1)
puts "Bitch ass modal got out of our way ;) #itslit"


# Continuous loop to break upon reaching the max likes
loop do
  # Scroll to bottom of window 3 times to load more results (20 per page)
  3.times do |i|
    browser.driver.execute_script("window.scrollBy(0,document.body.scrollHeight)")
    sleep(2)
  end

  # Call all unliked like buttons on page and click each one.
  if browser.span(:class => ["coreSpriteHeartOpen"]).exists?
    browser.spans(:class => ["coreSpriteHeartFull"]).each { |val|
      val.click
      like_counter += 1
    }
    ap "Photos liked: #{like_counter}"
  else
    ap "No media to like at the moment, yo. Sorry pimpin, we tried."
  end
  num_of_rounds += 1
  puts "--------- #{like_counter / num_of_rounds} likes per round (on average) ----------"
  break if like_counter >= MAX_LIKES
  sleep(60) # Return to top of loop after this many seconds to check for new photos
end

# Leave this in to use the REPL at end of program
# Otherwise, take it out and program will just end
Pry.start(binding)
