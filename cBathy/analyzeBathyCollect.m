function bathy = analyzeBathyCollect(xyz, epoch, data, cam, bathy)

%%
%
%  bathy = analyzeBathyCollect(xyz, epoch, data, cam, bathy);
%
%  cBathy main analysis routine.  Input data from a time
%  stack includes xyz, epoch and data as well as the initial fields
%  of the bathy structure.  Returns an
%  augmented structure with new fields 'fDependent' that contains all
%  the frequency dependent results and fCombined that contains the
%  estimated bathymetry and errors.
%  bathy input is expected to have fields .epoch, .sName and .params.
%  All of the relevant analysis parameters are contained in params.
%  These are usually set in an m-file (or text file) BWLiteSettings or
%  something similar that is loaded in the wrapper routine
%  NOTE - we assume a coordinate system with x oriented offshore for
%  simplicity.  If you use a different system, rotate your data to this
%  system prior for analysis then un-rotate after.
%
% Inputs: 
%   xyz -- xyz coordinates of the grid (z is typically all 0's
%   epoch -- time of each frame in *seconds*
%   data  -- image data for each time and each xyz (this is the data stack)
%   cam   -- camera index of each pixel (in the single camera case, this
%            should be an array of all 1's that is length(xyz) x 1
%   bathy -- this is the parameter list from the inputs file


% record version
myVer = cBathyVersion();
bathy.ver = myVer;
if isempty(ver('stats'))        % forced to use local LMFit if no stats toolbox
    bathy.params.nlinfit = 0;
end

%% prepare data for analysis
[f, G, bathy] = prepBathyInput( xyz, epoch, data, bathy );

if( cBDebug( bathy.params, 'DOPLOTSTACKANDPHASEMAPS' ) )
    plotStacksAndPhaseMaps( xyz, epoch, data, f, G, bathy.params );
    input('Hit return to continue ')
    close(10); close(11);
end

% create and save a time exposure
IBar = mean(data);
xy = bathy.params.xyMinMax;
dxy = [bathy.params.dxm bathy.params.dym];
pa = [xy(1) dxy(1) xy(2) xy(3) dxy(2) xy(4)];  % create the pixel array
[xm,ym,map, wt] = findInterpMap(xyz, pa, []);
timex = useInterpMap(IBar,map,wt);
bathy.timex = reshape(timex,length(ym), length(xm));

%% now loop through all x's and y's

if( cBDebug( bathy.params, 'DOSHOWPROGRESS' ))
    figure(21);clf
    plot(xyz(:,1), xyz(:,2), '.'); axis equal; axis tight
    xlabel('x (m)'); ylabel('y (m)')
    title('Analysis Progress'); drawnow;
    hold on
end
% str = [bathy.sName(16:21) ', ' bathy.sName(36:39) ', ' bathy.sName([23 24 26 27])];
%if cBDebug( bathy.params )
	hWait = waitbar(0, 'cBathy Processing Progress');
%end;

% turn off warnings
    warning('off', 'stats:nlinfit:IterationLimitExceeded')
    warning('off', 'stats:nlinfit:RankDeficient')

for xind = 1:length(bathy.xm)
    disp(['transect ' num2str(xind) '/' num2str(length(bathy.xm)) 'at ' datestr(now)])
%    if cBDebug( bathy.params )
	    waitbar(xind/length(bathy.xm), hWait)
%    end;
    fDep = {};  %% local array of fDependent returns
    
    if( cBDebug( bathy.params, 'DOSHOWPROGRESS' ))
        for yind = 1:length(bathy.ym)
            [fDep{yind},camUsed(yind)] = csmInvertKAlpha( f, G, xyz(:,1:2), cam, ...
                bathy.xm(xind), bathy.ym(yind), bathy );
        end
    else
        parfor yind = 1:length(bathy.ym)
              [fDep{yind},camUsed(yind)] = csmInvertKAlpha( f, G, xyz(:,1:2), cam, ...
                bathy.xm(xind), bathy.ym(yind), bathy );
        end  %% parfor yind
    end
    
    % stuff fDependent data back into bathy (outside parfor)
    for ind = 1:length(bathy.ym)        
        bathy.fDependent.kSeed(ind,xind,:) = fDep{ind}.kSeed;
        bathy.fDependent.aSeed(ind,xind,:) = fDep{ind}.aSeed;
        bathy.fDependent.camUsed(ind,xind) = camUsed(ind);
        if( any( ~isnan( fDep{ind}.k) ) )  % not NaN, valid data.
            bathy.fDependent.fB(ind, xind, :) = fDep{ind}.fB(:);
            bathy.fDependent.k(ind,xind,:) = fDep{ind}.k(:);
            bathy.fDependent.a(ind,xind,:) = fDep{ind}.a(:);
            bathy.fDependent.dof(ind,xind,:) = fDep{ind}.dof(:);
            bathy.fDependent.skill(ind,xind,:) = fDep{ind}.skill(:);
            bathy.fDependent.lam1(ind,xind,:) = fDep{ind}.lam1(:);
            bathy.fDependent.kErr(ind,xind,:) = fDep{ind}.kErr(:);
            bathy.fDependent.aErr(ind,xind,:) = fDep{ind}.aErr(:);
            bathy.fDependent.hTemp(ind,xind,:) = fDep{ind}.hTemp(:);
            bathy.fDependent.hTempErr(ind,xind,:) = fDep{ind}.hTempErr(:);
            bathy.fDependent.NPixels(ind,xind,:) = fDep{ind}.NPixels;
            bathy.fDependent.NCalls(ind,xind,:) = fDep{ind}.NCalls;
        end
        
    end
        
end % xind
%if cBDebug( bathy.params )
	delete(hWait);
%end;

% turn warnings back on
    warning('on', 'stats:nlinfit:IterationLimitExceeded')
    warning('on', 'stats:nlinfit:RankDeficient')

%% Find estimated depths and tide correct, if tide data are available.
 
bathy = bathyFromKAlpha(bathy);

%bathy = fixBathyTide(bathy);

%   Copyright (C) 2017  Coastal Imaging Research Network
%                       and Oregon State University

%    This program is free software: you can redistribute it and/or
%    modify it under the terms of the GNU General Public License as
%    published by the Free Software Foundation, version 3 of the
%    License.

%    This program is distributed in the hope that it will be useful,
%    but WITHOUT ANY WARRANTY; without even the implied warranty of
%    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%    GNU General Public License for more details.

%    You should have received a copy of the GNU General Public License
%    along with this program.  If not, see
%                                <http://www.gnu.org/licenses/>.

% CIRN: https://coastal-imaging-research-network.github.io/
% CIL:  http://cil-www.coas.oregonstate.edu
%
%key cBathy
%

