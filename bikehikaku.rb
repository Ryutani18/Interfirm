#インターンの課題
#JSON

require 'net/http'
require 'uri'
require 'json'

uri = URI('https://www.bikehikaku.com/api/v1/prefectures')
json = Net::HTTP.get(uri)
result = JSON.parse(json)
puts result["prefectures"]

puts "\n都道府県を入力してください"
input = gets.chomp
id = Integer
result["prefectures"].each do |prefecture|
    if prefecture["name"] == input
        id = prefecture["id"]
    end
end

uri = URI("https://www.bikehikaku.com/api/v1/cities?prefecture_id=#{id}")
json = Net::HTTP.get(uri)
result = JSON.parse(json)
puts result["cities"]

puts "\n市区を入力してください"
input = gets.chomp
id = Integer
result["cities"].each do |city|
    if city["name"] == input
        id = city["id"]
    end
end

uri = URI("https://www.bikehikaku.com/api/v1/towns?city_id=#{id}")
json = Net::HTTP.get(uri)
result = JSON.parse(json)
puts result["towns"]

puts "\n町村を入力してください"
input = gets.chomp
postal_code = Array.new
result["towns"].each do |town|
    if town["name"] == input
        postal_code.append(town["postal_code"])
    end
end

postal_code.each do |i|
    i.insert(3, "-")
    puts "郵便番号は〒#{i}です"
end