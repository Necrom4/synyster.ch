module HomeHelper
	def upcoming_shows
		[
			{
				image_path: "posters/Globull.jpg",
				web_url: "https://www.instagram.com/necrom_dp",
			},
			{
				image_path: "posters/Nouveau_Monde.jpg",
				web_url: "https://www.instagram.com/remi.castella",
			}
		]
	end

	def past_shows
		[
			{ image_path: "posters/Francos.jpg" },
			{ image_path: "posters/Rockies.jpg" },
			{ image_path: "posters/Qwertz.jpg" },
			{ image_path: "posters/Abyss.png" },
			{ image_path: "posters/MoB.jpg" }
		]
	end

	def videos
		[
			{ web_url: "https://www.youtube.com/embed/iQOOQ7KFmdE?si=MztkAcw3KF377-3T" },
			{ web_url: "https://www.youtube.com/embed/IOUMo9eb5gw?si=nfyRtDWbEBnBclSi" }
		]
	end

	def photos_gallery(directory = "pictures")
		containers = ["", "", ""]  # Initialize three containers as empty strings
		image_paths = Dir.glob(Rails.root.join("app/assets/images/#{directory}/*.{JPG,jpg,jpeg,png,gif}"))

		image_paths.each_with_index do |image_path, index|
			filename = File.basename(image_path)

			# Determine which container to use based on the index modulo 3
			container_index = index % 3

			# Append the image link and tag to the appropriate container
			containers[container_index] << content_tag(:a, href: image_path(directory + '/' + filename), data: { fancybox: "gallery" }) do
				image_tag(directory + '/' + filename, class: "w-100 mb-2")
			end
		end

		# Wrap each container in a div with `photos_container` class and concatenate into final HTML
		html = containers.map { |content| content_tag(:div, content.html_safe, class: "col px-1") }.join

		html.html_safe

	end
end
