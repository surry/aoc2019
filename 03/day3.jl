

function part1()

    open("input.txt", "r") do f
        wire_positions = Dict()
        intersections = []
        wires = []
        for line in eachline(f)
            push!(wires, split(line, ','))
        end

        for (i, wire) in enumerate(wires)
            x = 0
            y = 0

            for path in wire
                direction = path[1]
                distance = parse(Int, path[2:end])

                while distance > 0
                    if direction == 'U'
                        y += 1
                    elseif direction == 'D'
                        y -= 1
                    elseif direction =='R'
                        x += 1
                    else
                        x -=1
                    end
                    distance -= 1
        
                    # does the position already contain a wire that is not the current wire being "routed"?
                    if haskey(wire_positions, (x, y)) && !(i in wire_positions[(x, y)])
                        wire_positions[(x, y)] = push!(wire_positions[(x, y)], i)
                    elseif ! haskey(wire_positions, (x, y))
                        wire_positions[(x, y)] = [i]
                    end
                end
               
            end
        end

        for k in keys(wire_positions)
            if length(wire_positions[k]) > 1
                push!(intersections, abs(k[1]) + abs(k[2]))
            end
        end

        return minimum(intersections)

    end
end

function part2()
    open("input.txt", "r") do f
        wire_positions = Dict()
        intersections = []
        wires = []
        for line in eachline(f)
            push!(wires, split(line, ','))
        end

        for (i, wire) in enumerate(wires)
            x = 0
            y = 0

            current_steps = 0
            for path in wire
                direction = path[1]
                distance = parse(Int, path[2:end])

                while distance > 0
                    if direction == 'U'
                        y += 1
                    elseif direction == 'D'
                        y -= 1
                    elseif direction =='R'
                        x += 1
                    else
                        x -=1
                    end
                    distance -= 1
                    current_steps += 1
        
                    # does the position already contain a wire that is not the current wire being "routed"?
                    if haskey(wire_positions, (x, y)) && !(i in map(pos -> pos[1], wire_positions[(x, y)]))
                        wire_positions[(x, y)] = push!(wire_positions[(x, y)], (i, current_steps))
                    elseif ! haskey(wire_positions, (x, y))
                        wire_positions[(x, y)] = [(i, current_steps)]
                    end
                end
               
            end
        end

        for k in keys(wire_positions)
            if length(wire_positions[k]) > 1
                push!(intersections, wire_positions[k][1][2] + wire_positions[k][2][2])
            end
        end
        
        return minimum(intersections)

    end
end


println(part1())
println(part2())