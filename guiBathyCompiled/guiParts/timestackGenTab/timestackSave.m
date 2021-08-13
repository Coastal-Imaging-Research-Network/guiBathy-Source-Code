function timestackSave(app)
global tsdir stacktran


data=stacktran.data;
t=stacktran.t;
xyz=stacktran.xyz;
stackMeta.AdaptNum=stacktran.stackMeta.AdaptNum;
stackMeta.Res=stacktran.stackMeta.Res;
stackMeta.Orthoset=stacktran.stackMeta.Orthoset;
stackMeta.Units=stacktran.stackMeta.Units;
stackMeta.worldCoordSysV=stacktran.stackMeta.worldCoordSysV;
stackMeta.worldCoordSysH=stacktran.stackMeta.worldCoordSysH;
Io=stacktran.Io;
x=stacktran.x;
y=stacktran.y;
z=stacktran.z;
tide=stacktran.tide;
save(fullfile(tsdir,app.FilenameEditField_10.Value),'data','t','xyz','stackMeta','x','y','z','tide','Io','-v7.3');

%% Change Status Lamp
app.Lamp_18.Color=[0 1 0];