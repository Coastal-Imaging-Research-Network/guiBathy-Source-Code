function data = setup_geometry(data)

data.x = data.x0:data.xres:data.xmax;%data.xoff;
data.y = data.y0:data.yres:data.ymax;

%dy = 
data.ybar = data.y0:data.feature_res:data.ymax;
data.xbar = interp_feature(data.bar,data.ybar);

data.oldshore = data.shoreline;
data.shoreline(:,1) = adjust_tide(data.shoreline(:,1),data.beta_shore, ...
   data.tide);

data.yshore = data.y0:data.feature_res:data.ymax;
data.xshore = interp_feature(data.shoreline,data.yshore);

data.xdeep = repmat(data.xoff,[size(data.x)]);

data.xbar_min = min(data.xbar);
data.xbar_max = max(data.xbar);
data.ybar_min = min(data.ybar);
data.ybar_max = max(data.ybar);

data.h = zeros([length(data.y),length(data.x)]);
