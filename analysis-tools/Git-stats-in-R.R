# get commits and parents
xx <- textConnection(system("git log --pretty='%H %P'", intern=T))
yy <- read.table(xx, fill=T) # second column is blank for last line and ?? merges ??

# get commit datetimes
xx <- textConnection(system("git log --pretty='%ci'", intern=T))
yy <- read.table(xx) 

# get number of commits for each hour of the day
zz <- rle(sort(substr(yy[,2], 0, 2)))
plot(zz$values, zz$lengths, xlab="hour of day", ylab="number of commits", type="l")

# get number of commits for each date
zz <- rle(sort(substr(yy[,1], 0, 9)))
plot(as.factor(zz$values), zz$lengths, xlab="Date", ylab="number of commits", type="l")

# get number of commits for each day of the week


# this needs to be worked on... grad a pair of commit IDs (a commit and its parent, e.g.)
# and extract the number of additions and deletions for each file
# get number of added, deleted lines per file
xx <- textConnection(system("git diff 92435d9 --numstat", intern=T))
yy <- read.table(xx) 
yy
