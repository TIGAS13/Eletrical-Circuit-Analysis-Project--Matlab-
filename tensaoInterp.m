function VInterp = tensaoInterp(t,V,x)
[~,idx] = sort(abs(t-x));
idx = sort(idx(1:4));
tVizinhanca = (idx);
vVizinhanca = V(idx);

p = polyfit(tVizinhanca,vVizinhanca,3);

VInterp = polyval(p,x);

end

