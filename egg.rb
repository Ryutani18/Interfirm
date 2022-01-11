#インターンの課題
#献立アプリ

require 'net/http'
require 'uri'

loop {

    puts "食材を入力してください。"
    puts "(入力が終わったらEnterを入力してください)"

    array = Array.new

    loop {
        x = gets.chomp
        if x == ""
            break
        else
            array << x
        end
    }

    if array.size == 0
        break
    end

    str = array.join(" ")
    enc = URI.encode_www_form_component(str)
    html = Net::HTTP.get(URI("https://cookpad.com/search/#{enc}"))

    re = Regexp.new(/"recipe-title font13 ".+>(.+)<\/a>/)

    # m = re.match(html)
    recipes = html.scan(re)

    puts recipes.size
    
    if recipes.size == 0
        puts "料理を検索しています..."
        puts "-----------------"
        puts "検索結果がありませんでした"
        puts "-----------------"
        gets
        next
    else
        puts "料理を検索しています..."
        puts "-----------------"
        puts "以下の結果が検出されました。"
    end

    loop {
        puts "-----------------"
        recipes.each_with_index do |recipe,i|
            puts "#{i+1}. #{URI.decode_www_form_component(recipe[0])}"
        end
        puts "どのレシピを参照しますか？"
        input = gets.chomp
        if input == ""
            break
        else
            input = input.to_i
            if 1 <= input && input <= recipes.size
                puts "【#{URI.decode_www_form_component(recipes[input-1][0])}】"

                #選んだレシピのurl_idを取得
                re = Regexp.new(/id="recipe_title_(.+)" href="\/recipe/)
                id = html.scan(re)

                #選んだレシピのhtml
                recipe_html = Net::HTTP.get(URI("https://cookpad.com/recipe/#{id[input-1][0].to_i}"))

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