# 2023 Advent of Code Day 2
# github.com/melpub22

using DelimitedFiles

input = readdlm("input/day02.txt", '\n')

# Function for parsing integers from regular expression matches
parse_raw(matches) = [parse(Int, (matches[i].match[1:end-2])) for i in eachindex(matches)]

# Function checking if any values exceed limits (for part 1)
check_vals(vals, limit) = sum(vals .> limit) > 0

# Function calculating power (for part 2)
power(r_vals, g_vals, b_vals) = prod(maximum.([r_vals, g_vals, b_vals]))

id_sum = 0      # Part 1 sum
power_sum = 0   # Part 2 sum

# Iterate over each line
for iline = eachindex(input)
    # Store text of each line
    line = input[iline]
    
    # Use regular expressions to find number matches for red, green, and blue
    r_matches = collect(eachmatch(r"\d+ r", line))
    g_matches = collect(eachmatch(r"\d+ g", line))
    b_matches = collect(eachmatch(r"\d+ b", line))

    # Convert regular expression matches to integers
    r_vals = parse_raw(r_matches)
    g_vals = parse_raw(g_matches)
    b_vals = parse_raw(b_matches)

    # Update ID sum for part 1
    if !(check_vals(r_vals, 12) || check_vals(g_vals, 13) || check_vals(b_vals, 14))
        global id_sum += iline
    end
    
    # Update product sum for part 2
    global power_sum += power(r_vals, g_vals, b_vals)
end

# Output results
println("Part 1) Sum of valid IDs: $id_sum")
println("Part 2) Sum of powers: $power_sum")