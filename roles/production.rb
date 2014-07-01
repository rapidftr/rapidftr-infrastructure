name "production"

run_list(
  "recipe[core]",
  "recipe[ruby]",
  "recipe[couchdb]",
  "recipe[passenger]",
  "recipe[rapidftr]"
)

override_attributes(
    "rapidftr" => {
        "repository" => "git://github.com/rapidftr/RapidFTR.git",
        "revision"   => "master"
    }
)
