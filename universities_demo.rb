require_relative 'lib/sql_object'
require 'pry'

DBConnection.sql_file_basename = 'universities.sql'

class University < SQLObject
  self.table_name = :universities
  has_many :schools
  finalize!
end

class School < SQLObject
  has_many :students
  belongs_to :university

  finalize!
end

class Student < SQLObject
  belongs_to :school
  has_one_through :university, :school
  finalize!
end

puts <<-EOF
Not sure where to start? Try these queries:

- University.all
- University.all.first.schools
- School.all
- School.all.last.students
- School.all.last.university
- School.find(2)
- Student.all.first.school
- Student.all.first.university
- Student.where(school_id: 3)
EOF

binding.pry(quiet: true)
