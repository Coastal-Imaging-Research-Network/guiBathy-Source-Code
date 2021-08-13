function stabilizationSCPchoose(app)

global  scudir

%% Get and Load Values
scpfile=app.ListBox_7.Value;
load(fullfile(scudir,scpfile));


%% Clear old SCPs
%% Reset Fig
m=length(app.UIAxes_8.Children);

    for k=1:(m-1)
app.UIAxes_8.Children(m-k).Visible='off';
    end

    
    
%% Plot SCPs



    hold(app.UIAxes_8,'on')
for k=1:length(scp)
plot(scp(k).UVdo(1),scp(k).UVdo(2),'ro','markersize',10,'linewidth',3,'parent',app.UIAxes_8);
   text(scp(k).UVdo(1).*.95,scp(k).UVdo(2),num2str(scp(k).num),'parent',app.UIAxes_8,'fontweight','bold','fontsize',15,'color','r');
end

%% Add SCP to Table
for k=1:length(scp)
    
app.UITable9_2.RowName{k,1}=['SCP ' num2str(scp(k).num)];
app.UITable9_2.Data{k,1}='';
end

   %% Reset Tables
   stablizationReset(app)
%% Turn off legend
legend(app.UIAxes_8,'off')