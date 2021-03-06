classdef testcVessel < matlab.unittest.TestCase
%TESTCVESSEL
%   Detailed explanation goes here

properties
    
    TestDatabase = 'static';
    TestInServiceDB = 'inservice';
    TestIMO = 1234567;
    TestVessel;
    TestcMySQL;
    SQLWhereVessel;
    SQLWhereEngine;
    SQLWhereSpeedPower;
    SQLWhereSpeedPowerModel;
    SQLWhereDisplacement;
    SQLWhereWind;
    SQLWhereOwner;
    SQLWhereToOwner;
end

methods
    
    function vessel = testVesselInsert(testcase)
        
        testDB = testcase.TestDatabase;
        vessel = cVessel('DatabaseStatic', testcase.TestDatabase,...
                'DatabaseInService', testcase.TestInServiceDB);
%         vessel.InServiceDB = testcase.TestInServiceDB;
        
        % Identity
        vessel.IMO = testcase.TestIMO;
        
        % Configuration
        vessel.Configuration.Transverse_Projected_Area_Design = 1000;
        vessel.Configuration.Length_Overall = 300;
        vessel.Configuration.Breadth_Moulded = 50;
        vessel.Configuration.Draft_Design = 10;
        vessel.Configuration.Anemometer_Height = 50;
        vessel.Configuration.Valid_From = '2000-01-01 00:00:00';
        vessel.Configuration.Valid_To = '2018-01-01 00:00:00';
        vessel.Configuration.Default_Configuration = true;
        vessel.Configuration.Speed_Power_Source = 'Sea Trial';
        vessel.Configuration.Wind_Reference_Height_Design = 30;
        vessel.Configuration.Vessel_Configuration_Description = 'Test Config';
        vessel.Configuration.Apply_Wind_Calculations = true;
        vessel.Configuration.Fuel_Type = 'HFO';
        vessel.Configuration.LBP = 250;
%         vessel.Configuration.Speed_Power_Coefficient_Model_Id = 1;
        
        % Vessel Info
        vessel.Info.Vessel_Name = 'Test vessel'; 
        vessel.Info.Valid_From = '2000-01-01 00:00:00'; 
        
        % Owner
        vessel.Owner.Vessel_Owner_Name = 'Hempel';
        vessel.Owner.Ownership_Start = '2000-01-01 00:00:00';
        vessel.Owner.Ownership_End = '2018-01-01 00:00:00';
        
        % Engine
        vessel.Engine.Engine_Model = 'Test Engine';
        vessel.Engine.X0 = 3;
        vessel.Engine.X1 = 2;
        vessel.Engine.X2 = 1;
        vessel.Engine.Minimum_FOC_ph = 4;
        vessel.Engine.Lowest_Given_Brake_Power = 5;
        vessel.Engine.Highest_Given_Brake_Power = 6;
        
        % Speed Power
        sp = cVesselSpeedPower('Size', [1, 2], 'SavedConnection', testDB);
        sp(1).Speed = [10, 15];
        sp(1).Power = [10, 15]*1e4;
        sp(1).Trim = 1;
        sp(1).Displacement = 1e5;
%         sp(1).Model_ID = 1;
        sp(1).Name = 'Speed Power test 1';
        sp(1).Description = 'the first one';
        sp(2).Speed = [5, 10, 15];
        sp(2).Power = [7, 9.5, 15]*1e4;
        sp(2).Trim = 0;
        sp(2).Displacement = 2e5;
%         sp(2).Model_ID = 2;
        sp(2).Name = 'Speed Power test 1';
        sp(2).Description = 'the first one';
        vessel.SpeedPower = sp;
        
        % Dry Dock
        ddd = cVesselDryDock('Size', [1, 2], 'SavedConnection', testDB);
        ddd(1).Start_Date = '2000-01-01';
        ddd(1).End_Date = '2000-01-14';
%         ddd(1).Model_ID = 1;
        ddd(2).Start_Date = '2001-01-01';
        ddd(2).End_Date = '2001-01-14';
%         ddd(2).Model_ID = 2;
        vessel.DryDock = ddd;
        
        % Displacement
%         vessel.Displacement.Model_ID = 1;
        heightDispTable = 2;
        vessel.Displacement.Draft_Mean = [10, 12];
        vessel.Displacement.Trim = [0, 1];
        vessel.Displacement.Displacement = [1e5, 1.5e5];
        vessel.Displacement.TPC = nan(1, heightDispTable);
        vessel.Displacement.LCF = nan(1, heightDispTable);
        
        % Wind
%         vessel.WindCoefficient.Model_ID = 1;
        vessel.WindCoefficient.Direction = [0, 10, 45];
        vessel.WindCoefficient.Coefficient = [0.3, 0.5, 1];
        
%         vessel.Vessel_Id = 1;
    end
end

methods(TestClassSetup)

    function createDB(testcase)
    % createDB Create database for Vessel if it doesn't exist
    
    testDB = testcase.TestDatabase;
    obj = cDB('SavedConnection', testDB);
    [obj, isDB] = obj.SQL.existDB(testcase.TestDatabase);
    
    if ~isDB

        obj.InsertStatic = false;
        obj.createStatic();
    end
    end
    
    function insertVessel(testcase)
    % Insert test vessel into DB
    
    vessel = testcase.testVesselInsert;
    vessel.insert();
    
    % Assign
    testcase.TestVessel = vessel;
    
    % Assign cMySQL object
    testDB = testcase.TestDatabase;
    testcase.TestcMySQL = cMySQL('SavedConnection', testDB);

    % Assign where SQL
    vid = vessel.Model_ID;
    spid = [vessel.SpeedPower.Model_ID];
    did = vessel.Displacement.Model_ID;
    wid = vessel.WindCoefficient.Model_ID;
    spmid = vessel.Configuration.Speed_Power_Coefficient_Model_Id;
    oid = vessel.Owner.Vessel_Owner_Id;
    void = vessel.Owner.Vessel_To_Vessel_Owner_Id;
    where_sql = ['Vessel_Id = ', num2str(vid)];
    whereEngine_sql = ['Engine_Model = ''', vessel.Engine.Engine_Model, ''''];
    whereSP_sql = ['Speed_Power_Coefficient_Model_Value_Id IN (', sprintf('%u, %u', spid), ')'];
    whereSPModel_sql = ['Speed_Power_Coefficient_Model_Id = ', num2str(spmid)];
    whereDisp_sql = ['Displacement_Model_Id = ', num2str(did)];
    whereWind_sql = ['Wind_Coefficient_Model_Id = ', num2str(wid)];
    whereOwner_sql = ['Vessel_Owner_Id = ', num2str(oid)];
    whereToOwner_sql = ['Vessel_To_Vessel_Owner_Id = ', num2str(void)];

    testcase.SQLWhereVessel = where_sql;
    testcase.SQLWhereEngine = whereEngine_sql;
    testcase.SQLWhereSpeedPower = whereSP_sql;
    testcase.SQLWhereSpeedPowerModel = whereSPModel_sql;
    testcase.SQLWhereDisplacement = whereDisp_sql;
    testcase.SQLWhereWind = whereWind_sql;
    testcase.SQLWhereOwner = whereOwner_sql;
    testcase.SQLWhereToOwner = whereToOwner_sql;
    
    end
    
    function deleteRaw(testcase)
        
        vessel = testcase.testVesselInsert();
        vid = vessel.Vessel_Id;
        sql = ['DELETE FROM `', testcase.TestInServiceDB, '`.RawData WHERE Vessel_Id = ' num2str(vid) ];
        testcase.TestcMySQL.execute(sql);
    end
    
    function deleteCalculated(testcase)
        
        vessel = testcase.testVesselInsert();
        vid = vessel.Configuration.Model_ID;
        sql = ['DELETE FROM `', testcase.TestInServiceDB, '`.CalculatedData WHERE Vessel_Configuration_Id = ' num2str(vid)];
        testcase.TestcMySQL.execute(sql);
    end
end

methods(TestMethodSetup)
    
    function insertVessel2Read(testcase)
    % Ensure that vessel for testing read methods is in DB
        
        
    end
end

methods(TestClassTeardown)

    function deleteTestVessel(testcase)
    % Ensure that vessel for testing insert methods is not in DB
    
        vessel = testcase.testVesselInsert;
        deleteFromDB(vessel);
%     vessel = testcase.testVesselInsert;
%     
%     where_sql = testcase.SQLWhereVessel;
%     whereEngine_sql = testcase.SQLWhereEngine;
%     whereSP_sql = testcase.SQLWhereSpeedPower;
%     whereSPModel_sql = testcase.SQLWhereSpeedPowerModel;
%     whereDisp_sql = testcase.SQLWhereDisplacement;
%     whereWind_sql = testcase.SQLWhereWind;
%     whereOwner_sql = testcase.SQLWhereOwner;
%     
%     vessel.SQL.deleteSQL('EngineModel', whereEngine_sql);
%     vessel.SQL.deleteSQL('SpeedPower', whereSP_sql);
%     vessel.SQL.deleteSQL('SpeedPowerCoefficientModel', whereSPModel_sql);
%     vessel.SQL.deleteSQL('SpeedPowerCoefficientModelValue', whereSPModel_sql);
%     vessel.SQL.deleteSQL('DisplacementModel', whereDisp_sql);
%     vessel.SQL.deleteSQL('DisplacementModelValue', whereDisp_sql);
%     vessel.SQL.deleteSQL('WindCoefficientModel', whereWind_sql);
%     vessel.SQL.deleteSQL('WindCoefficientModelValue', whereWind_sql);
%     
%     vessel.SQL.deleteSQL('Vessel', where_sql);
%     vessel.SQL.deleteSQL('VesselInfo', where_sql);
%     vessel.SQL.deleteSQL('VesselConfiguration', where_sql);
%     vessel.SQL.deleteSQL('VesselToVesselOwner', where_sql);
%     vessel.SQL.deleteSQL('BunkerDeliveryNote', where_sql);
%     vessel.SQL.deleteSQL('DryDock', where_sql);
%     vessel.SQL.deleteSQL('VesselOwner', whereOwner_sql);
%     vessel.SQL.deleteSQL('VesselToVesselOwner', whereOwner_sql);
    
    end
    
end
end