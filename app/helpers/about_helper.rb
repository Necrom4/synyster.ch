module AboutHelper
  def first_name(n)
    n.split(" ").first
  end

  def last_name(n)
    n.split[1..].join(" ").upcase
  end

  def shortened_last_name(n)
    n.split.last.first.upcase + "."
  end
  # def shortened_last_name(n)
  # 	n.split[1..]&.map { |word| "#{word.first.upcase}." }&.join
  # end
end
