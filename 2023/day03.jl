# 2023 Advent of Code Day 3
# github.com/melpub22

using DelimitedFiles                                                                    # Used for data import
using DSP                                                                               # Used for convolution function

# Functiom to quickly form arrays from vectors of vectors
mat(vec2) = mapreduce(permutedims, vcat, vec2)

# Part 1 function for determining the potential part number vector for a given line/string
# Ex.: "467..114.." -> [467 467 467 0 0 114 114 114 0 0]
function num_vector(line)
    matches = collect(eachmatch(r"\d+", line))                                          # Find potential part numbers in line
    values = [parse(Int, matches[i].match) for i = eachindex(matches)]                  # Determine potential part number values
    offsets = [matches[i].offset for i = eachindex(matches)]                            # Determine position of potential part numbers
    lengths = Int.(ceil.(log10.(values .+ 1)))                                          # Calculate the length of each potential part number

    num_vec = Int.(zeros(length(line)))                                                 # Preallocate a potential part number vector

    # Assemble potential part number vector
    for ival = 1:length(values)
        for inum = 1:length(num_vec)
            if (inum >= offsets[ival]) && (inum < offsets[ival] + lengths[ival])
                num_vec[inum] = values[ival]
            end
        end
    end

    return num_vec
end

# Part 1 & 2 function for finding values adjactent to a set of values
adjacent(A) = conv(A, [1 1 1; 1 0 1; 1 1 1])[2:end-1, 2:end-1] .> 0

# Part 1 & 2 function for removing duplicate values
rem_dup(A) = reshape([0; [A'[i] == A'[i - 1] ? 0 : A'[i] for i = 2:length(A)]], size(A))'

# Part 2 function for single-position matrix
sing_pos(position, size) = mat([[(ir == position[1] && ic == position[2]) ? 1 : 0 for ir = 1:size[1]] for ic = 1:size[2]])

# Part 2 function for calculating gear ratio from potential part number and star position adjacency matricies
function rat(StA, N)
    sorted_StAN = sort(vec(StA .* N))                                                   # Sort star adjacency × potential product number array
    sorted_StAN = setdiff(sorted_StAN, [0])                                             # Remove values of 0
    return sorted_StAN[1] * sorted_StAN[end]                                            # Return the product of the lowest and highest values
end

# Import input data
input = readdlm("input/day03.txt", '\n')

# Part 1
C = mat([[only(input[il][ic]) for ic = 1:length(input[il])] for il = eachindex(input)]) # Convert input to matrix of characters
S = sum([C .== s for s = ['*', '=', '#', '$', '/', '&', '@', '-', '+', '%']])           # Create matrix of places a symbol is present
N = mat([num_vector(line) for line = input])                                            # Create number matrix of potential part numbers
P = N .* adjacent(S)                                                                    # Find numbers adjecent to sumbols
Pp = rem_dup(P)                                                                         # Remove duplicate values
println("Part 1 sum: $(sum(Pp))")                                                       # Display Part 1 result

# Part 2
St = C .== '*'                                                                          # Find potential gear locations
star_pos = findall(==(1), St)                                                           # Tablue potential gear locations as coordinates
Sts = [sing_pos(pos, size(St)) for pos = star_pos]'                                     # Create single-position matricies for each potential gear location
StsA = adjacent.(Sts)                                                                   # Create adjacency matricies for each potential gear location
gr = [sum(rem_dup(StsA[i] .* (N.>0))) == 2 ? rat(StsA[i],N) : 0 for i=eachindex(StsA)]  # Calculate gear ratios for each potential gear location
println("Part 2 sum: $(sum(gr))")                                                       # Display Part 2 result