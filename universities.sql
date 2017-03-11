  CREATE TABLE universities(
   id INTEGER PRIMARY KEY,
   name STRING
 );

  CREATE TABLE schools(
   id INTEGER PRIMARY KEY,
   name STRING,
   university_id INTEGER,
   FOREIGN KEY (university_id) REFERENCES university(id)
 );

  CREATE TABLE students(
   id INTEGER PRIMARY KEY,
   name STRING,
   school_id INTEGER,
   FOREIGN KEY (school_id) REFERENCES school(id)
 );


  INSERT INTO
    universities (id, name)
  VALUES
    (1, "Rutgers University"), (2, "New York University");

  INSERT INTO
    schools (id, name, university_id)
  VALUES
    (1, "School of Arts and Sciences", 1),
    (2, "School of Environmental and Biological Sciences", 1),
    (3, "Tandon School of Engineering", 2),
    (4, "College of Global Public Health", 2);

  INSERT INTO
    students (id, name, school_id)
  VALUES
    (1, "Melanie", 1),
    (2, "Paul", 1),
    (3, "Tobias", 2),
    (4, "Enrique", 2),
    (5, "Alexa", 3),
    (6, "Dave", 3),
    (7, "Mia", 4),
    (8, "Julia", 4);
