function obj = loadBergeNoon(obj, filename, sheetname, basedate, varargin)
%loadBergeNoon Load data from Berge Bulk noon data file
%   Detailed explanation goes here

filename = validateCellStr(filename, 'loadBergeNoon', 'filename', 2);

for fi = 1:numel(filename)

    currFile = filename{fi};
    
    % Input
    sheetDate_l = false;
    if nargin < 3 % isempty(sheetname)

        % Get sheet names matching expected post-2012 pattern 
        [~, sh] = xlsfinfo(currFile);
        sheetNameLog_c = regexp(sh, '\d\d.\d\d');
        sheetDate_l = cellfun(@(x) isequal(x, 1), sheetNameLog_c);

        if ~any(sheetDate_l)

            errid = 'loadBerge:NoSheetPre2012';
            errmsg = ['If sheet names are not input, sheets in file are '...
                'expected to have name format MONTH.DATE'];
            error(errid, errmsg);
        end
        sheetname = sh(sheetDate_l);
    end

    if nargin < 4 && any(sheetDate_l)

        % Get base date from sheet names
        basedate = datenum(sheetname, 'mm.yy');

    elseif nargin < 4 && ~any(sheetDate_l)

        % Cannot get base date from sheet names
        errid = 'loadBerge:NoSheetPre2012NoDate';
        errmsg = ['If file does not contain sheets with names in the '...
            'format MONTH.DATE, input BASEDATE must be given'];
        error(errid, errmsg);
    end

    validateCellStr(sheetname, 'cVessel.loadBergeNoon', 'sheetname', 1);
    validateattributes(basedate, {'numeric'}, {'real', 'positive', ...
        '>=', datenum('01-01-1950')}, 'cVessel.loadBergeNoon', 'baseDate', 2);

    imo = obj.IMO_Vessel_Number;
    if isempty(imo)

        errid = 'loadBerge:NeedIMO';
        errmsg = ['To load data from file, IMO Vessel Number must be given '...
            'in the appropriate property of OBJ.'];
        error(errid, errmsg);
    end

    if ~isequal(numel(sheetname), numel(basedate))

        errid = 'loadBerge:SheetDateSizeMismatch';
        errmsg = 'Number of sheet names input must match number of base dates';
        error(errid, errmsg);
    end

    % Create SQL date string this sheet
    baseDate_ch = datestr(basedate, 'yyyy-mm-dd');
    baseDate_c = cellstr(baseDate_ch);

    validateattributes(imo, {'numeric'}, {'scalar', 'positive', 'integer'}, ...
       'cVessel.loadDNVGLReportingFormat', 'imo', 3);
    set2_sql = ['IMO_Vessel_Number = ', num2str(imo), ...
        ', Speed_Through_Water = knots2mps(nullif(@Speed_Over_Ground, '''') + nullif(@Current, ''''))'];

    for si = 1:numel(sheetname)

        baseDate_ch = baseDate_c{si};
        baseDate_sql = ['STR_TO_DATE(''' baseDate_ch ''', ''%Y-%m-%d'') - 1'] ;

        p = inputParser();
        p.addParameter('mainSheet', 'JAN');
        p.addParameter('firstRowIdx', 7);
        p.addParameter('tab', 'RawData');
        p.addParameter('fileColID', [1, 10, 11, 12, 18, 25, 26, 14, 20, 21]);
        p.addParameter('fileColName', {...
                        'DayOfMonth',               ...
                        'Speed_Over_Ground',        ...
                        'Wind_Force',               ...
                        'Relative_Wind_Direction',  ...
                        'Delivered_Power',          ...
                        'Static_Draught_Fore',      ...
                        'Static_Draught_Aft'        ...
                        'Current'                   ...
                        'MECons'                    ...
                        'AECons'                    ...
                                   });
        p.addParameter('tabColNames', {             ...
                        'DateTime_UTC',             ...
                        'Speed_Over_Ground',        ...
                        'Relative_Wind_Speed',      ...
                        'Relative_Wind_Direction',  ...
                        'Delivered_Power',          ...
                        'Mass_Consumed_Fuel_Oil',   ...
                        'Static_Draught_Fore',      ...
                        'Static_Draught_Aft'        ...
                        'Speed_Through_Water'
                                   });
        p.addParameter('SetSQL', ...
                    {['DateTime_UTC = STR_TO_DATE(@DayOfMonth, ''%d'') + ' baseDate_sql],...
                    ['Relative_Wind_Speed = CASE '...
                    'WHEN @Wind_Force = 0 THEN 0.1500 ',...
                    'WHEN @Wind_Force = 1 THEN 0.9 ',...
                    'WHEN @Wind_Force = 2 THEN 2.45 ',...
                    'WHEN @Wind_Force = 3 THEN 4.45 ',...
                    'WHEN @Wind_Force = 4 THEN 6.7 ',...
                    'WHEN @Wind_Force = 5 THEN 9.35 ',...
                    'WHEN @Wind_Force = 6 THEN 12.3 ',...
                    'WHEN @Wind_Force = 7 THEN 15.5 ',...
                    'WHEN @Wind_Force = 8 THEN 18.95 ',...
                    'WHEN @Wind_Force = 9 THEN 22.6 ',...
                    'WHEN @Wind_Force = 10 THEN 26.45 ',...
                    'WHEN @Wind_Force = 11 THEN 30.55 ',...
                    'WHEN @Wind_Force = 12 THEN 34.7 ',...
                    'END']...
                    'Mass_Consumed_Fuel_Oil = nullif(@MECons, '''') + nullif(@AECons, '''')',...
                    'Speed_Over_Ground = knots2mps(@Speed_Over_Ground)'...
                    });
        paramValues_c = varargin;
        p.parse(paramValues_c{:});
    %     mainSheet = p.Results.mainSheet;
        firstRowIdx = p.Results.firstRowIdx;
        fileColID = p.Results.fileColID;
        tab = p.Results.tab;
        fileColName = p.Results.fileColName;
        tabColNames = p.Results.tabColNames;
        SetSQL = p.Results.SetSQL;

        % Concatenate all set commands
        SetSQL = [SetSQL, set2_sql];

        % Load time-seres data from xlsx
        currSheet = sheetname{si};
        obj = obj.loadXLSX(currFile, currSheet, firstRowIdx - 1, fileColID, ...
            fileColName, tab, tabColNames, SetSQL, '', 36);
    end
end
end