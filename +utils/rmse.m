function err = rmse(A,B)
err = mean(mean((A-B).^2));