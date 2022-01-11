#インターンの課題
#連絡帳

array = []
bin = []
can = []

File.open("file") do |file|
    file.each_line do |i|
        array << i.chomp.split(":")
    end
end

loop {

    array = array.sort
    
    puts "\n連絡先の数：#{array.size}"
    puts "1 => 連絡先の参照"
    puts "2 => 連絡先の追加"
    puts "3 => 連絡先の変更"
    puts "4 => 連絡先の検索"
    puts "5 => 連絡先の削除"
    puts "6 => 操作の取り消し"
    puts "7 => 操作のやり直し"
    puts "8 => プログラムの終了"

    n = gets.chomp.to_i

    case n
    when 1
        puts "---------------------"
        puts "連絡先の参照"
        puts "---------------------"
        for data, i in array.each_with_index
            puts "#{i+1}. 名前:#{data[0]} メールアドレス:#{data[1]}"
        end
    when 2
        puts "---------------------"
        puts "連絡先の追加"
        puts "---------------------"
        a = Array.new
        puts "名前を入力してください"
        name = gets.chomp
        unless name == ""
            a << name
            puts "メールを入力してください"
            mail = gets.chomp
            if mail.include?("@")
                a << mail
                array << a
                puts "---------------------"
                puts "データを追加しました"
                puts "---------------------"
                bin << a
                bin << 2
            else
                puts "操作を実行できませんでした"
            end
        else
            puts "操作を実行できませんでした"
        end
    when 3
        puts "---------------------"
        puts "連絡先の変更"
        puts "---------------------"
        a = Array.new
        puts "どの連絡先を変更しますか?"
        for data, i in array.each_with_index
            puts "#{i+1} #{data[0]}:#{data[1]}"
        end
        num = gets.chomp.to_i
        p = (1..array.size).to_a
        if p.include?(num)
            puts "新たな名前を入力してください"
            name = gets.chomp
            unless name == ""
                a << name
                puts "新たなメールを入力してください"
                mail = gets.chomp
                if mail.include?("@")
                    a << mail
                    array << a
                    puts "---------------------"
                    puts "データを更新しました"
                    puts "---------------------"
                    bin << array[num-1]
                    bin << a
                    bin << 3
                    array.delete_at(num-1)
                else
                    puts "操作を実行できませんでした"
                end
            else
                puts "操作を実行できませんでした"
            end
        else
            puts "入力が正しくありません"
        end
    when 4
        puts "---------------------"
        puts "連絡先の検索"
        puts "---------------------"
        puts "検索したい名前を入力してください"
        name = gets.chomp
        count = 0
        array.each do |i|
            if i[0] == name
                count += 1
            end
        end
        puts "以下の結果が検索されました：#{count}件"
        if count > 0
            array.each do |i|
                if i[0] == name
                    puts ">>>#{i[1]}"
                end
            end
        else
            puts "検索に一致するメールアドレスは見つかりませんでした。"
        end
        count = 0
    when 5
        puts "---------------------"
        puts "連絡先の削除"
        puts "---------------------"
        puts "どの連絡先を削除しますか?"
        for data, i in array.each_with_index
            puts "#{i+1} #{data[0]}:#{data[1]}"
        end
        num = gets.chomp.to_i
        p = (1..array.size).to_a
        if p.include?(num)
            puts "---------------------"
            puts "データを削除しました"
            puts "---------------------"
            bin << array[num-1]
            bin << 5
            array.delete_at(num-1)
        else
            puts "操作を実行できませんでした"
        end
    when 6
        if bin.size > 0
            if bin[bin.size-1] == 2
                puts "#{bin[bin.size-2][0]}, #{bin[bin.size-2][1]}のデータの追加を取り消しました"
                array.delete(bin[bin.size-2])
                can << bin[bin.size-2]
                can << bin[bin.size-1]
                bin.delete_at(bin.size-2)
                bin.delete_at(bin.size-1)
            elsif bin[bin.size-1] == 3
                puts "データの変更を取り消しました"
                array.delete(bin[bin.size-2])
                array << bin[bin.size-3]
                can << bin[bin.size-3]
                can << bin[bin.size-2]
                can << bin[bin.size-1]
                bin.delete_at(bin.size-3)
                bin.delete_at(bin.size-2)
                bin.delete_at(bin.size-1)
            elsif bin[bin.size-1] == 5
                puts "#{bin[bin.size-2][0]}, #{bin[bin.size-2][1]}のデータを復元しました"
                array << bin[bin.size-2]
                can << bin[bin.size-2]
                can << bin[bin.size-1]
                bin.delete_at(bin.size-2)
                bin.delete_at(bin.size-1)
            end
        else
            puts "取り消す操作がありません"
        end
    when 7
        if can.size > 0
            if can[can.size-1] == 2
                puts "#{can[can.size-2][0]}, #{can[can.size-2][1]}のデータを追加し直しました"
                array << can[can.size-2]
                bin << can[can.size-2]
                bin << can[can.size-1]
                can.delete_at(can.size-2)
                can.delete_at(can.size-1)
            elsif can[can.size-1] == 3
                puts "データの変更をやり直しました"
                array << can[can.size-2]
                array.delete(can[can.size-3])
                bin << can[can.size-3]
                bin << can[can.size-2]
                bin << can[can.size-1]
                can.delete_at(can.size-3)
                can.delete_at(can.size-2)
                can.delete_at(can.size-1)
            elsif can[can.size-1] == 5
                puts "#{can[can.size-2][0]}, #{can[can.size-2][1]}のデータを削除しました"
                array.delete(can[can.size-2])
                bin << can[can.size-2]
                bin << can[can.size-1]
                can.delete_at(can.size-2)
                can.delete_at(can.size-1)
            end
        else
            puts "やり直す操作がありません"
        end
    when 8
        puts "\nプログラムを終了します"
        break
    else
        puts "入力が正しくありません"
    end

    gets.chomp
}

aaa = String.new

array.each do |i|
    aaa << "#{i[0]}:#{i[1]}\n"
end

File.write("file", aaa)