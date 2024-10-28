import Config

config :new_relic_agent,
  app_name: System.get_env("NEW_RELIC_APP_NAME") || "Default App Name",
  license_key: System.get_env("NEW_RELIC_LICENSE_KEY") || "default_license_key"
