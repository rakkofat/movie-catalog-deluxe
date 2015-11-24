class Butler

  def initialize(db_name)
    @db_name = db_name
  end

  def db_connection
    begin
      connection = PG.connect(dbname: @db_name)
      yield(connection)
    ensure
      connection.close
    end
  end

  def read(sql_query)
    db_connection { |conn| conn.exec(sql_query) }
  end

  def create(sql_query, data)
    db_connection { |conn| conn.exec_params(sql_query, data) }
  end

end
