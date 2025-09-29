FactoryBot.define do
  factory :ahoy_visit, class: "Ahoy::Visit" do
    ip { "37.167.76.48" }
    country { "FR" }
    landing_page { "https://synyster.ch/" }
    platform { "coucou-networks.fr" }
    user_agent { "Mozilla/5.0 (Linux; Android 12; SM-G990B Build/SP1A.210812.016; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/140.0.7339.51 Mobile Safari/537.36 Instagram 389.0.0.49.87 Android (31/12; 480dpi; 1080x2097; samsung; SM-G990B; r9q; qcom; fr_FR; 763654699; IABMV/1)" }
    utm_campaign { "AS51207 Free Mobile SAS" }

    trait :bot_user_agent do
      user_agent { "Mozilla/5.0 (compatible; AhrefsBot/7.0; +http://ahrefs.com/robot/)" }
    end

    trait :filtered_ip do
      ip { "139.99.241.181" }
    end

    trait :filtered_country do
      country { "RU" }
    end

    trait :filtered_landing_page do
      landing_page { "https://synyster-website.onrender.com/" }
    end

    trait :filtered_hostname do
      platform { "cache.google.com" }
    end

    trait :filtered_user_agent do
      user_agent { "chrome/125.0.6422.41" }
    end

    trait :filtered_organization_name do
      utm_campaign { "smartnet limited" }
    end
  end
end
