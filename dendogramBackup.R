#DENDOGRAM

tree <- "((A(CD))(B(E(G(IJ)))))" # SET TREE NEWICK
#tree <- "(A((BC)D)(EF))" # SET TREE NEWICK
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

w <- (nchar(eert)-1) # THE WIDTH EQUALS THE AMOUNT OF LETTERS MINUS ONE
h <- levels # THE HEIGHT EQUALS THE LEVELS CALCULATED
plot(1, type="n", # CREATE AN EMPTY PLOT
     xlab="", ylab="", # WITH NO X/Y LABS
     xaxt = "n", yaxt = "n", # AND NO X/Y AXES
     xlim=c(0, w), ylim=c(0, h), # FROM 0 to W in X AND 0 to H in Y
     bty ="n") # AND NO SURROUNDING BOX

while (nchar(eert) > 0) { # PLOT EVERY CHARACTER
  n <- substr(eert, nchar(eert), nchar(eert))
  text(x, 0, n, srt = 90)
  xx[n] <- x
  yy[n] <- 1
  x <- x+1
  eert <- substr(eert, 1, nchar(eert) - 1)
}

while (nchar(tree) > 1) {
  print(sub("\\(?([A-Z])([A-Z])\\)?", "\\1", tree))
  m <- regexec("\\(?([A-Z])([A-Z])\\)?", tree)
  m <- regmatches(tree, m)
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
  tree <- sub("\\(?([A-Z])([A-Z])\\)?", "\\1", tree)
}

segments(x0 = xx[tree], y0 = yy[tree],
         x1 = xx[tree], y1 = (yy[tree]+1))