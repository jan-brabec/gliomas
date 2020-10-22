function [best_lim,best_spec,best_sens,pnt] = closest_pnt(spec,sens,limit)
%   function [limit,max_spec,max_sens] = closest_pnt(A,B,spec,sens,limit)
%
%   Returns best senstivity and specificity for given ROC curve

A = [1,1];
B = [spec; sens]';

distances = sqrt(sum(bsxfun(@minus, B, A).^2,2));
closest = B(find(distances==min(distances)),:);
closest = closest(1,:);

pnt = find(B(:,1)==closest(1) & B(:,2)==closest(2));

pnt = pnt(end);

best_lim = limit(pnt);
best_spec = spec(pnt);
best_sens = sens(pnt);

end

