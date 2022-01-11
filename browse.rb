#Googleのスクレイピング
#自作ブラウザ

require 'net/http'
require 'uri'
require 'cgi'

loop {

  puts "検索したいワードを入力してください"
  input = gets.chomp
  enc = URI.encode_www_form_component(input)

  html = Net::HTTP.get(URI("https://www.google.com/search?q=#{enc}"))

  re = Regexp.new(/<div class="BNeawe vvjwJb AP7Wnd">(.+?)<\/div>/)

  names = html.scan(re)

  names.each_with_index do |name, i|
    puts "#{i+1}.#{CGI.unescapeHTML("#{name[0]}")}"
  end

}
