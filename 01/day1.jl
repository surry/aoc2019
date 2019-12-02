

function calculate_fuel(mass)
    return mass ÷ 3 - 2
end

function part1()
    total_fuel = 0

    open("input.txt", "r") do f
        for mass in eachline(f)
            total_fuel += calculate_fuel(parse(Int, mass))
        end
    end

    return total_fuel
end

function calculate_fuel2(mass)
    fuel = mass ÷ 3 - 2
    return fuel > 0 ? fuel + calculate_fuel2(fuel) : 0
end

function part2()
    total_fuel = 0

    open("input.txt", "r") do f
        for mass in eachline(f)
            total_fuel += calculate_fuel2(parse(Int, mass))
        end
    end

    return total_fuel
end

println(part1())
println(part2())