str = "%25E3%2583%2589%25E3%2583%25AF%25E3%2583%25B3%25E3%2582%25B4%25E3%2583%25BB%25E3%2583%25A6%25E3%2583%25BC%25E3%2582%25B6%25E3%2583%25BC%25E3%2582%25A8%25E3%2583%25B3%25E3%2582%25BF%25E3%2583%2586%25E3%2582%25A4%25E3%2583%25B3%25E3%2583%25A1%25E3%2583%25B3%25E3%2583%2588"

num = str.length/5

num.times do |i|
  2.times { str.slice!(i*3+1) }
end

puts str