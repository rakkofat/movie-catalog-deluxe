SELECT a.name, m.name, c.character  FROM actors a
JOIN cast_members c ON a.id = c.actor_id
JOIN movies m ON c.movie_id = m.studio_id
WHERE a.id = 1
