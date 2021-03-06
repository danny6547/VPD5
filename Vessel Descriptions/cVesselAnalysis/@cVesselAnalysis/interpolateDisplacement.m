function [obj, dates_v, disp_v ] = interpolateDisplacement(obj, disp_tbl )
%interpolateDisplacement Summary of this function goes here
%   Detailed explanation goes here

    % Get nearest draft
    refTrim_v = disp_tbl.trim;
    refDisp_v = disp_tbl.displacement;
    refDraft_v = disp_tbl.draft_mean;
    
    evalTab_ch = 'tempRawISO';
    evalCols_c = {'Timestamp', 'Static_Draught_Fore', ...
        'Static_Draught_Aft', 'Trim'};
    
    [~, eval_tbl] = obj.SQL.select(evalTab_ch, evalCols_c);
    evalDraft_v = mean([eval_tbl.static_draught_fore, ...
        eval_tbl.static_draught_aft], 2);
    evalTrim_v = eval_tbl.trim;
%     dates_v = datenum(eval_tbl.datetime_utc, 'dd-mm-yyyy HH:MM:SS');
%     [~, dates_v] = obj(1).SQL.sql2matlabdates(eval_tbl.timestamp);
    dates_dt = datetime(eval_tbl.timestamp, 'ConvertFrom', 'datestr');
    dates_v = datenum(dates_dt);
    
    nearDraft_v = FindNearestInVector(evalDraft_v, refDraft_v);
    
    % Pre-allocate loop vector
    disp_v = nan(height(eval_tbl), 1);
    
    % Get nearest trim for each nearest displacement
    for ri = 1:height(eval_tbl)
        
        % Get all rows of displacement table with this displacement
        currDraft = nearDraft_v(ri);
        currTrim = evalTrim_v(ri);
        row_l = refDraft_v == currDraft;
        
        % Get nearest trim from those rows
        refTrimAtDraft_v = refTrim_v(row_l);
        nearTrim = FindNearestInVector(currTrim, refTrimAtDraft_v);
        
        % Get Reference Displacement at nearest draft, trim
        trim_l = refTrim_v == nearTrim;
        currDispTrim_i = find(row_l & trim_l, 1);
        disp_v(ri) = refDisp_v(currDispTrim_i);
    end
end