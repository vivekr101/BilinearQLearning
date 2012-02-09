function err = rmse(A,B)
err = mean(sum((A-B).^2,2));