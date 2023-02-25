require 'csv'

desc "Import students from students.csv"
task import_students: :environment do
  path = Rails.root.join('students.csv').to_s

  CSV.foreach(path, headers: true) do |row|
    puts "Working on #{ row }"

    props = {
      faculty_number: row.fetch('faculty_number').strip,
      full_name:      row.fetch('name').strip,
    }

    if User.exists?(props)
      puts "User exists: #{ props.inspect }"
      next
    end

    SignUp.find_or_create_by!(props)
  end
end
