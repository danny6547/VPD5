function [ obj, ddImprove ] = dryDockingImprovement( obj, varargin )
%dryDockingPerformance Performance improvement due to dry-docking.
%   Detailed explanation goes here

% Inputs
% varname = 'Performance_Index';
% if nargin > 1
%     
%     checkVarname( perStruct, varargin{1} );
% end

% Output
ddImp = struct('AvgPerPrior', [], 'AvgPerAfter', [], ...
    'AbsDDImprovement', [], 'RelDDImprovement', []);
ddImprove = struct('DryDockingInterval', ddImp);
[obj.DryDockingImprovement] = deal(ddImp);
% szIn = size(obj);
% szIn(1) = szIn(1) - 1;
% ddImp = repmat(ddImp, szIn);

% Input
% validateattributes(obj, {'struct'}, {}, 'performanceMark', 'obj',...
%     1);

% Get annual averages before and after dry-dockings
[~, annualAvgAft] = movingAverage(obj, 365.25, false);
[~, annualAvgBef] = movingAverage(obj, 365.25, true);

% Iterate over guarantee struct to get averages

while obj.iterateDD
% while ~obj.iterFinished
   
%       [obj, ii, afterDDi, beforeDDi, DDi] = obj.iterDD;
   
% idx_c = cell(1, ndims(obj));
% for ii = 1:nDDi:numel(obj)
%    
%    [idx_c{:}] = ind2sub(szIn, ii);
%    
%    % Plot each DDi separately
%    for ddi = 2:nDDi
%        
%        % Skip to end if fewer avg than vessels
%        if afterDDi > numel(annualAvgBef)
%            [obj.IterFinished] = deal(true);
%            break
%        end
%        % Skip DDi if empty
%        if isPerDataEmpty(obj(ii))
%            continue
%        end
    
    % 
    [~, currVessel, ddi, vi] = obj.currentDD;
    
    if ddi == 1
        continue
    end
    
    % If there are at least one years worth of data either side of DD
    if ~isempty(annualAvgBef(vi).DryDockInterval(ddi-1).Average) && ...
           ~isempty(annualAvgAft(vi).DryDockInterval(ddi).Average)
%         ~isempty(annualAvgBef(vi).DryDockInterval(ddi)) && ...
%            ~isempty(annualAvgAft(vi).DryDockInterval(ddi)) && ...
       
       % Compare with previous dry docking
       avgBefore = annualAvgBef(vi).DryDockInterval(ddi-1).Average(end);
       avgAfter = annualAvgAft(vi).DryDockInterval(ddi).Average(1);
       ddImpAbs = (avgAfter - avgBefore) * 100;
       ddImpRel = - ((avgBefore - avgAfter) / avgBefore) * 100;
       
       % Assign
       ddImp(1).AvgPerPrior = avgBefore;
       ddImp(1).AvgPerAfter = avgAfter;
       ddImp(1).AbsDDImprovement = ddImpAbs;
       ddImp(1).RelDDImprovement = ddImpRel;
       ddImprove(vi).DryDockingInterval(ddi) = ddImp;
       currVessel.DryDockingImprovement(ddi) = ddImp;
%        obj(vi).DryDockingImprovement = ddImp(ddi);
    end
   
%    % Assign into vessel
%    if ddi == currVessel.numDDIntervals
%         currVessel.DryDockingImprovement = ddImp;
%    end
%    end
end

% obj.
% obj = obj.iterReset;