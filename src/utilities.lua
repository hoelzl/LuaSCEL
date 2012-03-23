---
-- Created by IntelliJ IDEA.
-- User: tc
-- Date: Jan/24/12
-- Time: 10:44
--

util = {}

-- A rather inefficient implementation of version 4 UUIDs
--
function util.uuid()
    local digits = {
        "0", "1", "2", "3", "4", "5", "6", "7", "8", "9",
        "a", "b", "c", "d", "e", "f" }
    local result = {}
    local function append_digit()
        local index = math.random(1, #digits)
        result[#result + 1] = digits[index]
    end
    local function append_n_digits(n)
        for _ = 1, n do
            append_digit()
        end
    end
    append_n_digits(8)
    result[#result + 1] = "-"
    append_n_digits(4)
    result[#result + 1] = "-"
    result[#result + 1] = "4"
    append_n_digits(3)
    result[#result + 1] = "-"
    result[#result + 1] = digits[math.random(8,11)]
    append_n_digits(3)
    result[#result + 1] = "-"
    append_n_digits(8)
    return table.concat(result)
end

-- print(util.uuid())
