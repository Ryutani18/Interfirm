#インターンの課題
#クックパッドのレシピをJSONファイルにデータを保存

require "uri"
require "net/http"
require "json"

json = Hash.new
recipes = Array.new

(1..10).each do |i|
    uri = URI("https://cookpad.com/category/177?page=#{i}")
    html = Net::HTTP.get(uri)
    re = Regexp.new(/"recipe-title font13 ".+>(.+)<\/a>/)
    names = html.scan(re)
    re = Regexp.new(/id="recipe_title_(.+)" href="\/recipe/)
    ids = html.scan(re)

    names.zip(ids) do |name,id|
        hash = Hash.new
        hash["name"] = URI.decode_www_form_component(name[0])
        hash["id"] = URI.decode_www_form_component(id[0])

        recipe_html = Net::HTTP.get(URI("https://cookpad.com/recipe/#{URI.decode_www_form_component(id[0])}"))

        re = Regexp.new(/(<div class='ingredient_name'>.+)/)
        ingredient_name = recipe_html.scan(re)
        re = Regexp.new(/ingredient_quantity amount.+>(.+)<\/div>/)
        ingredient_quantity = recipe_html.scan(re)

        ingredients_array = Array.new
        ingredient_name.zip(ingredient_quantity) do |n,q|
            ingredients = Hash.new
            ingredients["name"] = URI.decode_www_form_component(n[0].gsub(%r{</?[^>]+?>},''))
            ingredients["quantity"] = URI.decode_www_form_component(q[0])
            ingredients_array << ingredients
        end
        hash["ingredients"] = ingredients_array

        re = Regexp.new(/(<p class='step_text'[\s\S]*?<\/p>)/)
        step_list = recipe_html.scan(re)

        steps_array = Array.new
        step_list.each_with_index do |s,i|
            steps = Hash.new
            steps["order"] = i+1
            steps["text"] = URI.decode_www_form_component(s[0].gsub(%r{</?[^>]+?>|\n},''))
            steps_array << steps
        end
        hash["steps"] = steps_array

        recipes << hash
    end
end

json["recipes"] = recipes

File.open("cookpad.json","w") do |file| 
    file.puts json
end