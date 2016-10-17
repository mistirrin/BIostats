#DENDOGRAM

#tree <- "((A(CD))(B(E(G(IJ)))))" # SET TREE NEWICK
tree <- "(A((BC)D)(EF))" # SET TREE NEWICK
tree <- substr(tree, 1, nchar(tree) - 1) # REMOVE LAST CHARACTER
eert <- paste(rev(strsplit(tree, NULL)[[1]]), collapse = "") # REVERSE TREE
eert <- gsub("[()]", "", eert) # REMOVES PARENTHESES FROM REVERSED TREE

# ARRAYS
xx <- c() # INITIALIZE X ARRAY
yy <- c() # INITIALIZE Y ARRAY
# AUXILIARIES
x <- 0; i <- 1 # INITIALIZE AUXILIARY VARIABLES

# FIND OUT HOW MANY LEVELS IN THE DENDOGRAM BY FINDING THE MOST CONSECTUIVE "("
levels <- gsub("[^()]", "", tree) # GET RID OF ANYTHING BUT "("s AND ")"s
levels <- regmatches(levels, gregexpr("\\(*", levels)) # FIND SEQUENCES OF CONSECUTIVE "("
levels <- max(sapply(levels, nchar)) # GET THE LONGEST SEQUENCE
levels <- levels + 3 # ADD THREE MORE LEVELS

w <- (nchar(eert)-1)
h <- levels
plot(1, type="n", xlab="", ylab="", xlim=c(0, w), ylim=c(0, h))
while (nchar(eert) > 0) {
  n <- substr(eert, nchar(eert), nchar(eert))
  text(x, y, n, srt = 90)
  xx[n] <- x
  yy[n] <- 1
  x <- x+1
  eert <- substr(eert, 1, nchar(eert) - 1)
}

tx <- tree

while (nchar(tx) > 1) {
  print(sub("\\(?([A-Z])([A-Z])\\)?", "\\1", tx))
  m <- regexec("\\(?([A-Z])([A-Z])\\)?", tx)
  m <- regmatches(tx, m)
  m1 <- m[[1]][2]
  m2 <- m[[1]][3]
  
  print(paste(m1, xx[m1], yy[m1]))
  print(paste(m2, xx[m2], yy[m2]))
  
  if (yy[m1] < yy[m2]) {
    segments(x0 = xx[m1], y0 = yy[m1],
             x1 = xx[m1], y1 = (yy[m2]+1))
    yy[m1] = yy[m2]
  } else {
    segments(x0 = xx[m1], y0 = yy[m1],
             x1 = xx[m1], y1 = (yy[m1]+1))
  }
  
  yy[m1] = yy[m1] + 1
  
  segments(x0 = xx[m1], y0 = yy[m1],
           x1 = xx[m2], y1 = yy[m1])
  segments(x0 = xx[m2], y0 = yy[m1],
           x1 = xx[m2], y1 = yy[m2])
  
  print(paste(m1, xx[m1], yy[m1]))
  print(paste(m2, xx[m2], yy[m2]))
  
  xx[m1] = 0.5*(xx[m1] + xx[m2])
  tx <- sub("\\(?([A-Z])([A-Z])\\)?", "\\1", tx)
}

segments(x0 = xx[tx], y0 = yy[tx],
         x1 = xx[tx], y1 = (yy[tx]+1))