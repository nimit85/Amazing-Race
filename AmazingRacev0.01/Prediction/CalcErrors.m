function err = CalcErrors(X, y, w)
  [d, ~] = size(X);
  err = 0;
  
  for i = 1:d
      if (sign(X(i, :) * w') ~= y(i))
          err = err + 1;
      end
  end
end