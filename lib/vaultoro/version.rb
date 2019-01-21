module Vaultoro
  module VERSION
    MAJOR = 0
    MINOR = 1
    TINY  = 0
    PRE   = nil
    STRING = [MAJOR, MINOR, TINY, PRE].compact.join('.')
    SUMMARY = "Vaultoro Ruby Gem v#{STRING}"
    DESCRIPTION = "A ruby API client for vaultoro.com, a global bitcoin and physical gold exchange."
  end
end
