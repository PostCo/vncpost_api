require "zeitwerk"

loader = Zeitwerk::Loader.for_gem
loader.inflector.inflect(
  "vncpost_api" => "VNCPostAPI"
)
loader.collapse("./lib/vncpost_api/resources")
loader.ignore("#{__dir__}/config.rb")
loader.enable_reloading
# loader.log!
loader.setup

$__vncpost_api_loader__ = loader

def reload!
  $__vncpost_api_loader__.reload
  set_config
  true
end
