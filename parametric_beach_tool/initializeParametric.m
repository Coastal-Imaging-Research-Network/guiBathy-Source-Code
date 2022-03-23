function data = initializeParametric(shoreline,bar,varargin)

p = inputParser;
p.addRequired('shoreline');
p.addRequired('bar');
p.addOptional('xres',5.0);
p.addOptional('yres',10.0);
p.addOptional('hsea',4.5);
p.addOptional('hshore',1.5);
p.addOptional('xoff',700.0);
p.addOptional('hoff',7.5);
p.addOptional('beta_offshore',0.0088);
p.addOptional('beta_shoreline',0.10);
p.addOptional('x0',0.0);
p.addOptional('xmax',500);
p.addOptional('y0',-500.0);
p.addOptional('ymax',1500.0);
p.addOptional('feature_res',1.0);
p.addOptional('tide',0.0);
p.addOptional('numbars',1);
parse(p,shoreline,bar,varargin{:});

xres = p.Results.xres;
yres = p.Results.yres;
hsea = p.Results.hsea;
hshore = p.Results.hshore;
xoff = p.Results.xoff;
hoff = p.Results.hoff;
beta_off = p.Results.beta_offshore;
beta_shore = p.Results.beta_shoreline;
x0 = p.Results.x0;
xmax = p.Results.xmax;
y0 = p.Results.y0;
ymax = p.Results.ymax;
feature_res = p.Results.feature_res;
tide = p.Results.tide;
numbars = p.Results.numbars;


data = struct('shoreline',shoreline,'bar',bar,'xres',xres,'yres',yres, ...
    'hsea',hsea,'hshore',hshore,'xoff',xoff,'hoff',hoff,'beta_off',beta_off,'beta_shore',beta_shore, ...
    'x0',x0,'xmax',xmax,'y0',y0,'ymax',ymax,'feature_res',feature_res,'tide',tide, ...
    'numbars',numbars);

