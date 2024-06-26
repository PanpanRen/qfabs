#' A minorization-maximization forward and backward stagewise algorithm for high-dimensional quantile regression.
#'
#' @param y The response, a numeric vector.
#' @param x The design matrix.
#' @param tau The quantile to be estimated, this is a number strictly between 0 and 1. Default value is 0.5.
#' @param epsilon The step size for updating coefficients. Default is 0.01.
#' @param delta A constant in pertubed loss function. Default is 1e-8.
#' @param xi The threshold for qfabs. Default is 1e-10.
#' @param max.iter The maximum number of outer-loop iterations allowed. Default is 5000.
#' @param gamma A tuning parameter in EBIC. Default is 1.
#'
#' @return A list.
#' \itemize{
#'   \item beta - The optimal solution that minimizes EBIC.
#'   \item lambda - lambda sequence generated by qfabs.
#'   \item iter - Iterations.
#'   \item EBIC - The EBIC for each solution.
#'   \item opt - Position of the optimal lambda based on EBIC.
#' }
#' @export
#'
#' @examples
#' library("mnormt")
#' n = 200
#' p = 500
#' beta = matrix(rep(0, p), ncol = 1)
#' index = 1:5
#' beta[index,1] = c(1.0,1.1,1.2,1.3,1.4)
#' distr = "t3"
#' rho = 0.8
#' dat = generator(n, p, beta, distr, rho)
#' x = dat$x
#' y = dat$y
#' tau = 0.2
#' fit <- qfabs(y, x, tau)
        
qfabs = function(y, x, tau = 0.5, epsilon = 0.01, delta = 1e-8, xi = 1e-10, max.iter = 5000, gamma = 1){
    p = ncol(x)
    x = cbind(1, x)
    n = length(y)

    fit <- .Call("ESTIMATE_1",
            as.numeric(y),
            as.numeric(x),
            as.integer(n),
            as.integer(1),
            as.integer(p+1),
            as.numeric(tau),
            as.numeric(0),
            as.numeric(epsilon),
            as.numeric(delta),
            as.numeric(xi),
            as.integer(max.iter),
            as.numeric(gamma))
    iter = fit$iter
    fit$opt = which.min(fit$bic[1:(iter+1)])

    val = list(beta = fit$beta,
               iter = iter,
               lambda = fit$lambda[1:(iter+1)],
               EBIC = fit$bic[1:(iter+1)],
               opt = fit$opt)

    return(val)
}




