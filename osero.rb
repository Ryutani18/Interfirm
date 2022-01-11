#インターンの課題
#オセロ

array = []
alphabet = ["a","b","c","d","e","f","g","h"]
bin = []

n = 0

File.open("osero") do |file|
    file.each_line do |i|
        array << i.chomp
    end
end

loop{

    puts array
    puts "(新規：new, 保存：save, 戻る：back)"
    puts "【#{n+1}手目】"

    if n.even?
        puts "白の番です"

        input = gets.chomp

        case input
        when ""
            puts "入力が正しくありません"
            gets
            next
        when "new"
            array[0] = "　ａｂｃｄｅｆｇｈ"
            array[1] = "１・・・・・・・・"
            array[2] = "２・・・・・・・・"
            array[3] = "３・・・・・・・・"
            array[4] = "４・・・ＷＢ・・・"
            array[5] = "５・・・ＢＷ・・・"
            array[6] = "６・・・・・・・・"
            array[7] = "７・・・・・・・・"
            array[8] = "８・・・・・・・・"
            n = 0
            bin = []
            next
        when "save"
            break
        when "back"
            if n > 0
                array[bin[bin.size-1][3][0].to_i][alphabet.index(bin[bin.size-1][3][1])+1] = "・"
                bin[bin.size-1][0].times do |c|
                    bin[bin.size-1][2][c].times do |m|
                        array[bin[bin.size-1][3][0].to_i+bin[bin.size-1][1][c][0]*(m+1)][alphabet.index(bin[bin.size-1][3][1])+1+bin[bin.size-1][1][c][1]*(m+1)] = "Ｗ"
                    end
                end
                bin.delete_at(bin.size-1)
                n -= 1
                next
            else
                puts "戻れません"
                gets
                next
            end
        else
            input = input.split("")
            if (1..8).include?(input[0].to_i) && alphabet.include?(input[1]) && input.size == 2
                if array[input[0].to_i][alphabet.index(input[1])+1] == "・"

                    count = 0
                    vector = []
                    amount = []

                    (-1..1).each do |a|
                        (-1..1).each do |n|
                            if input[0].to_i+a == 9 || alphabet.index(input[1])+1+n == 9
                                next
                            else
                                if array[input[0].to_i+a][alphabet.index(input[1])+1+n] == "Ｂ"
                                    i = 0
                                    while input[0].to_i+a*(i+1) < 9 && alphabet.index(input[1])+1+n*(i+1) < 9 && array[input[0].to_i+a*(i+1)][alphabet.index(input[1])+1+n*(i+1)] == "Ｂ"
                                        i += 1
                                    end
                                    if input[0].to_i+a*(i+1) == 9 || alphabet.index(input[1])+1+n*(i+1) == 9
                                        next
                                    else
                                        if array[input[0].to_i+a*(i+1)][alphabet.index(input[1])+1+n*(i+1)] == "Ｗ"
                                            vector << [a,n]
                                            amount << i
                                            count += 1
                                            next
                                        else
                                            next
                                        end
                                    end
                                else
                                    next
                                end
                            end
                        end
                    end
                    if count > 0
                        count.times do |c|
                            (amount[c]+1).times do |m|
                                array[input[0].to_i+vector[c][0]*m][alphabet.index(input[1])+vector[c][1]*m+1] = "Ｗ"
                            end
                        end
                        bin << [count,vector,amount,input]
                    else
                        puts "石を置けません"
                        gets
                        next
                    end
                else
                    puts "石を置けません"
                    gets
                    next
                end
            else
                puts "入力が正しくありません"
                gets
                next
            end
        end
    else
        puts "黒の番です"
        input = gets.chomp
        case input
        when ""
            puts "入力が正しくありません"
            gets
            next
        when "new"
            array[0] = "　ａｂｃｄｅｆｇｈ"
            array[1] = "１・・・・・・・・"
            array[2] = "２・・・・・・・・"
            array[3] = "３・・・・・・・・"
            array[4] = "４・・・ＷＢ・・・"
            array[5] = "５・・・ＢＷ・・・"
            array[6] = "６・・・・・・・・"
            array[7] = "７・・・・・・・・"
            array[8] = "８・・・・・・・・"
            n = 0
            bin = []
            next
        when "save"
            break
        when "back"
            array[bin[bin.size-1][3][0].to_i][alphabet.index(bin[bin.size-1][3][1])+1] = "・"
            bin[bin.size-1][0].times do |c|
                bin[bin.size-1][2][c].times do |m|
                    array[bin[bin.size-1][3][0].to_i+bin[bin.size-1][1][c][0]*(m+1)][alphabet.index(bin[bin.size-1][3][1])+1+bin[bin.size-1][1][c][1]*(m+1)] = "Ｂ"
                end
            end
            bin.delete_at(bin.size-1)
            n -= 1
            next
        else
            input = input.split("")
            if (1..8).include?(input[0].to_i) && alphabet.include?(input[1]) && input.size == 2
                if array[input[0].to_i][alphabet.index(input[1])+1] == "・"

                    count = 0
                    vector = []
                    amount = []

                    (-1..1).each do |a|
                        (-1..1).each do |n|
                            if input[0].to_i+a == 9 || alphabet.index(input[1])+1+n == 9
                                next
                            else
                                if array[input[0].to_i+a][alphabet.index(input[1])+1+n] == "Ｗ"
                                    i = 0
                                    while input[0].to_i+a*(i+1) < 9 && alphabet.index(input[1])+1+n*(i+1) < 9 && array[input[0].to_i+a*(i+1)][alphabet.index(input[1])+1+n*(i+1)] == "Ｗ"
                                        i += 1
                                    end
                                    if input[0].to_i+a*(i+1) == 9 || alphabet.index(input[1])+1+n*(i+1) == 9
                                        next
                                    else
                                        if array[input[0].to_i+a*(i+1)][alphabet.index(input[1])+1+n*(i+1)] == "Ｂ"
                                            vector << [a,n]
                                            amount << i
                                            count += 1
                                            next
                                        else
                                            next
                                        end
                                    end
                                else
                                    next
                                end
                            end
                        end
                    end
                    if count > 0
                        count.times do |c|
                            (amount[c]+1).times do |m|
                                array[input[0].to_i+vector[c][0]*m][alphabet.index(input[1])+vector[c][1]*m+1] = "Ｂ"
                            end
                        end
                        bin << [count,vector,amount,input]
                    else
                        puts "石を置けません"
                        gets
                        next
                    end
                else
                    puts "石を置けません"
                    gets
                    next
                end
            else
                puts "入力が正しくありません"
                gets
                next
            end
        end
    end
    n += 1
}
