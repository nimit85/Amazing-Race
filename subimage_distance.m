function d = subimage_distance(A, B)
  d = ( ( single_distance ( A, B ) + single_distance ( B, A ) ) / 2 );
end

function d = single_distance ( A, B )
  d = min ( 1, (0.2 * single_superimage_distance (A, B ) ) + (0.8 * single_subimage_distance(A, B) ) );
end

function d = single_subimage_distance ( A, B )
  d = sum ( sum ( xor ( or ( A, B ), A ) ) ) / prod(size(B));
end

function d = single_superimage_distance ( A, B )
  d = sum ( sum ( xor ( and ( A, B ), B ) ) ) / prod(size(B));
end
