module AboutHelper
	def band_members
		[
			{
				name: "Diogo Pombeiro",
				web_url: "https://www.instagram.com/necrom_dp",
				image_path: "about/Diogo.jpg",
				role: "Guitar"
			},
			{
				name: "Antoine Borcard",
				web_url: "https://www.instagram.com/antbor.s",
				image_path: "about/Antoine.jpg",
				role: "Bass"
			},
			{
				name: "Samuel Bielmann",
				web_url: "https://www.instagram.com/sam_blmn",
				image_path: "about/Samuel3.jpg",
				role: "Vocals"
			},
			{
				name: "Simone Dal Molin",
				web_url: "https://www.instagram.com/simd.al08",
				image_path: "about/Simone.jpg",
				role: "Drums"
			},
			{
				name: "Rémi Castella",
				web_url: "https://www.instagram.com/remi.castella",
				image_path: "about/Rémi.jpg",
				role: "Guitar"
			}
		]
	end

	def first_name(n)
		n.split(" ").first
	end

	def last_name(n)
		n.split(" ")[1..].join(" ").upcase
	end
end
