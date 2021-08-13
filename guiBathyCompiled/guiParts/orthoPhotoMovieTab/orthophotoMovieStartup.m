function  orthophotoMovieStartup(app)

global ordir 
%% Check Project Loaded
if isempty(ordir)==1
    return
end
 %% Set up the Frame ListBox
v= app.ListBox_15.Value;

L=dir(ordir );
app.ListBox_15.Items={}; 
for k=3:length(L)
    app.ListBox_15.Items{k-2}=L(k).name;
end 
app.ListBox_15.Value=v;
app.ListBox_15.Items{end+1}='-';


%% Specify Quality List
app.QualityAffectsMovieSizeListBox.Items{1}='100% No Compression';
app.QualityAffectsMovieSizeListBox.Items{2}='90%';
app.QualityAffectsMovieSizeListBox.Items{3}='75%';
app.QualityAffectsMovieSizeListBox.Items{4}='50%';
app.QualityAffectsMovieSizeListBox.Items{5}='25% High Compression';

app.PlaybackSpeedListBox.Items{1}='RealTime';
app.PlaybackSpeedListBox.Items{2}='2x';
app.PlaybackSpeedListBox.Items{3}='5x';
app.PlaybackSpeedListBox.Items{4}='10x';
app.PlaybackSpeedListBox.Items{5}='20x';
app.PlaybackSpeedListBox.Value='RealTime';
