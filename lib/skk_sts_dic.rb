require "bundler/setup"

require "json"
require "kconv"
require "natto"
require "nkf"
require "pathname"

require "zeitwerk"
loader = Zeitwerk::Loader.for_gem
loader.setup

module SkkStsDic
end
