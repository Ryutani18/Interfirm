#インターンの課題
#オセロ

$array = []
$alphabet = ["a","b","c","d","e","f","g","h"]
$bin = []

n = 0

File.open("osero") do |file|
    file.each_line do |i|
        $array << i.chomp
    end
end

def new_game
    $array[0] = "　ａｂｃｄｅｆｇｈ"
    $array[1] = "１・・・・・・・・"
    $array[2] = "２・・・・・・・・"
    $array[3] = "３・・・・・・・・"
    $array[4] = "４・・・ＷＢ・・・"
    $array[5] = "５・・・ＢＷ・・・"
    $array[6] = "６・・・・・・・・"
    $array[7] = "７・・・・・・・・"
    $array[8] = "８・・・・・・・・"
    $bin = []
end

def back(mine)
    $array[$bin[$bin.size-1][3][0]][$bin[$bin.size-1][3][1]] = "・"
    $bin[$bin.size-1][0].times do |c|
        $bin[$bin.size-1][2][0].times do |m|
            $array[$bin[$bin.size-1][3][0]+$bin[$bin.size-1][1][c][0]*(m+1)][$bin[$bin.size-1][3][1]+$bin[$bin.size-1][1][c][1]*(m+1)] = mine
        end
    end
    $bin.delete_at($bin.size-1)
end

def ai(mine,opponent)
    search = []
    hands = []
    ai = []
    $array.each_with_index do |row, index_line|
        row.split("").each_with_index do |s, index_column|
            if s == opponent
                search << [index_line,index_column]
            end
        end
    end
    search.each do |s|
        (-1..1).each do |a|
            (-1..1).each do |n|
                if s[0]+a == 9 || s[1]+n == 9
                    next
                else
                    if $array[s[0]+a][s[1]+n] == "・"
                        hands << [s[0]+a,s[1]+n]
                    end
                end
            end
        end
    end
    hands.each do |h|
        count_max = 0
        (-1..1).each do |a|
            (-1..1).each do |n|
                if h[0]+a == 9 || h[1]+n == 9
                    next
                else
                    if $array[h[0]+a][h[1]+n] == opponent
                        i = 0
                        while h[0]+a*(i+1) < 9 && h[1]+n*(i+1) < 9 && $array[h[0]+a*(i+1)][h[1]+n*(i+1)] == opponent
                            i += 1
                        end
                        if h[0]+a*(i+1) == 9 || h[1]+n*(i+1) == 9
                            next
                        else
                            if $array[h[0]+a*(i+1)][h[1]+n*(i+1)] == mine
                                count_max += i
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
        ai << count_max
    end
    count = 0
    vector = []
    amount = []

    if ai.count(ai.max) > 1
        max = []
        ai.each_with_index do |n,i|
            if n == ai.max
                max << i
            end
        end
        random = max.sample
    else
        random = ai.index(ai.max)
    end
    ai.delete(0)
    if ai.size == 0
        puts "置ける手がありません"
        $judge = "no"
        gets
    else
        $judge = "yes"
        (-1..1).each do |a|
            (-1..1).each do |n|
                if hands[random][0]+a == 9 || hands[random][1]+n == 9
                    next
                else
                    if $array[hands[random][0]+a][hands[random][1]+n] == opponent
                        i = 0
                        while hands[random][0]+a*(i+1) < 9 && hands[random][1]+n*(i+1) < 9 && $array[hands[random][0]+a*(i+1)][hands[random][1]+n*(i+1)] == opponent
                            i += 1
                        end
                        if hands[random][0]+a*(i+1) == 9 || hands[random][1]+n*(i+1) == 9
                            next
                        else
                            if $array[hands[random][0]+a*(i+1)][hands[random][1]+n*(i+1)] == mine
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
                    $array[hands[random][0]+vector[c][0]*m][hands[random][1]+vector[c][1]*m] = mine
                end
            end
            $bin << [count,vector,amount,hands[random]]
        end
    end
end

loop{
    puts $array
    if n == 60
        count_white = 0
        count_black = 0
        $array.each do |row|
            row.split("").each do |i|
                count_white += 1 if i == "Ｗ"
                count_black += 1 if i == "Ｂ"
            end
        end
        puts "---------------------"
        puts "白：#{count_white}個"
        puts "黒：#{count_black}個"
        case
        when count_white > count_black
            puts "白の勝ちです"
        when count_white == count_black
            puts "引き分けです"
        when count_white < count_black
            puts "黒の勝ちです"
        end
        break
    else
        puts "(新規：new, 保存：save, 戻る：back)"
        puts "【#{n+1}手目】"
        if n.even?
            puts "白の番です"
        else
            puts "黒の番です"
        end
        input = gets.chomp
        case input
        when "new"
            new_game
            n = 0
            next
        when "save"
            break
        when "back"
            if n > 0
                if n.even?
                    back("Ｗ")
                else
                    back("Ｂ")
                end
                n -= 1
                next
            else
                puts "戻れません"
                gets
                next
            end
        else
            if n.even?
                ai("Ｗ","Ｂ")
            else
                ai("Ｂ","Ｗ")
            end
            if $judge == "no"
                n = 60
                next
            end
        end
        n += 1
    end
}


