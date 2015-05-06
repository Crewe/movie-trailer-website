-- Table definitions for the tournament project.
--
-- Put your SQL 'create table' statements in this file; also 'create view'
-- statements if you choose to use it.
--
-- You can write comments in this file by starting them with two dashes, like
-- these lines here.

\c vagrant

DROP DATABASE IF EXISTS tournament;
CREATE DATABASE tournament;

\c tournament

-- Drop all the tables if they exist (ORDER MATTERS!)
DROP VIEW player_standings;
DROP TABLE IF EXISTS events;
DROP TABLE IF EXISTS matches;
DROP TABLE IF EXISTS players;

-- 
CREATE TABLE events (
	event_id SERIAL PRIMARY KEY,
	event_name TEXT NOT NULL
);

-- 
CREATE TABLE players (
	player_id SERIAL PRIMARY KEY,
	event_id INTEGER NOT NULL,
	player_name TEXT NOT NULL,
	FOREIGN KEY (event_id) REFERENCES events(event_id) ON DELETE CASCADE
);

-- TODO: Insure that both players are in the same event on INSERT
CREATE TABLE matches (
	match_id SERIAL PRIMARY KEY,
	event_id INTEGER NOT NULL,
	player_id_A INTEGER NOT NULL,
	player_id_B INTEGER NOT NULL,
	tie BOOLEAN DEFAULT FALSE,
	FOREIGN KEY (player_id_A) REFERENCES players(player_id),
	FOREIGN KEY (player_id_B) REFERENCES players(player_id),
	FOREIGN KEY (event_id) REFERENCES events(event_id) ON DELETE CASCADE
);


CREATE VIEW player_standings AS
SELECT t.event_id, t.player_id, t.player_name, t.wins, t.losses, t.matches 
FROM (
	SELECT p.event_id as event_id
       , p.player_id AS player_id
       , p.player_name AS player_name
       , COUNT(m.player_id_a) AS wins
       , (SELECT COUNT(*) 
          FROM matches mc
          WHERE 
              mc.match_id = NULL
              AND player_id = mc.player_id_a
              OR player_id = mc.player_id_b
         ) AS losses -- Not too sure why this works but it does...
       , (SELECT COUNT(*) 
          FROM matches mc
          WHERE 
              mc.event_id = event_id
              AND player_id = mc.player_id_a
              OR player_id = mc.player_id_b
         ) AS matches 
	FROM events e
	INNER JOIN matches m ON e.event_id = m.event_id
	RIGHT JOIN players p ON p.player_id = m.player_id_a
	GROUP BY p.event_id, p.player_id
) AS t
GROUP BY t.event_id, t.wins, t.losses, t.matches, t.player_id, t.player_name
ORDER BY t.event_id, t.wins DESC, t.losses ASC;
