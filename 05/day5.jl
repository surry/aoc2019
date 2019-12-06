using Printf

function get_position(mode, memory, position)
    if mode == 0
        return memory[position] + 1
    elseif mode == 1
        return position
    else
        error("Unexpected parameter mode: ", mode)
    end
end

function part1(system_id)
    open("input.txt") do f
        program = read(f, String)
        values = map((x) -> parse(Int, x) , split(program, ','))

        input = system_id

        opcode = values[1] % 100

        position = 1
        count = 0
        while opcode != 99 
            
            if opcode in [1, 2, 5, 6, 7, 8]
                parameter_mode = split(lpad(@sprintf("%d", values[position])[1:end - 2], 3, '0'), "")
                parameter_mode = map(x -> parse(Int, x), parameter_mode)
            end

            if opcode == 3
                values[values[position + 1] + 1] = input
                position += 2
            elseif opcode == 4
                println(values[values[position + 1] + 1])
                position += 2
            elseif opcode == 1
                values[get_position(parameter_mode[1], values, position + 3)] = values[get_position(parameter_mode[3], values, position + 1)] + values[get_position(parameter_mode[2], values, position + 2)]
                position += 4
            elseif opcode == 2
                values[get_position(parameter_mode[1], values, position + 3)] = values[get_position(parameter_mode[3], values, position + 1)] * values[get_position(parameter_mode[2], values, position + 2)]
                position += 4
            elseif opcode == 5
                if values[get_position(parameter_mode[3], values, position + 1)] != 0
                    position = values[get_position(parameter_mode[2], values, position + 2)]
                    position += 1 # due to 1-based indexing :(
                else
                    position += 3
                end
            elseif opcode == 6
                if values[get_position(parameter_mode[3], values, position + 1)] == 0
                    position = values[get_position(parameter_mode[2], values, position + 2)]
                    position += 1 # due to 1-based indexing :(
                else
                    position += 3
                end
            elseif opcode == 7
                if values[get_position(parameter_mode[3], values, position + 1)] < values[get_position(parameter_mode[2], values, position + 2)]
                    values[get_position(parameter_mode[1], values, position + 3)] = 1
                else
                    values[get_position(parameter_mode[1], values, position + 3)] = 0
                end
                position += 4
            elseif opcode == 8
                if values[get_position(parameter_mode[3], values, position + 1)] == values[get_position(parameter_mode[2], values, position + 2)]
                    values[get_position(parameter_mode[1], values, position + 3)] = 1
                else
                    values[get_position(parameter_mode[1], values, position + 3)] = 0
                end
                position += 4
            else
                error("Unexpected opcode: ", opcode)
            end

            opcode = values[position] % 100

        end

    end
end

part1(1)
part1(5)