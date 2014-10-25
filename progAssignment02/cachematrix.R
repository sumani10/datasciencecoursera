## makeCacheMatrix :: 
## Creates cacheable matrix to serve as input to
## cachSolve() function, which sets and gets
## the cached values

makeCacheMatrix <- function(matInitial = matrix()) {

      # make sure the input is correct...
      # error checking.. based on the input type...
      if ( !is.matrix(matInitial)){
        message("The input should be a MATRIX. Exiting.. ")
        stop
      }

      # input is a matrix...
      # initialise the INVERSE of MATRIX variable
      matInv <- NULL

      # setter and getter functions...
      setVal <- function(y) {
              message("setVal called...!")
              matInitial <<- y
              matInv <<- NULL
      }
      getVal <- function() matInitial

      # functions to set and get the inversed matrix...
      setinverse<- function(invertedMatrix) matInv <<- invertedMatrix

      getinverse <- function() matInv

      # expose them.. external = internal functions...
      list(set = setVal,
           get = getVal,
           setInverseMatrix = setinverse,
           getInverseMatrix = getinverse)
}


# cacheSolve :: this function checks for the availability of
# inverse matrix in the passed cachedmatrix object.
# if it is found the original array is not inversed again, the cached copy
# is returned instead. Otherwise, it uses the solve function to inverse the
# original matrix and stores in the cachedmatrix object.

cacheSolve <- function(x, ...) {
        #-- get the inverted matrix value
        matInv <- x$getInverseMatrix()

        #-- check for the value... is it NULL?
        #-- if NOT null return the cached value..
        if(!is.null(matInv)) {
                message("Cached data available. Getting...!")
                return(matInv)
        }

        # now get the initial MATRIX... matInitial
        data <- x$get()

        #-- now do the inverse of the matrix using SOLVE
        localmatInv <- solve(data, ...)

        #-- pass the inversed value back...
        x$setInverseMatrix(localmatInv)

        #-- return the inverse matrix value... this part is invoked only
        #-- for the first time...
        localmatInv
}


##-----output...
#> m = ( matrix(rnorm(16),4,4))
#> source("cachematrix.R")
#> a <- makeCacheMatrix( m )
#> cacheSolve( a )
##            [,1]       [,2]         [,3]        [,4]
##[1,] -0.27635250 -0.4227969 -0.072635351 -0.04564220
##[2,]  0.23507241 -0.2495811  0.007362915 -0.49843067
##[3,]  0.34886791  0.2694715  0.941011809  0.59370872
##[4,] -0.04281634  0.2929509  0.471487607 -0.07498273
#> cacheSolve( a )
##Cached data available. Getting...!
##            [,1]       [,2]         [,3]        [,4]
##[1,] -0.27635250 -0.4227969 -0.072635351 -0.04564220
##[2,]  0.23507241 -0.2495811  0.007362915 -0.49843067
##[3,]  0.34886791  0.2694715  0.941011809  0.59370872
##[4,] -0.04281634  0.2929509  0.471487607 -0.07498273
#>
