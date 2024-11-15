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

	def pictures
		image_paths = Dir.glob(Rails.root.join("app/assets/images/pictures/*.{JPG,jpg,jpeg,png,gif}"))
		image_paths.map do |image_path|
			{ image_path: "pictures/#{File.basename(image_path)}" }
		end
	end
end
