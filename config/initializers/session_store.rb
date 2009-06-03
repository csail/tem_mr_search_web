# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_tem_mr_search_web_session',
  :secret      => '5241a9c91aebd0d8d09005a63ebd3ae91ab16eeb4ae2b61bb029c1f82125bbc0eb6377b82708b124f301066fbb89c9306ca0414499c441e0514e83e29ecfeb8e'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
