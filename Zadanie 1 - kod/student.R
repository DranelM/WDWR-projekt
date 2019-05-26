library("tmvtnorm")
setwd("D:\\WDWR-Projekt\\")

expectedValueFun = function(mu, sigma, dof, alpha, beta){
  
  a = (alpha-mu)/sigma
  b = (beta-mu)/sigma
  expected = mu + sigma *((gamma((dof-1)/2) *((dof+ a^2)^(-(dof-1)/2) -    (dof + b^2)^(- (dof-1)/2))  * (dof^(dof/2))) / (2 * (pt(b, dof) - pt(a,dof)) * gamma(dof/2) * gamma(1/2)))
  
  return(expected)
}

mu = c(0.8, 1.8, 1.2, 1.8, 0.9, 1.6)

sigma = matrix(c( 0.36, -0.02, -0.06, -0.01,  0.13, -0.01,
                 -0.02,  0.01, -0.01,  0,    -0.01, -0.01,
                 -0.06, -0.01,  0.09,  0.01,  0.05,  0,
                 -0.01,  0,     0.01,  0.01, -0.01,  0,
                  0.13, -0.01,  0.05, -0.01,  0.25, -0.06,
                 -0.01, -0.01,  0,     0,    -0.06,  0.04), 6, 6)

scenariosAmount = 10000
dof = 4 #Degrees of freedom
dims = 6 #Dimensions
alpha = c(0.2, 0.2, 0.2, 0.2, 0.2, 0.2)
beta = c(2, 2, 2, 2, 2, 2)
ER = vector("double",6)

for (i in 1:dims){
  ER[i] = expectedValueFun(mu[i], sqrt(sigma[i,i]), dof, alpha[i], beta[i])
}

scenarios = rtmvt(n=scenariosAmount, mu, sigma, dof, alpha, beta)
#scenarios = cbind(scenarios, rep(1/scenariosAmount,scenariosAmount))

write.table(scenarios, file="./scenarios.csv", sep=",", row.names=FALSE,col.names=FALSE)