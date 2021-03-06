## Regression test for stability selection with QUIC
context("QUIC stability selection regression test")

library("stabs")
library("huge")

if (require("QUIC")) {

    set.seed(10010)
    dat.hubs <- huge.generator(n=1000, d=40, graph="hub")
    pcutoff <- 0.75
    PFER <- 10
    s.hubs <- stabsel(x=dat.hubs$data, fitfun=quic.graphical_model, 
                      cutoff=pcutoff, PFER=PFER, verbose=FALSE)
    
    load("quic.hub.test.Rda")
    testthat::test_that("Selected same", expect_equal(s.hubs$selected, s.hubs.orig$selected))
    
    ## Now for argument testing
    testthat::test_that("graphical - 2 matrices - should give error", 
                        expect_error(stabsel(x=dat.hubs$data, y=dat.hubs$data, 
                                             fitfun=quic.graphical_model, cutoff=pcutoff, 
                                             PFER=PFER, verbose=FALSE)))
    
    ## Incorrectly set up graphical fitter (no graphical_model class)
    my.quic <- quic.graphical_model
    class(my.quic) <- class(quic.graphical_model)[1]
    testthat::test_that("graphical fitter without class matrices - should give warning", 
                        expect_warning(stabsel(x=dat.hubs$data,
                                               fitfun=my.quic, cutoff=pcutoff, 
                                               PFER=PFER, verbose=FALSE)))
    
    ## test providing a lambda path
    l <- getLamPath(0.3, 0.001, len=50, log=TRUE)
    args.fitfun=list(lams=l)
    testthat::test_that("user supplied lambda", 
                        expect_s3_class(stabsel(x=dat.hubs$data,
                                                fitfun=quic.graphical_model, args.fitfun=args.fitfun, cutoff=pcutoff, 
                                                PFER=PFER, verbose=FALSE), "stabsel"))
    
}