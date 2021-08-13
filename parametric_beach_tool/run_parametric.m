function [data] = run_parametric(input)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

disp("intialize the model with input")
data = initializeParametric(input.shoreline,input.bar, ...
    'xres',input.xres,'yres',input.yres,'hsea',input.hsea, ...
    'xoff',input.xoff,'hoff',input.hoff,'beta_offshore', ...
    input.beta_offshore,'beta_shoreline',input.beta_shoreline, ...
    'x0',input.x0,'xmax',input.xmax,'y0',input.y0,'ymax', ...
    input.ymax,'feature_res',input.feature_res,'tide',input.tide);

disp("setup geometry")
data = setup_geometry(data);
disp("calculate bathymetry")
data = calculate_h(data);



%% Brittanys Quick Tide Fix
% % If a Negative Tide
% if input.tide<0
% bind=find(-data.h>input.tide.*.75); %give wiggle room  
% data.h(bind)=nan;
% end
% 
% % If A positive TIde
% 
% if input.tide>0
% 
% % Interpolate Shoreline Onto output grid
% slx=interp1(input.shoreline(:,2),input.shoreline(:,1),data.y);
% 
% % For each profile
% for k=1:length(data.y)
%     % get rid of nans onshore of shoreline
%     bind=find(-data.h(k,:)==0);
%     data.h(k,bind)=nan;
%     
%     %This only works sometimes- putting on hold  - has trouble with some
%     %instabilities in pb output.
% %     % Find most onshore non-nan value, set back to zero
% %     [max_ind]=max(bind);
% %       data.h(k,max_ind)=0;
% %      
% %      
% %      % Get Slope
% %      xm=data.x(max_ind);
% %      xt=slx(k);
% %      m=(-input.tide)./((xt-xm));
% %      b=-xm*m;
% %      
% %      % Extrapolate Out
% %      data.h(k,bind)= m*data.x(bind)+b;
% %      % Find values bigger then tide
% %      bind2=find(-data.h(k,:)>(input.tide*1.25)); % give wiggle room
% %      data.h(k,bind2)=nan;
% 
% end
% end
