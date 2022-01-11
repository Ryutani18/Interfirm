#インターンの課題
#nikkei新聞のスクレイピング

require 'net/http'
require 'uri'

loop {

  html = Net::HTTP.get(URI("https://www.nikkei.com"))

  re = Regexp.new(/<div class="k-header-hamburger-nav__expansion.+?for="k-expansion-panel.+?for="k-expansion-panel/)
  categories = html.scan(re)

  categories.uniq!

  categories.each_with_index do |category, i|
    re = Regexp.new(/<input class="k-expansion-panel__status" id="k-expansion-panel-(.+?)"/)
    category_name = category.scan(re)
    puts "#{i+1}. #{URI.decode_www_form_component(category_name[0][0])}"
  end

  puts "どのカテゴリーを参照しますか？（数字を入力してください）"
  input = gets.to_i

  if input == 00
    break
  end

  category_name = categories[input-1].scan(re)

  re = Regexp.new(/href="(https:\/\/.+?)"/)
  url = categories[input-1].scan(re)
  if url[0][0][url[0][0].length-1] != "/"
    url[0][0].concat("/")
  end

  category_html = Net::HTTP.get(URI(url[0][0]))

  case input
  when 2,8,12
    re = Regexp.new(/<a href="\/article\/.+<span.+?>(.+?)<\/span>/)
    m = category_html.scan(re)
  else
    re = Regexp.new(/<a class="k-card__block-link".+?<span class="k-v">(.+?)<\/span>/)
    m = category_html.scan(re)
  end

  num = m.size/10.to_f
  puts num
  num = num.ceil
  puts "【#{URI.decode_www_form_component(category_name[0][0])}】"
  num.times do |i|
    10.times do |n|
      puts m[i*10+n]
    end
    gets
  end

}