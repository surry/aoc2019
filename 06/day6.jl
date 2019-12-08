function count_orbits(all_orbits, orbits, com_distance, path, santa_path, you_path)
    num_orbits = 0
    com_distance += 1

    for object in orbits
        num_orbits += 1
        # account for indirect orbits
        num_orbits += (com_distance - 1)

        if object in keys(all_orbits)
            push!(path, object)
            num_orbits += count_orbits(all_orbits, all_orbits[object], com_distance, path, santa_path, you_path)
            pop!(path)
        end

        if object == "YOU"
            append!(you_path, path)
        elseif object == "SAN"
            append!(santa_path, path)
        end
    end

    return num_orbits
end

function part1()
    orbits = Dict()
    num_orbits = 0
    you_path = []
    santa_path = []
    open("input.txt") do f
        for orbit in eachline(f)
            orbit = split(orbit, ")")

            if !haskey(orbits, orbit[1])
               orbits[orbit[1]] = [String(orbit[2])]
            else
                push!(orbits[orbit[1]], String(orbit[2]))
            end

            if !haskey(orbits, orbit[2])
                orbits[orbit[2]] = []
            end
        end
        path = []
        for object in orbits["COM"]
            com_distance = 1
            num_orbits += 1
            if object in keys(orbits)
                push!(path, object)
                num_orbits += count_orbits(orbits, orbits[object], com_distance, path, santa_path, you_path)
            end
        end
    end

    if (length(santa_path) > length(you_path))
        len = length(you_path)
    else
        len = length(santa_path)
    end

    i = 1
    while i <= len && you_path[i] == santa_path[i]
        i += 1
    end

    common_ancestor = you_path[i]

    ancestor_to_you = i
    while ancestor_to_you <= length(you_path)
        ancestor_to_you += 1
    end
    you_distance = ancestor_to_you - i

    ancestor_to_santa = i
    while ancestor_to_santa <= length(santa_path)
        ancestor_to_santa += 1
    end
    santa_distance = ancestor_to_santa - i

    println(santa_distance + you_distance)

    return orbits
end

part1()

