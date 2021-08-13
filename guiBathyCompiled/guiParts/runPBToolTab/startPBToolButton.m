function startPBToolButton(app)
global  pbTran slLine sbLine


%% Pull Units
% Format Correctly into meters/feet
if strcmp(pbTran.Units,'m')==1
    fc=1;
end
if strcmp(pbTran.Units,'m')==0
    fc=12.*2.54./100;
end

%% Define Parameters for Input into Tool
feature_res=mean(diff(pbTran.X(1,:)));


xres=app.UITable12.Data{1,1};
yres=app.UITable12.Data{1,2};

x0=pbTran.X(1,1);
xmax=pbTran.X(1,end);
% ymax=pbTran.Y(end,1);
% y0=pbTran.Y(1,1);
y0=min(slLine.YData);
ymax=max(slLine.YData);


hsea=abs(app.UITable11.Data{1,2});
xoff=app.EditField_2.Value;
hoff=abs(app.UITable11.Data{1,1});

beta_offshore=abs(app.UITable11.Data{1,3});
beta_shoreline=abs(app.UITable11.Data{1,4});


input = struct('xres',xres.*fc,'yres',yres.*fc,'hsea',hsea.*fc, ...
    'xoff',xoff.*fc,'hoff',hoff.*fc,'beta_offshore', ...
    beta_offshore,'beta_shoreline',beta_shoreline, ...
    'x0',x0.*fc,'xmax',xmax.*fc,'y0',y0.*fc,'ymax', ...
    ymax.*fc,'feature_res',feature_res.*fc,'tide',pbTran.tide*fc);

input.bar=[sbLine.XData(:), sbLine.YData(:)].*fc;
input.shoreline=[slLine.XData(:), slLine.YData(:)].*fc;



data = run_parametric(input);

%% Convert Back
data.shoreline=data.shoreline./fc;
data.bar=data.bar./fc;
data.xres=data.xres./fc;
data.yres=data.yres./fc;
data.hsea=data.hsea./fc;
data.xoff=data.xoff./fc;
data.hoff=data.hoff./fc;
data.x0=data.x0./fc;
data.xmax=data.xmax./fc;
data.y0=data.y0./fc;
data.ymax=data.ymax./fc;
data.feature_res=data.feature_res./fc;
data.x=data.x./fc;
data.y=data.y./fc;
data.ybar=data.ybar./fc;
data.xbar=data.xbar./fc;
data.xshore=data.xshore./fc;
data.yshore=data.yshore./fc;
data.xdeep=data.xdeep./fc;
data.xbar_min=data.xbar_min./fc;
data.xbar_max=data.xbar_max./fc;
data.ybar_min=data.ybar_min./fc;
data.ybar_max=data.ybar_max./fc;
data.h=data.h./fc;


%% Change Status
app.Lamp_25.Color=[0 1 0];

%% Pass Along parameters and data
pbTran.input=input;
pbTran.data=data;


