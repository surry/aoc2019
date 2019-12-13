using Printf

function check_resize(memory, position)
    if position > length(memory)
        resize!(memory, position)
        memory[position:end] .= 0
    end
end

function get_position(mode, memory, position, relative_base)
    if mode == 0
        check_resize(memory, memory[position] + 1)
        return memory[position] + 1
    elseif mode == 1
        check_resize(memory, position)
        return position
    elseif mode == 2
        index = memory[position] + relative_base + 1
        check_resize(memory, index)

        return index
    else
        error("Unexpected parameter mode: ", mode)
    end
end

function part1(inputs)
    open("input.txt") do f
        program = read(f, String)
        values = map((x) -> parse(Int, x) , split(program, ','))

        opcode = values[1] % 100

        relative_base = 0

        position = 1
        while opcode != 99

            parameter_mode = split(lpad(@sprintf("%d", values[position])[1:end - 2], 3, '0'), "")
            parameter_mode = map(x -> parse(Int64, x), parameter_mode)

            if opcode == 3
                values[get_position(parameter_mode[3], values, position + 1, relative_base)] = popfirst!(inputs)
                position += 2
            elseif opcode == 4
                println(values[get_position(parameter_mode[3], values, position + 1, relative_base)])
                position += 2
            elseif opcode == 1
                values[get_position(parameter_mode[1], values, position + 3, relative_base)] = values[get_position(parameter_mode[3], values, position + 1, relative_base)] + values[get_position(parameter_mode[2], values, position + 2, relative_base)]
                position += 4
            elseif opcode == 2
                values[get_position(parameter_mode[1], values, position + 3, relative_base)] = values[get_position(parameter_mode[3], values, position + 1, relative_base)] * values[get_position(parameter_mode[2], values, position + 2, relative_base)]
                position += 4
            elseif opcode == 5
                if values[get_position(parameter_mode[3], values, position + 1, relative_base)] != 0
                    position = values[get_position(parameter_mode[2], values, position + 2, relative_base)]
                    position += 1 # due to 1-based indexing :(
                else
                    position += 3
                end
            elseif opcode == 6
                if values[get_position(parameter_mode[3], values, position + 1, relative_base)] == 0
                    position = values[get_position(parameter_mode[2], values, position + 2, relative_base)]
                    position += 1 # due to 1-based indexing :(
                else
                    position += 3
                end
            elseif opcode == 7
                if values[get_position(parameter_mode[3], values, position + 1, relative_base)] < values[get_position(parameter_mode[2], values, position + 2, relative_base)]
                    values[get_position(parameter_mode[1], values, position + 3, relative_base)] = 1
                else
                    values[get_position(parameter_mode[1], values, position + 3, relative_base)] = 0
                end
                position += 4
            elseif opcode == 8
                if values[get_position(parameter_mode[3], values, position + 1, relative_base)] == values[get_position(parameter_mode[2], values, position + 2, relative_base)]
                    values[get_position(parameter_mode[1], values, position + 3, relative_base)] = 1
                else
                    values[get_position(parameter_mode[1], values, position + 3, relative_base)] = 0
                end
                position += 4
            elseif opcode == 9
                relative_base += values[get_position(parameter_mode[3], values, position + 1, relative_base)]
                position += 2
            else
                error("Unexpected opcode: ", opcode)
            end

            opcode = values[position] % 100

        end

    end
end

part1([1])
part1([2])