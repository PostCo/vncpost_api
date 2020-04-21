require "zeitwerk"
require_relative "config"

loader = Zeitwerk::Loader.for_gem
loader.inflector.inflect(
  "vncpost_api" => "VNCPostAPI"
)
loader.push_dir("./lib")
loader.collapse("./lib/vncpost_api/resources")
loader.ignore("#{__dir__}/config.rb")
loader.ignore("./lib/vncpost_api/exceptions.rb")
loader.enable_reloading
# loader.log!
loader.setup

$__vncpost_api_loader__ = loader

def reload!
  $__vncpost_api_loader__.reload
  set_config
  true
end
