function noDistStabilizeButton(app)
global R pointsA fdir ptThresh TFORM Ro


%% Get Frame List
fname=app.ListBox_34.Value;
L=dir(fullfile(fdir,fname));

%% Clear From Previous Try
clear tform
clear Ro

%% Get Ro
count=0;
for k=1:length(R)
    try
        Ro(k,:)=R{k}.Position;
        count=count+1;
    catch
        continue
    end
end


%% Load First Image and Clear Axes
I1=rgb2gray(imread(fullfile(L(3).folder,L(3).name)));   
hold(app.UIAxes_16,'off')


%% Go Through Images
for k=3:length(L)

%Load
In=rgb2gray(imread(fullfile(L(k).folder,L(k).name)));   

% Get Rs
pointsB=cornerPoints;
for j=1:length(Ro(:,1))
        pb=detectFASTFeatures(In, 'MinContrast', ptThresh,'ROI',Ro(j,:));
        
        pointsB=cat(2,pointsB,pb);
        [C, ia, ic]=unique(pointsB.Location,'rows');
        pointsB=pointsB(ia) ;  
end
 
% Match Features
[featuresA, pointsAn] = extractFeatures(I1, pointsA);
[featuresB, pointsB] = extractFeatures(In, pointsB);

indexPairs = matchFeatures(featuresA, featuresB);
pointsAn = pointsAn(indexPairs(:, 1), :);
pointsB = pointsB(indexPairs(:, 2), :);

showMatchedFeatures(I1, In, pointsAn, pointsB,'Parent',app.UIAxes_16);

[tform(k-2), inlierIdx] = estimateGeometricTransform2D(...
    pointsB, pointsAn, 'projective');

title(app.UIAxes_16,['Frame ' num2str(k-2) ' of ' num2str(length(L(3:end,1)))])
    
end

TFORM=tform;
%% Sigfnify Done
app.Lamp_32.Color=[ 0 .5 0];