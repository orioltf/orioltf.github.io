
###
# Haml
###

# Use double quotes rather than single quotes on HTML attributes; HTML5 syntax
# See http://haml.info/docs/yardoc/Haml/Options.html
set :haml, {:attr_wrapper => '"', :format => :html5}




###
# Markdown
###

# set :markdown_engine, :redcarpet
# set :markdown,  :fenced_code_blocks=>true,
# 				:autolink=>true,
# 				:smartypants=>true
# Kramdown seems to play nicer with Rouge for syntax highlighting
set :markdown_engine, :kramdown
set :markdown, :layout_engine => :haml,
				:tables => true,
				:autolink => true,
				:smartypants => true,
				:fenced_code_blocks=>true




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




###
# Blog settings
###

Time.zone = "Europe/Berlin"

activate :blog do |blog|
	# set options on blog
	blog.prefix = "blog"
	blog.layout = "blog"
	blog.permalink = ":year/:month/:day/:title.html"

	# blog.sources = ":year-:month-:day-:title.html"

	# blog.tag_template = "tag.html"
	# blog.taglink = "tags/:tag.html"

	# blog.calendar_template = "calendar.html"
	# blog.year_link = ":year.html"
	# blog.month_link = ":year/:month.html"
	# blog.day_link = ":year/:month/:day.html"

	# blog.summary_separator = /(READMORE)/
	# blog.summary_length = 250

	# blog.default_extension = ".markdown.erb"

	# blog.paginate = true
	# blog.per_page = 10
	# blog.page_link = "page/:num"
end

# page "/sitemap.xml", :layout => false
# page "/feed.atom",   :layout => false




# Wanted relative assets
activate :relative_assets

# Quicker development
activate :livereload

# Get pretty URLs
activate :directory_indexes

# Code highlighting
# This was for Pygments
# activate :syntax, lineanchors: 'line'
# This is for Rouge
activate :syntax, line_numbers: true




###
# Build configuration
###

configure :build do
	# Simulate production environment
	activate :minify_css
	activate :minify_javascript, :compressor => Uglifier.new({
		# See https://github.com/lautis/uglifier#usage
	})

	# Enable cache buster
	activate :cache_buster

	# Use relative URLs
	activate :relative_assets
	set :relative_links, true

	# Compress PNGs after build
	# First: gem install middleman-smusher
	# require "middleman-smusher"
	# activate :smusher

	# Or use a different image path
	# set :http_path, "/img/"

	# Example: exclude complete plugin
	#ignore "assets/vendor/fancybox/*"
end




###
# Deploy configuration
# To deploy to a remote branch via git (e.g. master on github):
###

# require 'middleman-gh-pages'

activate :deploy do |deploy|
	deploy.method = :git
	deploy.build_before = true # default: false
	deploy.branch = "master"
end
