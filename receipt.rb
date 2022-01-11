#レシート管理アプリ

#機能の追加

require "csv"
require "date"


array = []
year = []
category = []
today = Date.today


CSV.foreach("receipt.csv", headers: true) do |row|
    array << row.to_h
end


array.each do |i|
    year << i["year"].to_i
end
year = year.uniq


array.each do |i|
    category << i["category"]
end
category = category.uniq


def price_sum(array, m, y)
    price_sum = 0
    array.each do |i|
        if i["month"].to_i == m && i["year"].to_i == y
                price_sum += i["price"].to_i
        end
    end
    return price_sum
end


def price_sum_of_category(array, m, y, c)
    price_sum = 0
    array.each do |i|
        if i["month"].to_i == m && i["year"].to_i == y && i["category"] == c
                price_sum += i["price"].to_i
        end
    end
    return price_sum
end


loop{

    puts "\n---------------------"
    puts "レシート管理アプリ"
    puts "---------------------"

    puts "\n【#{today.year}年#{today.month}月】"
    total = 0
    category.each do |i|
        a = price_sum_of_category(array, today.month, today.year, i)
        puts "#{i}：#{a}円"
        total += a
    end
    puts "合計：#{total}円"

    puts "\n好きな機能をお選びください"
    puts "1 => レシートの管理"
    puts "2 => 年月カテゴリー別出費額の参照"
    puts "3 => 家計簿カレンダー"
    puts "4 => プログラムの終了"

    input = gets.to_i

    case input
    when 1
        puts "\n---------------------"
        puts "レシートの管理"
        puts "---------------------"
        puts "どの機能を使いますか?"
        puts "1 => レシートの追加"
        puts "2 => レシートの参照"
        puts "3 => レシートの編集"
        puts "4 => レシートの削除"
        puts "5 => メニューに戻る"

        input = gets.to_i

        case input
        when 1
            puts "カテゴリーをお選びください"
            
        when 2
        when 3
        when 4
        when 5
            puts "メニューに戻ります"
        else
            puts "入力が正しくありません"
        end
        
    when 2
        puts "\n---------------------"
        puts "年月カテゴリー別出費額の参照"
        puts "---------------------"
        puts "参照したい年をお選びください"
        year.each_with_index do |n, i|
            puts "#{i+1}. #{n}年"
        end
        input_year = gets.to_i

        if (1..year.size).to_a.include?(input_year)

            puts "参照したい月をお選びください"
            (1..12).each do |i|
                puts "#{i}. #{i}月"
            end
            input_month = gets.to_i

            if (1..12).to_a.include?(input_month)

                total = 0
                puts "\n【#{year[input_year-1]}年#{input_month}月】"
                category.each do |i|
                    a = price_sum_of_category(array, input_month, year[input_year-1], i)
                    puts "#{i}：#{a}円"
                    total += a
                end
                puts "合計：#{total}円"
            else
                puts "入力が正しくありません"
            end
        else
            puts "入力が正しくありません"
        end
    when 3
        puts "\n---------------------"
        puts "家計簿カレンダー"
        puts "---------------------"
        puts "参照したい年をお選びください"
        #puts "1 => 年"
        #puts "2 => 月"
        #puts "3 => 週"
        #puts "4 => 日"

        year.each_with_index do |n, i|
            puts "#{i+1}. #{n}年"
        end
    
        input_year = gets.to_i

        if (1..year.size).to_a.include?(input_year)
        
            puts "\n---------------------"
            puts "#{year[input_year-1]}年月別合計出費額リスト"
            puts "---------------------"
            
            (1..12).each do |i|
                a = price_sum(array, i, year[input_year-1])
                puts "#{i}月:合計出費額は#{a}円です"
            end
        else
            puts "入力が正しくありません"
        end
    when 4
        puts "\nプログラムを終了します"
        break
    else
        puts "入力が正しくありません"
    end
    gets
}

#一日の合計出費額

#一週間の合計＆平均出費額

#一ヶ月の合計＆平均出費額

#一年の合計＆平均出費額


CSV.open("receipt.csv", "w") do |row|
    row << ["year","month","day","price","name","category"]
    array.each do |i|
        row << [i["year"], i["month"], i["day"], i["price"], i["name"], i["category"]]
    end
end