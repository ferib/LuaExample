-- Test lua script

-- check for prime
function sieve_of_eratosthenes(n)
local is_prime = { }
    for i = 1, n do
        is_prime[i] = 1 ~= i
    end
    for i = 2, math.floor(math.sqrt(n)) do
        if is_prime[i] then
            for j = i* i, n, i do
                is_prime[j] = false
            end
        end
    end
    return is_prime
end

-- find prime numbers up until 420
local primes = sieve_of_eratosthenes(420)

-- print results
for key, value in pairs(primes) do
    if (value) then
        print("Prime found: " .. key)
    end
end
