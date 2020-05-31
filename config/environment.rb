# Load the Rails application.
require_relative 'application'

# Ensure there is no accidental conversion to ascii-8bit
Encoding.default_external = Encoding::UTF_8
Encoding.default_internal = Encoding::UTF_8

# Initialize the Rails application.
Rails.application.initialize!
