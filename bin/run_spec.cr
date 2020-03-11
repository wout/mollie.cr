# Run matching spec for given file
begin
  raise "A file is required." unless file = ARGV.first?

  if File.extname(file) == ".cr"
    spec = file
      .sub(/^\.\/src\//, "./spec/")
      .sub(/(_spec)?\.cr$/, "_spec.cr")

    if File.exists?(spec)
      puts "Running #{spec}"
      puts `crystal spec #{spec}`
    else
      puts "Matching spec #{spec} does not exist."
    end
  end
rescue e : Exception
  puts e.message
end
