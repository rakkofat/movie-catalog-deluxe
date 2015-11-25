class Butler

  def db_connection
    begin
      connection = PG.connect(Sinatra::Application.db_config)
      yield(connection)
    ensure
      connection.close
    end
  end

  def fetch(sql_query)
    db_connection { |conn| conn.exec(sql_query) }
  end

  def stow(sql_query, data)
    db_connection { |conn| conn.exec_params(sql_query, data) }
  end

end
