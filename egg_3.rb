#インターンの課題
#献立アプリ／強化版

require 'net/http'
require 'uri'

loop {

    condiments = Array.new
    
    puts "\n---------------------"
    puts "献立アプリ"
    puts "---------------------"

    puts "\n好きな機能をお選びください"
    puts "\n1 => 食材の入力"
    puts "2 => "
    puts "3 => 調味料の設定 "
    puts "4 => プログラムの終了"

    input = gets.to_i

    case input
    when 1
        loop {

            puts "食材を入力してください。"
            puts "(入力が終わったらEnterを入力してください)"
        
            foods = Array.new
        
            loop {
                x = gets.chomp
                if x == ""
                    break
                else
                    foods << x
                end
            }
        
            if foods.size == 0
                break
            end
        
            str = foods.join(" ")
            enc = URI.encode_www_form_component(str)
            html = Net::HTTP.get(URI("https://cookpad.com/search/#{enc}"))

            condiments.each do |condiment|
                foods << condiment
            end
        
            re = Regexp.new(/"recipe-title font13 ".+>(.+)<\/a>/)
            m = html.scan(re)
        
            recipes = Array.new
        
            m.each do |n|
                recipes << URI.decode_www_form_component(n[0])
            end
        
            hash = Hash.new
        
            recipes.each_with_index do |recipe,i|
        
                ingredients = Array.new
                extra = 0
        
                re = Regexp.new(/id="recipe_title_(.+)" href="\/recipe/)
                id = html.scan(re)
        
                recipe_html = Net::HTTP.get(URI("https://cookpad.com/recipe/#{id[i][0].to_i}"))
        
                re = Regexp.new(/(<div class='ingredient_name'>.+)/)
                ingredient_name = recipe_html.scan(re)
        
                ingredient_name.each do |i|
                    ingredients << URI.decode_www_form_component(i[0].gsub(%r{</?[^>]+?>},''))
                end
        
                ingredients.each do |ingredient|
                    if foods.include?(ingredient) == false
                        extra += 1
                    end
                end
        
                hash[recipe] = extra
            end
        
            ranking = hash.sort {|(k1, v1), (k2, v2)| v1 <=> v2 }
        
            puts "料理を検索しています..."
            puts "-----------------"
            puts "以下の結果が検出されました。"
        
            loop {
                puts "-----------------"
                ranking.each_with_index do |r,i|
                    puts "#{i+1}. #{r[0]}（それ以外の材料：#{r[1]}）"
                end
                puts "どのレシピを参照しますか？"
                input = gets.chomp
                if input == ""
                    break
                else
                    input = input.to_i
                    if 1 <= input && input <= ranking.size
                        puts "【#{ranking[input-1][0]}】"
        
                        num = 0
        
                        recipes.each_with_index do |recipe,i|
                            if ranking[input-1][0] == recipe
                                num = i
                            end
                        end
        
                        #選んだレシピのurl_idを取得
                        re = Regexp.new(/id="recipe_title_(.+)" href="\/recipe/)
                        id = html.scan(re)
        
                        #選んだレシピのhtml
                        recipe_html = Net::HTTP.get(URI("https://cookpad.com/recipe/#{id[num][0].to_i}"))
        
                        #材料を表示する
                        puts "\n-----------------"
                        puts "材料（戻る：backと入力してください）"
                        puts "-----------------"
        
                        re = Regexp.new(/(<div class='ingredient_name'>.+)/)
                        ingredient_name = recipe_html.scan(re)
        
                        re = Regexp.new(/ingredient_quantity amount.+>(.+)<\/div>/)
                        ingredient_quantity = recipe_html.scan(re)
                        
                        ingredient_name.zip(ingredient_quantity) do |n,q|
                            puts "#{URI.decode_www_form_component(n[0].gsub(%r{</?[^>]+?>},''))}【#{URI.decode_www_form_component(q[0])}】"
                        end
                        input = gets.chomp
                        if input == "back"
                            next
                        else
                            #作り方を表示する
                            puts "\n-----------------"
                            puts "作り方（戻る：backと入力してください）"
                            puts "-----------------"
        
                            re = Regexp.new(/(<p class='step_text'[\s\S]*?<\/p>)/)
                            step_text = recipe_html.scan(re)
        
                            step_text.each_with_index do |s,i|
                                puts "#{i+1}. #{URI.decode_www_form_component(s[0].gsub(%r{</?[^>]+?>|\n},''))}"
                            end
                            input = gets.chomp
                            if input == "back"
                                next
                            else
                                break
                            end
                        end
                    else
                        puts "入力が正しくありません"
                        gets
                    end
                end
            }
        } 

    when 2

    when 3
        puts "---------------------"
        puts "調味料の設定"
        puts "---------------------"
        loop {
            puts "家にある調味料を入力してください（戻る：backと入力してください）"
            input = gets.chomp
            if input == "back"
                break
            elsif input == ""
                puts "入力が正しくありません"
                gets
            else
                puts "調味料リストに追加しました"
                condiments << input
                gets
            end
        }
    when 4
        puts "\nプログラムを終了します"
        break
    else
        puts "入力が正しくありません"
    end
    gets

}