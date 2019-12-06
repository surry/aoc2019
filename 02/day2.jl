
function part1()
    open("input.txt") do f
        program = read(f, String)
        values = map((x) -> parse(Int, x) , split(program, ','))

        values[1 + 1] = 12
        values[2 + 1] = 2

        position = 1
        while values[position] != 99
            if values[position] == 1
                values[values[position + 3] + 1] = values[values[position + 1] + 1] + values[values[position + 2] + 1]
            elseif values[position] == 2
                values[values[position + 3] + 1] = values[values[position + 1] + 1] * values[values[position + 2] + 1]
            else
                println("opcode = ", values[position])
                throw(InvalidStateException())
            end

            position += 4
        end
        return values[1]
    end
end

function part2(desired_output)
    open("input.txt") do f
        program = read(f, String)
        initial_state = map((x) -> parse(Int, x) , split(program, ','))

        for i in 0:99
            for j in 0:99
                values = copy(initial_state)
                values[1 + 1] = i
                values[2 + 1] = j

                position = 1
                while values[position] != 99
                    if values[position] == 1
                        values[values[position + 3] + 1] = values[values[position + 1] + 1] + values[values[position + 2] + 1]
                    elseif values[position] == 2
                        values[values[position + 3] + 1] = values[values[position + 1] + 1] * values[values[position + 2] + 1]
                    else
                        println("opcode = ", values[position])
                        throw(InvalidStateException())
                    end

                    position += 4
                end
                if values[1] == desired_output
                    return 100 * i +  j
                else
                    continue
                end
            end
        end
    end
end

println(part1())
println(part2(19690720))

