# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    Movie.create!(movie)
  end
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.content  is the entire content of the page as a string.
  flunk "Unimplemented"
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  ratings = rating_list.split(", ")
  if uncheck != "un"
    ratings.each do |r|
      puts r
      step %Q{I check "ratings_#{r}"}
    end
  else
    ratings.each do |r|
      step %Q{I uncheck "ratings_#{r}"}
    end
  end
end

Then /I should only see movies with the following ratings: (.*)/ do |rating_list|
  ratings = rating_list.split(", ")
  puts ratings
  showed_elements = page.all(:css, 'html body div#main table#movies tbody#movielist tr td[2]')
  showed = []
  showed_elements.each do |x|
    showed << x.text
  end
  puts showed
  showed.each do |r|
    assert ratings.include?(r)
  end
end

Then /I should see (all|none) of the movies/ do |count|
  rows = page.all(:css, 'html body div#main table#movies tbody#movielist tr')
  if count == "all"
    rows.length.should == 10
  elsif count == "none"
    rows.length.should == 0
  end
end