# 2023 Advent of Code Day 1
# github.com/melpub22

using DelimitedFiles

## INCOMPLETE
## work in progress

#=
# Function for converting words like "one" to integers like "1" in the input
function letters_to_digits!(input)
    words = ["one", "two", "three", "four", "five", "six", "seven", "eight", "nine"]
    
    for iline in eachindex(input)
        line = string(input[iline])
        #print(line)
        line_new = ""
        line_rest = ""
        line_complete = false

        while !line_complete
            #print("$line => ")
            for ichar in eachindex(line)
                for iword in eachindex(words)
                    line_new = replace(line[1:ichar], words[iword] => iword)
                    line_rest = line[ichar+1:end]

                    if line[1:ichar] != line_new
                        break
                    end
                end

                if line[1:ichar] != line_new
                    break
                end

                if ichar == length(line)
                    #print("[d$ichar: $line]; ")
                    line_complete = true
                    break
                end
            end

            line = "$(line_new)$(line_rest)"
        end

        input[iline] = line
    end
end
=#

# PART 1

# Function for extracting a vector of calibration values
function calibration_values(input)
    calibration_values = []

    # Iterate over the string in each line of the input to determine each line's calibration value
    for line = input
        print("$line -> ")
        line_char_values = [try parse(Int, c) catch end for c in string(line)]  # Convert each character to an Int or "nothing" and store as a vector
        line_char_values = line_char_values[line_char_values .!= nothing]       # Remove "nothing values"
        calibration_value = line_char_values[1] * 10 + line_char_values[end]    # Compute the calibration value
        append!(calibration_values, calibration_value)                          # Add the calibration value to the calibration values vector
        print("$calibration_value; ")
    end

    return calibration_values
end

# Import test and real data
input_test = readdlm("input/day01.test.txt", '\n')
input_real = readdlm("input/day01.txt", '\n')

# Convert words to digits
letters_to_digits!(input_test)
letters_to_digits!(input_real)

# Calculate sums of calibration value vectors for test and real data
sum_test = sum(calibration_values(input_test))
sum_real = sum(calibration_values(input_real))

# Print results
println("Test result: $sum_test")
println("Real result: $sum_real")