module ApplicationHelper

	def placeholder_tag(path, options = {})
		image_tag "#{settings.placeholders_dir}/#{path}", options
	end

end