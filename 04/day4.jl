using Printf

function part1(range_start, range_end)

    password = range_start
    password_count = 0
    while password < range_end
        password_digits = sort(split(@sprintf("%d", password), ""))
        if parse(Int, join(password_digits, "")) == password && length(unique(password_digits)) <= 5
            password_count += 1
        end

        password += 1
    end
    
    return password_count

end

function part2(range_start, range_end)

    password = range_start
    password_count = 0
    while password < range_end
        password_digits = sort(split(@sprintf("%d", password), ""))
        if parse(Int, join(password_digits, "")) == password && length(unique(password_digits)) <= 5
            for digit in unique(password_digits)
                if count(i->(i == digit), password_digits) == 2
                    password_count += 1
                    break
                end
            end
        end

        password += 1
    end
    
    return password_count

end

println(part1(172851, 675869))
println(part2(172851, 675869))