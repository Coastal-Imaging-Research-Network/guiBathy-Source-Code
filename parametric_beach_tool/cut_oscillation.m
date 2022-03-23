function data = cut_oscillation(theta,psi,s,idd,numbar)
temp = cos(theta-psi);
snew = s - s(idd);
tdiff = find(diff(sign(temp)));

shore = tdiff(tdiff < idd);
sea = tdiff(tdiff > idd);

if numbar == 1
if length(shore) <= 1 | shore(end-1) < 50
    iddshore = 1;
else
    iddshore = shore(end-1);
end
%if length(sea) <= 1
%[~,iddtemp] = min(temp);
%[~,iddtemp2] = min(iddtemp-sea(1));
%iddsea = iddtemp(iddtemp2);
if length(sea) < 1
    iddsea = s(end);
else
    iddsea = sea(1);
end
elseif numbar == 2
    if length(shore) <= 3 | shore(end-1) < 100
       iddshore = 1;
    else
       iddshore = shore(end-3);
    end
    if length(sea) < 1
       iddsea = s(end);
    else
       iddsea = sea(1);
    end
elseif numbar == 3 
    if length(shore) <= 5 | shore(end-1) < 150
       iddshore = 1;
    else
       iddshore = shore(end-5);
    end
    if length(sea) < 1
       iddsea = s(end);
    else
       iddsea = sea(1);
    end
end

%else
%    iddsea = sea(2);
%end
data = struct('iddshore',iddshore,'iddsea',iddsea);

