function [min_err, min_w] = pPLA(X, y, max_iter)
  [~, p] = size(X);
  w = zeros(1,p);
  
  min_w = w;
  min_err = CalcErrors(X, y, w);
  if ( min_err == 0 )
      return
  end
  
  for i = 1:max_iter
      w = w + (get_random_error(X, y, w));
      err = CalcErrors(X, y, w);
      if ( err < min_err )
          min_err = err;
          min_w = w;
          if ( err == 0 )
              return
          end
      end
  end
end

function res = get_random_error(X, y, w)
    [d, ~] = size(X);
    order = randperm(d);
    for i = order
        if ( sign(X(i, :) * w') ~= y(i))
            res = y(i) * (X(i, :));
            return
        end
    end
end