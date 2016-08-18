

context("Tree models")
# some testing is also done in test_lm
test_that("CART models",{
  
  # impute categorical data
  dat <- data.frame(x=rep(c("a","b"),each=50), y = 1:100)
  dat[c(1,10),1] <- NA
  expect_equal(
    impute_cart(dat, x ~ y)
  , data.frame(x=rep(c("a","b"),each=50), y = 1:100)
  )
  # impute logical data
  dat <- data.frame(x=rep(c(TRUE,FALSE),each=50), y = 1:100)
  dat[c(1,10),1] <- NA

  expect_equal(
  impute_cart(dat, x ~ y)
  , data.frame(x=rep(c(TRUE,FALSE),each=50), y = 1:100)
  )
  

  dat <- data.frame(
    x = rnorm(100)
    , y = sample(c(TRUE,FALSE),100,replace=TRUE)
    , z = sample(letters[1:4],100,replace=TRUE)
    , p = runif(100)
  )
  dat[1:3,"x"] <- NA
  dat[4:6,"y"] <- NA
  dat[6:8,"z"] <- NA
  expect_true(is.logical(impute_cart(dat,y~p)[,'y']))
  expect_true(is.factor(impute_cart(dat,z~p)[,'z']))
  expect_true(is.numeric(impute_cart(dat,x~p)[,'x']))
 
  #test behaviour with different options of CP-passing. 
  expect_true( !any(is.na(impute_cart(dat, x~p, cp=0.01))[,'x'] ) ) 
  expect_true( !any(is.na(impute_cart(dat, x + y~p, cp=0.01))[,'x'] ) ) 
  expect_error( impute_cart(dat, x + y + z ~ p, cp=c(0.01,0.1))[,'x']  ) 
  expect_true( !any(is.na(impute_cart(dat, x + y~p, cp=rep(0.01,2)))[,'x'] ) ) 
  
})

test_that("RandomForest imputation",{
  dat <- iris
  dat[1:3,1] <- dat[4:7,5] <- NA 
  expect_true(!any(is.na(impute_rf(dat, Species + Sepal.Length ~ Sepal.Width))))
  expect_true(!any(is.na(impute_rf(dat, Species + Sepal.Length ~ Sepal.Width, add_residual="observed"))))
  expect_true(!any(is.na(impute_rf(dat, Species + Sepal.Length ~ Sepal.Width, add_residual="normal"))))
   
})

