SELECT a.name, m.name, c.character  FROM actors a
JOIN cast_members c ON a.id = c.actor_id
JOIN movies m ON c.movie_id = m.studio_id
WHERE a.id = 1


sql_query = %Q(
  SELECT a.name AS actor, m.title AS movie, c.character AS character
  FROM actors a
  JOIN cast_members c ON a.id = c.actor_id
  JOIN movies m ON c.movie_id = m.studio_id
  WHERE a.id = #{params[:id]})

SELECT name FROM actors WHERE id = #{params[:id]}

SELECT a.name AS actor, c.character AS role FROM actors a
  JOIN cast_members c ON a.id = c.actor_id
  JOIN movies m ON c.movie_id = m.id
  WHERE a.id = paramsid

  SELECT a.name, c.character
  FROM actors a
  LEFT JOIN cast_members c ON a.id = c.actor_id
  WHERE a.id = #{params[:id]}
  )
