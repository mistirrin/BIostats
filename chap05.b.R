#DENDOGRAM
tree <- "((A(CD))(B(E(G(IJ)))))" # SET NEWICK TREE
#tree <- "(A((BC)D)(EF))"
tree <- substr(tree, 1, nchar(tree) - 1) # REMOVE LAST CHARACTER
entities <- gsub("[()]", "", tree) # REMOVES PARENTHESES FROM TREE
entities <- strsplit(entities, NULL)[[1]] # SPLIT STRING INTO ARRAY OF CHARACTERS (ENTITIES)

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

w <- (length(entities)-1) # THE WIDTH EQUALS THE AMOUNT OF LETTERS MINUS ONE
h <- levels # THE HEIGHT EQUALS THE LEVELS CALCULATED
par(pty="s") # DRAW A SQUARE PLOT
plot(1, type="n", # CREATE AN EMPTY PLOT
     xlab="", ylab="", # WITH NO X/Y LABS
     xaxt = "n", yaxt = "n", # AND NO X/Y AXES
     xlim=c(0, w), ylim=c(0, h), # FROM 0 to W in X AND 0 to H in Y
     bty ="n") # AND NO SURROUNDING BOX

for (entity in entities) {  # PLOT EACH ENTITY...
  text(x, 0, entity, srt = 90) # AS TEXT ROTATED 90 DEGREES
  xx[entity] <- x # ADD ENTITY'S STARTING X POSITION TO X ARRAY
  yy[entity] <- 1 # ADD ENTITY'S STARTING Y POSITION TO Y ARRAY
  x <- x+1 # INCREASE X FOR NEXT ENTITY
}

while (nchar(tree) > 1) { # WHILE THERE ARE ENTITIES IN THE TREE
  m <- regexec("\\(?([A-Z])([A-Z])\\)?", tree) # RETRIEVE LEFTMOST PAIR OF ENTITIES
  m <- regmatches(tree, m) # GET THE MATCHES (REGULAR EXPRESSION)
  m1 <- m[[1]][2] # M1 EQUALS FIRST ENTITY FOUND (SECOND GROUP)
  m2 <- m[[1]][3] # M2 EQUALS SECOND ENTITY FOUND (THIRD GROUP)
  
  if (yy[m1] < yy[m2]) {  # IF THE Y POSITION OF THE LEFTMOST GROUP iS SMALLER THAN THAT OF THE SECOND GROUP
    segments(x0 = xx[m1], y0 = yy[m1],
             x1 = xx[m1], y1 = (yy[m2]+1))  # DRAW A VERTICAL LINE FROM THE LEFTMOST GROUP'S CURRENT TO THE SECOND GROUP'S Y POSITION + 1
    yy[m1] = yy[m2] # THE NEW Y POSITION FOR THE LEFTMOST GROUP EQUALS THAT OF THE SECOND GROUP
  } else { # ...OTHERWISE...
    segments(x0 = xx[m1], y0 = yy[m1], 
             x1 = xx[m1], y1 = (yy[m1]+1)) # DRAW A VERTICAL LINE FROM THE LEFTMOST GROUP'S CURRENT POSITION PLUS + 1
  }
  
  yy[m1] = yy[m1] + 1 # THE NEW Y POSITION FOR THE LEFTMOST GROUP EQUALS THAT OF THE SECOND GROUP
  
  segments(x0 = xx[m1], y0 = yy[m1],
           x1 = xx[m2], y1 = yy[m1]) # DRAW THE HORIZONTAL LINE FROM THE LEFTMOST GROUP TO THE SECOND GROUP
  segments(x0 = xx[m2], y0 = yy[m1],
           x1 = xx[m2], y1 = yy[m2]) # DRAW A VERTICAL LINE FROM THE SECOND GROUP'S CURRENT POSITION PLUS + 1
  
  xx[m1] = 0.5*(xx[m1] + xx[m2]) # FIND THE MIDDLEPOINT BETWEEN FIRST AND SECOND GROUP
  tree <- sub("\\(?([A-Z])([A-Z])\\)?", "\\1", tree) # GROUP THE TWO GROUPS INTO ONE NAMED LIKE THE LEFTMOST GROUP
}

segments(x0 = xx[tree], y0 = yy[tree],
         x1 = xx[tree], y1 = (yy[tree]+1)) # DRAW THE LAST LINE IN THE MIDDLE