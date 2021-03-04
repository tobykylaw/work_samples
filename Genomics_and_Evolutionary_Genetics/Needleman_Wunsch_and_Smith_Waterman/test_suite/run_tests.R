tests_dir <- "work_samples\\Genomics_and_Evolutionary_Genetics\\Needleman_Wunsch_and_Smith_Waterman\\test_suite\\student_test_suite"
if(tests_dir == "path/to/tests") stop("tests_dir needs to be set to a proper path")

library("RUnit")

testsuite <- defineTestSuite("HW", tests_dir)
currentdir <- getwd()
setwd(tests_dir)

out <- runTestSuite(testsuite)
printTextProtocol(out)

setwd(currentdir)
