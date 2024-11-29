import Config

config :elixir, :time_zone_database, Tz.TimeZoneDatabase

config :aoc,
  year: 2024,
  allow_network?: false,
  session_cookie: System.get_env("ADVENT_OF_CODE_SESSION_COOKIE")
