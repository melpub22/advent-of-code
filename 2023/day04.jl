# 2023 Advent of Code Day 4
# github.com/melpub22

using DelimitedFiles

# Functiom to quickly form arrays from vectors of vectors (reused from Day 3)
mat(vec2) = mapreduce(permutedims, vcat, vec2)

# Function to convert a vector of strings of whitespace-seperated integers to a matrix of integers
int_mat(strings) = parse.(Int, mat(split.(strings)))

# Store the input data
input = readdlm("input/day04.txt", '\n')

# Part 1
split_lines = mat([split(input[i], [':', '|']) for i in eachindex(input)])          # Split lines into card name, card numbers, and winning numbers strings
nums_card = int_mat(split_lines[:, 2])                                              # Create card numbers matrix for all cards
nums_win = int_mat(split_lines[:, 3])                                               # Create winning numbers matrix for all cards
wins = [intersect(nums_card[i, :], nums_win[i, :]) for i = 1:size(nums_card)[1]]    # Determine the winning numbers for each card
wins_count = length.(wins)                                                          # Count the numbers of wins for each card
wins_points = 2 .^ (wins_count .- 1.) .* (wins_count .!= 0)                         # Tabulate the points for each card
println("Part 1: $(sum(wins_points))")                                              # Output the sum of the points for all cards

# Part 2
instances = [ones(size(nums_card)[1]); zeros(size(nums_card)[2])]                   # Preallocate the instances vector with 1s, with overflow 0s
for ii in 1:size(nums_card)[1]                                                      # For each card...
    for iwc = 1:wins_count[ii]                                                      #     For the count of wins for that card...
        instances[ii + iwc] += instances[ii]                                        #         Increase the instance values for the following cards
    end
end
scratchcards = sum(instances[1:(nums_card)[1]])                                     # Sum the instances to find the count of scratchcards
println("Part 2: $scratchcards")                                                    # Output the count of scratchcards