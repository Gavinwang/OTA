# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_HE_session',
  :secret      => '4fd5fd5a3b0a2a9541e9894f6adfc0b63f14519c5e287b674f143dfdffd9a07fb5d9390bf3ff269e9800a621f21d453587601aae50cc0eb74d2edf3de2348542'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
