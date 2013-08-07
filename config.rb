###
# Haml
###

# Use double quotes rather than single quotes on HTML attributes; HTML5 syntax
# See http://haml.info/docs/yardoc/Haml/Options.html
set :haml, {:attr_wrapper => '"', :format => :html5}


###
# Compass
###

compass_config do |config|
	config.output_style = :compact

	# Example: Add additional paths to look for sprite images
	#config.sprite_load_path = ['source/assets/modules/', 'source/assets/vendor/']
end


###
# Helpers
###

# Load helpers
require 'helpers/application_helper'
helpers ApplicationHelper

# Set options for helper "placeholder_tag" (usage like "image_tag")
set :placeholders_dir, "/tmp/media"


###
# Asset pipeline
###

require 'uglifier'

set :css_dir, 'assets/css'
set :sass_assets_paths, ['modules', 'assets/vendor']
set :js_dir, 'assets/js'
set :images_dir, 'assets/media'

after_configuration do
	sprockets.append_path "modules"
	sprockets.append_path "assets/vendor"
end

# Simulate production environment
# activate :minify_css
# activate :minify_javascript, :compressor => Uglifier.new({
# 	# See https://github.com/lautis/uglifier#usage
# })
activate :relative_assets


###
# Build configuration
###

configure :build do
	# Simulate production environment
	activate :minify_css
	activate :minify_javascript, :compressor => Uglifier.new({
		# See https://github.com/lautis/uglifier#usage
	})

	# Example: exclude complete plugin
	#ignore "assets/vendor/fancybox/*"
end