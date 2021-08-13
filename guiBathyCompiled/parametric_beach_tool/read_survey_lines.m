function survey = read_survey_lines(fname)
% read and plot bathy
temp = xlsread(fname);
xx = temp(:,7);
yy = temp(:,8);
[X,Y] = meshgrid(min(xx):max(xx),min(yy):max(yy));
elev = griddata(xx,yy,temp(:,9),X,Y);

survey = struct('x',X(1,:)','y',Y(:,1),'elev',elev,'xx',xx,'yy',yy,'zz',temp(:,9));
