class Student
  attr_reader :id, :name, :age, :squad_id, :spirit_animal
  attr_accessor :name, :mascot
  
  def initialize params, existing=false
    @id = params["id"]
    @name = params["name"]
    @age = params["age"]
    @squad_id = params["squad_id"]
    @animal = params["spirit_animal"]
    @existing = existing
  end

  def existing?
    @existing
  end

  def self.conn= connection
    @conn = connection
  end

  def self.conn
    @conn
  end

  def self.find id, squad_id
    new @conn.exec('SELECT * FROM students WHERE id = $1 AND squad_id = $2', [ id, squad_id ] )[0], true
  end

  def save name, age, spirit_animal, squad_id
    if existing?
      Student.conn.exec('UPDATE students SET name=$1, age=$2, spirit_animal=$3, squad_id=$4 WHERE id = $5', [ name, age, spirit_animal, squad_id ] )
    else
      Student.conn.exec('INSERT INTO students (name, age, spirit_animal, squad_id) values ($1, $2, $3, $4)', [ name, age, spirit_animal, squad_id ] )
    end
  end

  def self.create params
    new(params).save
  end 

end
