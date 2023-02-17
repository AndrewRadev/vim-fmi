require 'csv'

desc "Import students from students.csv"
task import_students: :environment do
  path = Rails.root.join('students.csv').to_s

  CSV.foreach(path, headers: true) do |row|
    SignUp.create!({
      faculty_number: row.fetch('faculty_number'),
      full_name:      row.fetch('name'),
    })
  end
end
