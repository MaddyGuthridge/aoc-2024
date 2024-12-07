using Printf

nrows(lines::Vector{String}) = length(lines)
ncols(lines::Vector{String}) = length(lines[1])

function is_xmas(lines::Vector{String}, row::Integer, col::Integer)
    # Centre square
    if lines[row][col] != 'A'
        return false
    end
    # Downwards diagonal
    if lines[row-1][col-1] == 'M'
        if lines[row+1][col+1] != 'S'
            return false
        end
    elseif lines[row-1][col-1] == 'S'
        if lines[row+1][col+1] != 'M'
            return false
        end
    else
        return false
    end
    # Upwards diagonal
    if lines[row-1][col+1] == 'M'
        if lines[row+1][col-1] != 'S'
            return false
        end
    elseif lines[row-1][col+1] == 'S'
        if lines[row+1][col-1] != 'M'
            return false
        end
    else
        return false
    end

    # @printf("%d, %d\n", row, col)
    return true
end

function part2(lines::Vector{String})
    xmas_count = sum(map(
        row -> sum(map(
            col -> is_xmas(lines, row, col) ? 1 : 0,
            2:ncols(lines)-1
        )),
        2:nrows(lines)-1
    ))
    println(xmas_count)
end

infile = ARGS[1]

f = strip(read(infile, String))

# Convert each line into its own string to make the type annotations less awful
lines = map(String, split(f, '\n'))

part2(lines)
