function gridGenerationSave(app)
global gdir gridToTransfer

%% Save
gname=app.FilenameEditField_8.Value;

X=gridToTransfer.X;
Y=gridToTransfer.Y;
Z=gridToTransfer.Z;
localAngle=gridToTransfer.localAngle;
localOrigin=gridToTransfer.localOrigin;
localX=gridToTransfer.localX;
localY=gridToTransfer.localY;
localZ=gridToTransfer.localZ;
worldCoordSysH=gridToTransfer.worldCoordSysH;
worldCoordSysV=gridToTransfer.worldCoordSysV;
worldCoordSysUnits=gridToTransfer.worldCoordSysUnits;

save( fullfile(gdir, gname),'X','Y','Z','localAngle','localOrigin','localX','localY','localZ','worldCoordSysH','worldCoordSysV','worldCoordSysUnits')


%% Change Status Lamp
app.Lamp_14.Color=[0 1 0];