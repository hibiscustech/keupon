# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_keupon_session',
  :secret      => '750bd971c1eeea886f64ff2d5d6f39e5843354d7f54cae10a356ebb04ed4f98d4f493d7c5d242c3d612b3f7934defc8c1e7347cfb796e0004f6e37ae8c626635'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
