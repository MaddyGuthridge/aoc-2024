

nrows(lines::Vector{String}) = length(lines)
# 1-indexed arrays, yuck
ncols(lines::Vector{String}) = length(lines[1])

"""
Number of diagonals
"""
ndiagonals(lines::Vector{String}) = nrows(lines) + ncols(lines) - 1


row(lines::Vector{String}, index::Integer) = lines[index]

column(lines::Vector{String}, index::Integer) = String(map(l -> l[index], lines))

"""
Downwards diagonals

```
4...
34..
234.
1234
```
"""
function diagonal_down(lines::Vector{String}, index::Integer)
    row = max(1, nrows(lines) - index + 1)
    col = max(1, -nrows(lines) + index + 1)
    diagonal = ""
    while row <= nrows(lines) && col <= ncols(lines)
        diagonal *= lines[row][col]
        row += 1
        col += 1
    end
    return diagonal
end

"""
Upwards diagonals

```
1234
234.
34..
4...
```
"""
function diagonal_up(lines::Vector{String}, index::Integer)
    row = min(index, nrows(lines))
    col = max(1, index - nrows(lines) + 1)
    diagonal = ""
    while row > 0 && col <= ncols(lines)
        diagonal *= lines[row][col]
        row -= 1
        col += 1
    end
    return diagonal
end

function nxmas(line::String)
    return count(i -> line[i:i+3] == "XMAS", 1:(length(line)-3))
end

function part1(lines::Vector{String})
    all_lines = [
        map(i -> row(lines, i), 1:nrows(lines));
        map(i -> column(lines, i), 1:ncols(lines));
        map(i -> diagonal_up(lines, i), 1:ndiagonals(lines));
        map(i -> diagonal_down(lines, i), 1:ndiagonals(lines))
    ]
    all_lines = [all_lines; map(reverse, all_lines)]

    # println(all_lines)
    xmas_count = sum(map(nxmas, all_lines))
    println(xmas_count)
end

infile = ARGS[1]

f = strip(read(infile, String))

# Convert each line into its own string to make the type annotations less awful
lines = map(String, split(f, '\n'))

part1(lines)
