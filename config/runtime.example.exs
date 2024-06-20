import Config

config :bot,
  guild_ids: ["id"]



config :nostrum,
  token: "",
  gateway_intents: [
    :direct_messages,
    :guild_members,
    :guild_message_reactions,
    :guild_messages,
    :guild_presences,
    :guild_voice_states,
    :guilds
  ]

# requires dir for ytdlp
config :nostrum, :youtubedl, "dir"

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  level: :info
