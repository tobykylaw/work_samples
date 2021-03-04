summation = 0
for n in range(60, 1001):
    add = (1/n)*(1/1000)
    summation = summation+add
    

expected_value = 0
max_pp = 0
for n in range(60,1001):
    numerator = (1/n)*(1/1000)
    pp = numerator/summation
    print ("When N = ", n, ", Posterior probability = ", pp)
    if pp > max_pp:
        max_pp = n
    expected_value = expected_value + (n*pp)

print("Task 1: Posterior distribution attains maximum at N = ",max_pp)
print("Task 2: The expected value of the posterior distribution is ", int(expected_value))

