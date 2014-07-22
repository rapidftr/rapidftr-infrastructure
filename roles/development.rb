name "development"

run_list(
  "recipe[core]",
  "recipe[couchdb]",
  "recipe[xvfb]",
  "recipe[firefox]",
  "recipe[phantomjs]",
  "recipe[rvm]",
  "recipe[seed]"
)
