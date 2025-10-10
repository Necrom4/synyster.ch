ips = Ahoy::Visit::FILTERED_IPS
countries = Ahoy::Visit::FILTERED_COUNTRIES
urls = Ahoy::Visit::FILTERED_URLS
hostname_keywords = Ahoy::Visit::FILTERED_HOSTNAME_KEYWORDS
organization_keywords = Ahoy::Visit::FILTERED_ORGANIZATION_KEYWORDS
user_agent_keywords = Ahoy::Visit::FILTERED_USER_AGENT_KEYWORDS

sql_file = Rails.root.join("tmp/filters.sql")
File.write(sql_file, <<~SQL)
  WITH filters AS (
    SELECT
      ARRAY[#{ips.map { |ip| "'#{ip}'" }.join(", ")}] AS ips,
      ARRAY[#{countries.map { |c| "'#{c}'" }.join(", ")}] AS countries,
      ARRAY[#{urls.map { |u| "'#{u}'" }.join(", ")}] AS landing_pages,
      ARRAY[#{hostname_keywords.map { |k| "'#{k}'" }.join(", ")}] AS platform_keywords,
      ARRAY[#{organization_keywords.map { |k| "'#{k}'" }.join(", ")}] AS organization_keywords,
      ARRAY[#{user_agent_keywords.map { |k| "'#{k}'" }.join(", ")}] AS user_agent_keywords
  )
SQL

puts "Filters exported to #{sql_file}"
