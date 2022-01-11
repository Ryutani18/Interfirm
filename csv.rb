#インターンの課題
#連絡帳

require "csv"

array = []

CSV.foreach("data.csv") do |row|
    array << row
end

data = Array.new

array.each do |i|
    hash = Hash.new
    hash[array[0][0]] = i[0]
    hash[array[0][1]] = i[1]
    hash[array[0][2]] = i[2]
    data << hash
end

puts data

CSV.open("data.csv", "w") do |row|
    data.each do |i|
        row << [i["name"],i["mail"],i["phone"]]
    end
end
