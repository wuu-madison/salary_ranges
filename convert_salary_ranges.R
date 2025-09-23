#!/usr/bin/Rscript

# header row in result: "salary_grade,min_salary,max_salary"

# read the first file
x <- readLines("salary_ranges_part1.txt")

# separate job code from range
x <- strsplit(x, "[\t]")

# convert code to 3 digits with leading 0s
code <- sapply(x, "[", 1)
code <- sprintf("%03d", as.integer(code))

# ranges
salrng <- sapply(x, "[", 2)
# drop $'s and ,'s
salrng <- gsub("[$,]", "", salrng)
# ugh split at endashs
salrng <- strsplit(salrng, "–", fixed=TRUE)

# result table
result <- cbind(salary_grade=code,
                min_salary=sapply(salrng, "[", 1),
                max_salary=sapply(salrng, "[", 2))

# read the second file
y <- readLines("salary_ranges_part2.txt")

# convert code to 3 digits with leading 0s
code <- y[seq(1, length(y), by=2)]
code <- sprintf("%03d", as.integer(code))

# range info
salrng <- y[seq(2, length(y), by=2)]
salmin <- salmax <- rep(NA, length(code))

# has min only
has_min <- grep("(Minimum)", salrng, fixed=TRUE)
val_min <- salrng[has_min]
val_min <- gsub("[$,]", "", sapply(strsplit(val_min, " "), "[", 1))
salmin[has_min] <- val_min

# has range
has_range <- grep("–", salrng, fixed=TRUE)
val <- salrng[has_range]
val <- gsub("[$,]", "", val)
val <- strsplit(val, "–")
salmin[has_range] <- sapply(val, "[", 1)
salmax[has_range] <- sapply(val, "[", 2)

result <- rbind(result,
                cbind(salary_grade=code,
                      min_salary=salmin,
                      max_salary=salmax))

write.table(result, "salary_ranges.csv", quote=FALSE, sep=",", row.names=FALSE)
