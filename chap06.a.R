aa <- data.frame(
  AminoAcid = c("G", "T", "I", "Y", "W", "Q", "K", "A", "C", "L",
                "P", "H", "D", "R", "S", "V", "F", "M", "N", "E"),
  Font = c(1, 1, 1, 1, 1, 2, 2, 1, 1, 1, 1, 2, 2, 2, 1, 1, 1, 1, 2, 2)
) # Define fonts to associate with each amino acid

input <- "20DVAGHGQDILIRLFK"  # Define the input as a string of amino acids 
                              # optionally preceded by a number indicating 
                              # the residue number

m <- regexpr("^(\\d+)", input) # Find any numbers at the beginning of the input string
res <- regmatches(input, m)    # Retrieve any numbers at the beginning of the input string
res <- ifelse(length(res) == 0, 1, as.numeric(res)) # If there's no number, initialize the residue to 1


input <- gsub("^\\d+", "", input)  # Eliminate any numbers at the beginning of the input string
input <- substring(input, seq(1, nchar(input), 1), seq(1, nchar(input), 1) ) # Split the string into a vector of characters
res <- seq(res, res + length(input))  # Make a sequence starting from the residue number upto the residue number plus the lenght of the string

n = 10*(length(input) - 1)  # We will draw n points equal to the number of residues minus one times 10 (10 lines between residues)
theta <- -90 + (0:n * 10)   # We will draw the n points 10 degrees apart starting from -90 degrees
radius <- 50                # Initialize the value for the radiis
radius <- radius + seq_along(theta)*0.6 # The radius will increase linearly from 50 up to 50 + 0.6*n (0.6 is just a constant that determines space in between spirals)
x <- radius*cos(theta*pi/180) # Translate polar coordinates to cartesian-x coordinates
y <- radius*sin(theta*pi/180) # Translate polar coordinates to cartesian-y coordinates

par(pty="s",
    oma=c(0, 0, 0, 0),
    mar=c(0, 0, 0, 0))    # Set parameters to draw a square plot (ratio of x to y = 1)
plot(x, y, # Draw the x, y coordinates...
     'l',  # ...joined by lines...
     axes=FALSE, ann = FALSE) #...without axes and ticks.

for (i in seq_along(input)) {       # For every residue in the input...
  j <- (i-1)*10 + 1                 # Find the index corresponding to its cartesian coordinate (every 10 points starting from 1)
  pch <- paste0(res[i], input[i])   # Set the text concatenating the residue number and the residue
  font <- aa$Font[aa$AminoAcid == input[i]] # Set font appropriately
  text(x[j], y[j], labels = pch, font = font) # Draw the text on top of the spiral
}