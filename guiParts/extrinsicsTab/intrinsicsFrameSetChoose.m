function intrinsicsFrameSetChoose(app)
global idir ioeoflag 

%Load Intrinsic File
iname=app.ListBox_4.Value;
load(fullfile(idir,iname));

%Check If We need to solve for fx
ioeoflag =isnan(intrinsics(5));


%% Make Entry visible or not
if ioeoflag==1
    app.FocalLengthEditField.Visible='on';
    app.FocalLengthEditFieldLabel_2.Visible='on';
    app.CheckBox_9.Visible='on';
    app.FocalLengthEditFieldLabel_3.Visible='on';
end

if ioeoflag==0
     app.FocalLengthEditField.Visible='off';
    app.FocalLengthEditFieldLabel_2.Visible='off';
    app.CheckBox_9.Visible='off';
        app.FocalLengthEditFieldLabel_3.Visible='off';

end

    
