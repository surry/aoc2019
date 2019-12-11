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

function part1(inputs)
    open("input.txt") do f
        program = read(f, String)
        values = map((x) -> parse(Int, x) , split(program, ','))

        opcode = values[1] % 100

        position = 1
        while opcode != 99

            if opcode in [1, 2, 5, 6, 7, 8]
                parameter_mode = split(lpad(@sprintf("%d", values[position])[1:end - 2], 3, '0'), "")
                parameter_mode = map(x -> parse(Int, x), parameter_mode)
            end

            if opcode == 3
                values[values[position + 1] + 1] = popfirst!(inputs)
                position += 2
            elseif opcode == 4
                return values[values[position + 1] + 1]
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

function find_max_output()
    output_signal = -999

    for i in 0:4
        amp_a = part1([i, 0])
        for j in 0:4
            amp_b = part1([j, amp_a])
            for k in 0:4
                amp_c = part1([k, amp_b])
                for l in 0:4
                    amp_d = part1([l, amp_c])
                    for m in 0:4
                        amp_e = part1([m, amp_d])

                        if amp_e > output_signal && length(unique([i, j, k, l, m])) == 5
                            output_signal = amp_e
                        end
                    end
                end
            end
        end
    end

    println(output_signal)
end

find_max_output()

# version that uses Channels for input/output :|
function part2(input, output)
    open("input.txt") do f
        program = read(f, String)
        values = map((x) -> parse(Int, x) , split(program, ','))

        opcode = values[1] % 100

        position = 1
        while opcode != 99

            if opcode in [1, 2, 5, 6, 7, 8]
                parameter_mode = split(lpad(@sprintf("%d", values[position])[1:end - 2], 3, '0'), "")
                parameter_mode = map(x -> parse(Int, x), parameter_mode)
            end

            if opcode == 3
                values[values[position + 1] + 1] = take!(input)
                position += 2
            elseif opcode == 4
                put!(output, values[values[position + 1] + 1])
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



function find_max_feedback_output()
    max_output_signal = -999
    a_out = Channel{Int}(64)
    b_out = Channel{Int}(64)
    c_out = Channel{Int}(64)
    d_out = Channel{Int}(64)
    e_out = Channel{Int}(64)

    for i in 5:9
        for j in 5:9
            for k in 5:9
                for l in 5:9
                    for m in 5:9
                        put!(e_out, i)

                        amp_a() = part2(e_out, a_out)
                        a = Task(amp_a)

                        schedule(a)

                        put!(a_out, j)

                        amp_b() = part2(a_out, b_out)
                        b = Task(amp_b)

                        schedule(b)

                        put!(b_out, k)

                        amp_c() = part2(b_out, c_out)
                        c = Task(amp_c)

                        schedule(c)

                        put!(c_out, l)

                        amp_d() = part2(c_out, d_out)
                        d = Task(amp_d)

                        schedule(d)


                        put!(d_out, m)

                        amp_e() = part2(d_out, e_out)
                        e = Task(amp_e)

                        schedule(e)

                        # start the feedback process with a 0
                        put!(e_out, 0)

                        while !istaskdone(a) && !istaskdone(b) && !istaskdone(c) && !istaskdone(d) && !istaskdone(e)
                            wait(a)
                            wait(b)
                            wait(c)
                            wait(d)
                            wait(e)
                        end
                        thruster_signal = take!(e_out)

                        if thruster_signal > max_output_signal && length(unique([i, j, k, l, m])) == 5
                            max_output_signal = thruster_signal
                        end
                    end
                end
            end
        end
    end

    println("max = ", max_output_signal)

end

find_max_feedback_output()
