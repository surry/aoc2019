
function load_layers()
    layer_dims = (6, 25)

    open("input.txt", "r") do f
        pixels = read(f, String)

        num_layers = length(pixels) ÷ (layer_dims[1] * layer_dims[2])

        layers = zeros(Int8, num_layers, layer_dims[1], layer_dims[2])

        pixels_read = 0
        while pixels_read < length(pixels)
            layers[pixels_read ÷ (layer_dims[1] * layer_dims[2]) + 1, :, :] .= transpose(reshape(map(x -> parse(Int8, x), split(pixels[pixels_read + 1:pixels_read + layer_dims[1] * layer_dims[2]], "")), layer_dims[2], :))
            pixels_read += layer_dims[1] * layer_dims[2]
        end
        return layers
    end
end

function find_layer()
    layers = load_layers()
    min_zeros = 9999

    min_zero_layer = []
    for i in 1:size(layers, 1)
        layer = layers[i, :, :]
        zeros = length(layer[layer .== 0])

        if zeros < min_zeros
            min_zero_layer = layer
            min_zeros = zeros
        end
    end

    println(length(min_zero_layer[min_zero_layer .== 1]) * length(min_zero_layer[min_zero_layer .== 2]))
end

function decode()
    layers = load_layers()

    decoded = mapslices(stack -> filter(x -> x != 2, stack)[1], layers, dims = 1)

    for i in 1:6
        println(join(map(x -> x == 0 ? ' ' : '1', decoded[1, i, :]), " "))
    end

end

find_layer()
decode()