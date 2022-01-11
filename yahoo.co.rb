#yahoo.co.jpのスクレイピング
#自作ブラウザ

require 'net/http'
require 'uri'

puts "検索したいワードを入力してください"
input = gets.chomp
enc = URI.encode_www_form_component(input)

html = Net::HTTP.get(URI("https://search.yahoo.co.jp/search?p=#{enc}"))

re = Regexp.new(/https%3A\/\/search.yahoo.co.jp\/clear.gif">(.+?)<\/a>/)

names = html.scan(re)

names.each_with_index do |name, i|
  puts "#{i+1}.#{URI.decode_www_form_component(name[0].gsub(%r{</?[^>]+?>},''))}"
end
