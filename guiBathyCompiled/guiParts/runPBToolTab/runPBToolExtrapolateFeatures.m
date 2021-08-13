function runPBToolExtrapolateFeatures(app)
global pbTran sbLine slLine exSbFlag exSlFlag


%% Sandbar
if app.Lamp_23.Color==[0 1 0]  & app.Lamp_22.Color==[0 1 0]  % If both clicked


%% If it already had been extended, remove tailing values
if exSbFlag==1
    pbTran.sby=pbTran.sby(2:(end-1));
    pbTran.sbx=pbTran.sbx(2:(end-1));
end

if exSlFlag==1
    pbTran.sly=pbTran.sly(2:(end-1));
    pbTran.slx=pbTran.slx(2:(end-1));
end



    % Sort the Data by Y Value
    [pbTran.sby i]=sort(pbTran.sby);
    pbTran.sbx=pbTran.sbx(i);
    
        [pbTran.sly i]=sort(pbTran.sly);
        pbTran.slx=pbTran.slx(i);
    
    % Add Values
    pbTran.sbx=cat(1,pbTran.sbx(1), pbTran.sbx, pbTran.sbx(end));
    pbTran.sby=cat(1,app.EditField_5.Value, pbTran.sby, app.EditField_6.Value);
    
        % Add Values
    pbTran.slx=cat(1,pbTran.slx(1), pbTran.slx, pbTran.slx(end));
    pbTran.sly=cat(1,app.EditField_5.Value, pbTran.sly, app.EditField_6.Value);
    
    %% Check for duplicate points
    [pbTran.sly,ia,ic] = unique(pbTran.sly)
    pbTran.slx=pbTran.slx(ia);
    
    [pbTran.sby,ia,ic] = unique(pbTran.sby)
    pbTran.sbx=pbTran.sbx(ia);    
    
    
    % Replot
    sbLine.YData=pbTran.sby;
    sbLine.XData=pbTran.sbx;
    
        % Replot
    slLine.YData=pbTran.sly;
    slLine.XData=pbTran.slx;
    %% Change lamp
app.Lamp_28.Color=[0 1 0];
exSlFlag=1;
exSbFlag=1;
end

disp(pbTran.sby)


    


 






