#youtube動画、タイトルのスクレイピング

require 'net/http'
require 'uri'
require 'csv'

favorite = []

CSV.foreach("favorite.csv") do |row|
    favorite = row
end

loop {

    puts "検索したいワードを入力してください"

    input = gets.chomp

    if input != ""
        enc = URI.encode_www_form_component(input)
        html = Net::HTTP.get(URI("https://www.youtube.com/results?search_query=#{enc}"))

        re = Regexp.new(/"url":"https:\/\/i.ytimg.com.+?"title":{"runs":\[{"text":"(.+?)"}\],"accessibility"/)
        m = html.scan(re)

        puts "動画を検索しています..."
        puts "-----------------"
        puts "以下の結果が検出されました。"
        puts "-----------------"

        num = m.size/10.to_f
        num = num.ceil
        num.times do |i|
            10.times do |n|
                puts m[i*10+n]
            end
            gets
        end

        puts "検索したワードをお気に入りに追加しますか？"
        puts "1 => はい"
        puts "2 => いいえ"
        yes_or_no = gets.to_i
        if yes_or_no == 1
            favorite << input
            puts "検索ワードをお気に入りに追加しました"
            p favorite
            gets
        else
            puts "\n"
        end
    else
        break
    end
}

p favorite
puts "\n"

CSV.open("favorite.csv", "w") do |row|
    row << favorite
end