munsters = {
  "Herman" => { "age" => 32, "gender" => "male" },
  "Lily" => { "age" => 30, "gender" => "female" },
  "Grandpa" => { "age" => 402, "gender" => "male" },
  "Eddie" => { "age" => 10, "gender" => "male" },
  "Marilyn" => { "age" => 23, "gender" => "female" },
}

munsters.select { |keys, values|
  if values["age"] < 17
    values["age_group"] = "kid"
  elsif values["age"].between?(18, 64)
    values["age_group"] = "adult"
  else
    values["age_group"] = "senior"
  end
}
