rm(list = ls())

splitN <- function(x, n) {
  sub <- substring(x,seq(1,nchar(x),n),seq(n,nchar(x),n)) 
  return(sub)
}

getRanks <- function(groups, ranks) {
  new.ranks <- numeric(length(groups))
  
  for (i in 1:length(groups)) {
    letters <- splitN(groups[i], 1)
    rank <- mean(ranks[letters])
    new.ranks[i] <- rank
  }
  
  names(new.ranks) <- strtrim(groups, 1)
  
  ranks <- updateRanks(groups, ranks, new.ranks)
  return(ranks)
}

updateRanks <- function(groups, ranks, new.ranks) {
  for (i in 1:length(groups)) {
    letters <- splitN(groups[i], 1)
    remove <- ranks[letters]
    ranks <- subset(ranks, !(ranks %in% remove)) #ranks <- setdiff(ranks, remove)
  }
  ranks <- c(ranks, new.ranks)
  ranks <- ranks[order(names(ranks))]
  return(ranks)
}

updateString <- function(string, groups) {
  for (group in groups) {
    replacement <- strtrim(group, 1)
    group <- paste0("\\(", group, "\\)")
    string <- gsub(group, replacement = replacement, string)
  }
  return(string)
}

drawVertical <- function(letters, ranks, level) {
  for (i in 1:length(letters)) {
    segments(x0 = ranks[letters[i]], y0 = level, 
             x1 = ranks[letters[i]], y1 = level + 1)
    #col = par("fg"), lty = par("lty"), lwd = par("lwd")
  }
}

drawHorizontal <- function(groups, rank, level) {
  for (i in 1:length(groups)) {
    letters <- splitN(groups[i], 1)
    segments(x0 = ranks[letters[1]], y0 = level,
             x1 = ranks[letters[length(letters)]], y1 = level)
  }
}


#input <- "(E((AB)CD)F)"
input <- "(A((BC)(DEF)G)(HI(JK))L)"


pattern.letters <- "[()]"
pattern.inner <- ".*(\\([A-Z]+\\)).*"
#pattern.outer <- "(\\([A-Z]+\\))"

letters <- gsub(pattern.letters, replacement = "", x = input)
ranks <- 1:nchar(letters)
letters <- splitN(letters, 1) #sapply(rank, function(x) { return(substr(letters, x, x)) })
names(ranks) <- letters
groups <- c()
rest <- input

plot(1, type="n", 
     xlab="", ylab="", 
     xlim=c(1, length(letters)), ylim=c(0, 10),
     xaxt = "n", bty ="n")
axis(1, at= 1:length(letters), labels = letters, cex.axis = 0.7, lty = 0)

level <- 0
while(nchar(rest) > 1) {
  print("Drawing Vertical")
  drawVertical(letters, ranks, level)
  
  matches <- gregexpr("[(][A-Z]+[)]", rest)
  print("Getting Innermost Groups")
  groups <- unlist(lapply(regmatches(rest, matches), function(x) { substr(x, 2, nchar(x) - 1) }))
  print("Got Innermost Groups") 
  
  drawHorizontal(groups, ranks, level+1)
  
  ranks <- getRanks(groups, ranks)
  letters <- names(ranks)
  rest <- updateString(rest, groups)
  level <- level + 1
}