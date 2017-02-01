/* Create tempRaw table, a temporary table used to insert data from DNVGLRaw to RawData */

DROP PROCEDURE IF EXISTS createTempRaw;

delimiter //

CREATE PROCEDURE createTempRaw(imo INT)

BEGIN

DROP TABLE IF EXISTS tempRaw;
/* CREATE TABLE tempRaw LIKE dnvglraw; */

CREATE TABLE tempRaw (
id INTEGER AUTO_INCREMENT PRIMARY KEY,
IMO_Vessel_Number	INT,
DateTime_UTC 		DATETIME,
CONSTRAINT UniqueIMODates UNIQUE(IMO_Vessel_Number, DateTime_UTC),
AE_1_Running_Hours	DOUBLE(20, 5),
AE_2_Running_Hours	DOUBLE(20, 5), 
Date_Local	DOUBLE(20, 5), 
AE_3_Running_Hours	DOUBLE(20, 5), 
Time_Local	DOUBLE(20, 5), 
Voyage_From	DOUBLE(20, 5), 
Voyage_To	DOUBLE(20, 5), 
Voyage_Number	DOUBLE(20, 5), 
AE_Consumption	DOUBLE(20, 5), 
Boiler_Consumption	DOUBLE(20, 5), 
Latitude_North_South	CHAR(1), 
Cargo_Mt	DOUBLE(20, 5), 
Current_Dir	INT, 
Longitude_East_West	CHAR(1), 
Current_Speed	DOUBLE(20, 5), 
Date_UTC	DATE, 
Distance	DOUBLE(20, 5), 
Sea_state_Dir	DOUBLE(20, 5), 
Sea_state_Force_Douglas	DOUBLE(20, 5), 
Draft_Actual_Aft	DOUBLE(20, 5), 
Draft_Actual_Fore	DOUBLE(20, 5), 
Draft_Displacement_Actual	DOUBLE(20, 5), 
Temperature_Ambient	DOUBLE(20, 5), 
Latitude_Degree	INT, 
Latitude_Minutes	INT, 
Longitude_Degree	INT, 
Draft_Recommended_Fore	DOUBLE(20, 5), 
Draft_Recommended_Aft	DOUBLE(20, 5), 
Draft_Ballast_Actual	DOUBLE(20, 5), 
Draft_Ballast_Optimum	DOUBLE(20, 5), 
Longitude_Minutes	INT, 
ME_Fuel_BDN	VARCHAR(100), 
AE_Fuel_BDN	VARCHAR(100), 
Event	VARCHAR(4), 
ME_1_Load	DOUBLE(20, 5), 
ME_1_Running_Hours	DOUBLE(20, 5), 
Time_Elapsed_Maneuvering	DOUBLE(20, 5), 
Time_Elapsed_Waiting	DOUBLE(20, 5), 
ME_1_Scav_Air_Pressure	DOUBLE(20, 5), 
ME_1_Speed_RPM	DOUBLE(20, 5), 
ME_Consumption	DOUBLE(20, 5), 
Apparent_Slip	DOUBLE(20, 5), 
Nominal_Slip	DOUBLE(20, 5), 
Cargo_Total_TEU	DOUBLE(20, 5), 
Cargo_Total_Full_TEU	DOUBLE(20, 5), 
Cargo_Reefer_TEU	DOUBLE(20, 5), 
Cargo_CEU	DOUBLE(20, 5), 
Crew	DOUBLE(20, 5), 
Passengers	DOUBLE(20, 5), 
People	DOUBLE(20, 5), 
ME_Projected_Consumption	DOUBLE(20, 5), 
Speed_GPS	DOUBLE(20, 5), 
ME_Cylinder_Oil_Consumption	DOUBLE(20, 5), 
ME_System_Oil_Consumption	DOUBLE(20, 5), 
Speed_Through_Water	DOUBLE(20, 5), 
ME_1_Consumption	DOUBLE(20, 5), 
ME_1_Cylinder_Oil_Consumption	DOUBLE(20, 5), 
ME_1_System_Oil_Consumption	DOUBLE(20, 5), 
ME_1_Work	DOUBLE(20, 5), 
ME_1_Shaft_Power	DOUBLE(20, 5), 
ME_1_Shaft_Gen_Running_Hours	DOUBLE(20, 5), 
ME_2_Running_Hours	DOUBLE(20, 5), 
ME_2_Consumption	DOUBLE(20, 5), 
ME_2_Cylinder_Oil_Consumption	DOUBLE(20, 5), 
ME_2_System_Oil_Consumption	DOUBLE(20, 5), 
ME_2_Work	DOUBLE(20, 5), 
ME_2_Shaft_Power	DOUBLE(20, 5), 
ME_2_Shaft_Gen_Running_Hours	DOUBLE(20, 5), 
AE_Projected_Consumption	DOUBLE(20, 5), 
Swell_Dir	DOUBLE(20, 5), 
Swell_Force	DOUBLE(20, 5), 
AE_1_Consumption	DOUBLE(20, 5), 
AE_1_Work	DOUBLE(20, 5), 
Temperature_Water	DOUBLE(20, 5), 
AE_2_Consumption	DOUBLE(20, 5), 
AE_2_Work	DOUBLE(20, 5), 
Time_Elapsed_Loading_Unloading	DOUBLE(20, 5), 
AE_3_Consumption	DOUBLE(20, 5), 
AE_3_Work	DOUBLE(20, 5), 
AE_4_Running_Hours	DOUBLE(20, 5), 
AE_4_Consumption	DOUBLE(20, 5), 
AE_4_Work	DOUBLE(20, 5), 
AE_5_Running_Hours	DOUBLE(20, 5), 
AE_5_Consumption	DOUBLE(20, 5), 
AE_5_Work	DOUBLE(20, 5), 
AE_6_Running_Hours	DOUBLE(20, 5), 
AE_6_Consumption	DOUBLE(20, 5), 
AE_6_Work	DOUBLE(20, 5), 
Time_Elapsed_Sailing	DOUBLE(20, 5), 
Boiler_1_Running_Hours	DOUBLE(20, 5), 
Boiler_1_Consumption	DOUBLE(20, 5), 
Boiler_2_Running_Hours	DOUBLE(20, 5), 
Boiler_2_Consumption	DOUBLE(20, 5), 
Air_Compr_1_Running_Time	DOUBLE(20, 5), 
Air_Compr_2_Running_Time	DOUBLE(20, 5), 
Thruster_1_Running_Time	DOUBLE(20, 5), 
Thruster_2_Running_Time	DOUBLE(20, 5), 
Thruster_3_Running_Time	DOUBLE(20, 5), 
Lube_Oil_System_Type_Of_Pump_In_Service	DOUBLE(20, 5), 
Cleaning_Event	DOUBLE(20, 5), 
Mode	DOUBLE(20, 5), 
Time_Since_Previous_Report	DOUBLE(20, 5), 
Time_UTC	TIME, 
Speed_Projected_From_Charter_Party	DOUBLE(20, 5), 
Water_Depth	DOUBLE(20, 5), 
ME_Barometric_Pressure	DOUBLE(20, 5), 
ME_Charge_Air_Coolant_Inlet_Temp	DOUBLE(20, 5), 
ME_Air_Intake_Temp	DOUBLE(20, 5), 
Wind_Dir	INT, 
Wind_Force_Bft	INT, 
Prop_1_Pitch	DOUBLE(20, 5), 
ME_1_Aux_Blower	DOUBLE(20, 5), 
ME_1_Shaft_Gen_Power	DOUBLE(20, 5), 
ME_1_Charge_Air_Inlet_Temp	DOUBLE(20, 5), 
Wind_Force_Kn	DOUBLE(20, 5), 
ME_1_Pressure_Drop_Over_Scav_Air_Cooler	DOUBLE(20, 5), 
ME_1_TC_Speed	DOUBLE(20, 5), 
ME_1_Exh_Temp_Before_TC	DOUBLE(20, 5), 
ME_1_Exh_Temp_After_TC	DOUBLE(20, 5), 
ME_1_Current_Consumption	DOUBLE(20, 5), 
ME_1_SFOC_ISO_Corrected	DOUBLE(20, 5), 
ME_1_SFOC	DOUBLE(20, 5), 
ME_1_Pmax	DOUBLE(20, 5), 
ME_1_Pcomp	DOUBLE(20, 5), 
ME_2_Load	DOUBLE(20, 5), 
ME_2_Speed_RPM	DOUBLE(20, 5), 
Prop_2_Pitch	DOUBLE(20, 5), 
ME_2_Aux_Blower	DOUBLE(20, 5), 
ME_2_Shaft_Gen_Power	DOUBLE(20, 5), 
ME_2_Charge_Air_Inlet_Temp	DOUBLE(20, 5), 
ME_2_Scav_Air_Pressure	DOUBLE(20, 5), 
ME_2_Pressure_Drop_Over_Scav_Air_Cooler	DOUBLE(20, 5), 
ME_2_TC_Speed	DOUBLE(20, 5), 
ME_2_Exh_Temp_Before_TC	DOUBLE(20, 5), 
ME_2_Exh_Temp_After_TC	DOUBLE(20, 5), 
ME_2_Current_Consumption	DOUBLE(20, 5), 
ME_2_SFOC_ISO_Corrected	DOUBLE(20, 5), 
ME_2_SFOC	DOUBLE(20, 5), 
ME_2_Pmax	DOUBLE(20, 5), 
ME_2_Pcomp	DOUBLE(20, 5), 
AE_Barometric_Pressure	DOUBLE(20, 5), 
AE_Charge_Air_Coolant_Inlet_Temp	DOUBLE(20, 5), 
AE_Air_Intake_Temp	DOUBLE(20, 5), 
AE_1_Load	DOUBLE(20, 5), 
AE_1_Charge_Air_Inlet_Temp	DOUBLE(20, 5), 
AE_1_Charge_Air_Pressure	DOUBLE(20, 5), 
AE_1_TC_Speed	DOUBLE(20, 5), 
AE_1_Exh_Gas_Temperature	DOUBLE(20, 5), 
AE_1_Current_Consumption	DOUBLE(20, 5), 
AE_1_SFOC_ISO_Corrected	DOUBLE(20, 5), 
AE_1_SFOC	DOUBLE(20, 5), 
AE_1_Pmax	DOUBLE(20, 5), 
AE_1_Pcomp	DOUBLE(20, 5), 
AE_2_Load	DOUBLE(20, 5), 
AE_2_Charge_Air_Inlet_Temp	DOUBLE(20, 5), 
AE_2_Charge_Air_Pressure	DOUBLE(20, 5), 
AE_2_TC_Speed	DOUBLE(20, 5), 
AE_2_Exh_Gas_Temperature	DOUBLE(20, 5), 
AE_2_Current_Consumption	DOUBLE(20, 5), 
AE_2_SFOC_ISO_Corrected	DOUBLE(20, 5), 
AE_2_SFOC	DOUBLE(20, 5), 
AE_2_Pmax	DOUBLE(20, 5), 
AE_2_Pcomp	DOUBLE(20, 5), 
AE_3_Load	DOUBLE(20, 5), 
AE_3_Charge_Air_Inlet_Temp	DOUBLE(20, 5), 
AE_3_Charge_Air_Pressure	DOUBLE(20, 5), 
AE_3_TC_Speed	DOUBLE(20, 5), 
AE_3_Exh_Gas_Temperature	DOUBLE(20, 5), 
AE_3_Current_Consumption	DOUBLE(20, 5), 
AE_3_SFOC_ISO_Corrected	DOUBLE(20, 5), 
AE_3_SFOC	DOUBLE(20, 5), 
AE_3_Pmax	DOUBLE(20, 5), 
AE_3_Pcomp	DOUBLE(20, 5), 
AE_4_Load	DOUBLE(20, 5), 
AE_4_Charge_Air_Inlet_Temp	DOUBLE(20, 5), 
AE_4_Charge_Air_Pressure	DOUBLE(20, 5), 
AE_4_TC_Speed	DOUBLE(20, 5), 
AE_4_Exh_Gas_Temperature	DOUBLE(20, 5), 
AE_4_Current_Consumption	DOUBLE(20, 5), 
AE_4_SFOC_ISO_Corrected	DOUBLE(20, 5), 
AE_4_SFOC	DOUBLE(20, 5), 
AE_4_Pmax	DOUBLE(20, 5), 
AE_4_Pcomp	DOUBLE(20, 5), 
AE_5_Load	DOUBLE(20, 5), 
AE_5_Charge_Air_Inlet_Temp	DOUBLE(20, 5), 
AE_5_Charge_Air_Pressure	DOUBLE(20, 5), 
AE_5_TC_Speed	DOUBLE(20, 5), 
AE_5_Exh_Gas_Temperature	DOUBLE(20, 5), 
AE_5_Current_Consumption	DOUBLE(20, 5), 
AE_5_SFOC_ISO_Corrected	DOUBLE(20, 5), 
AE_5_SFOC	DOUBLE(20, 5), 
AE_5_Pmax	DOUBLE(20, 5), 
AE_5_Pcomp	DOUBLE(20, 5), 
AE_6_Load	DOUBLE(20, 5), 
AE_6_Charge_Air_Inlet_Temp	DOUBLE(20, 5), 
AE_6_Charge_Air_Pressure	DOUBLE(20, 5), 
AE_6_TC_Speed	DOUBLE(20, 5), 
AE_6_Exh_Gas_Temperature	DOUBLE(20, 5), 
AE_6_Current_Consumption	DOUBLE(20, 5), 
AE_6_SFOC_ISO_Corrected	DOUBLE(20, 5), 
AE_6_SFOC	DOUBLE(20, 5), 
AE_6_Pmax	DOUBLE(20, 5), 
AE_6_Pcomp	DOUBLE(20, 5), 
Boiler_1_Operation_Mode	DOUBLE(20, 5), 
Boiler_1_Feed_Water_Flow	DOUBLE(20, 5), 
Boiler_1_Steam_Pressure	DOUBLE(20, 5), 
Boiler_2_Operation_Mode	DOUBLE(20, 5), 
Boiler_2_Feed_Water_Flow	DOUBLE(20, 5), 
Boiler_2_Steam_Pressure	DOUBLE(20, 5), 
Cooling_Water_System_SW_Pumps_In_Service	DOUBLE(20, 5), 
Cooling_Water_System_SW_Inlet_Temp	DOUBLE(20, 5), 
Cooling_Water_System_SW_Outlet_Temp	DOUBLE(20, 5), 
Cooling_Water_System_Pressure_Drop_Over_Heat_Exchanger	DOUBLE(20, 5), 
Cooling_Water_System_Pump_Pressure	DOUBLE(20, 5), 
ER_Ventilation_Fans_In_Service	DOUBLE(20, 5), 
ER_Ventilation_Waste_Air_Temp	DOUBLE(20, 5), 
Remarks	DOUBLE(20, 5), 
Entry_Made_By_1	DOUBLE(20, 5), 
Entry_Made_By_2	DOUBLE(20, 5),
Relative_Wind_Speed DOUBLE (10, 5),
Relative_Wind_Direction DOUBLE (10, 5),
Speed_Over_Ground DOUBLE (10, 5),
Shaft_Revolutions DOUBLE (10, 5),
Static_Draught_Fore DOUBLE(10, 5),
Static_Draught_Aft DOUBLE(10, 5),
Seawater_Temperature DOUBLE (10, 5),
Air_Temperature DOUBLE(10, 8),
Air_Pressure DOUBLE(10, 6),
Mass_Consumed_Fuel_Oil DOUBLE(10, 3),
Lower_Caloirifc_Value_Fuel_Oil DOUBLE(10, 5),
Density_Fuel_Oil_15C DOUBLE(10, 5)
);

INSERT INTO tempRaw (IMO_Vessel_Number, DateTime_UTC, AE_1_Running_Hours, AE_2_Running_Hours, Date_Local, AE_3_Running_Hours, Time_Local, Voyage_From, Voyage_To, Voyage_Number, AE_Consumption, Boiler_Consumption, Latitude_North_South, Cargo_Mt, Current_Dir, Longitude_East_West, Current_Speed, Date_UTC, Distance, Sea_state_Dir, Sea_state_Force_Douglas, Draft_Actual_Aft, Draft_Actual_Fore, Draft_Displacement_Actual, Temperature_Ambient, Latitude_Degree, Latitude_Minutes, Longitude_Degree, Draft_Recommended_Fore, Draft_Recommended_Aft, Draft_Ballast_Actual, Draft_Ballast_Optimum, Longitude_Minutes, ME_Fuel_BDN, AE_Fuel_BDN, Event, ME_1_Load, ME_1_Running_Hours, Time_Elapsed_Maneuvering, Time_Elapsed_Waiting, ME_1_Scav_Air_Pressure, ME_1_Speed_RPM, ME_Consumption, Apparent_Slip, Nominal_Slip, Cargo_Total_TEU, Cargo_Total_Full_TEU, Cargo_Reefer_TEU, Cargo_CEU, Crew, Passengers, People, ME_Projected_Consumption, Speed_GPS, ME_Cylinder_Oil_Consumption, ME_System_Oil_Consumption, Speed_Through_Water, ME_1_Consumption, ME_1_Cylinder_Oil_Consumption, ME_1_System_Oil_Consumption, ME_1_Work, ME_1_Shaft_Power, ME_1_Shaft_Gen_Running_Hours, ME_2_Running_Hours, ME_2_Consumption, ME_2_Cylinder_Oil_Consumption, ME_2_System_Oil_Consumption, ME_2_Work, ME_2_Shaft_Power, ME_2_Shaft_Gen_Running_Hours, AE_Projected_Consumption, Swell_Dir, Swell_Force, AE_1_Consumption, AE_1_Work, Temperature_Water, AE_2_Consumption, AE_2_Work, Time_Elapsed_Loading_Unloading, AE_3_Consumption, AE_3_Work, AE_4_Running_Hours, AE_4_Consumption, AE_4_Work, AE_5_Running_Hours, AE_5_Consumption, AE_5_Work, AE_6_Running_Hours, AE_6_Consumption, AE_6_Work, Time_Elapsed_Sailing, Boiler_1_Running_Hours, Boiler_1_Consumption, Boiler_2_Running_Hours, Boiler_2_Consumption, Air_Compr_1_Running_Time, Air_Compr_2_Running_Time, Thruster_1_Running_Time, Thruster_2_Running_Time, Thruster_3_Running_Time, Lube_Oil_System_Type_Of_Pump_In_Service, Cleaning_Event, Mode, Time_Since_Previous_Report, Time_UTC, Speed_Projected_From_Charter_Party, Water_Depth, ME_Barometric_Pressure, ME_Charge_Air_Coolant_Inlet_Temp, ME_Air_Intake_Temp, Wind_Dir, Wind_Force_Bft, Prop_1_Pitch, ME_1_Aux_Blower, ME_1_Shaft_Gen_Power, ME_1_Charge_Air_Inlet_Temp, Wind_Force_Kn, ME_1_Pressure_Drop_Over_Scav_Air_Cooler, ME_1_TC_Speed, ME_1_Exh_Temp_Before_TC, ME_1_Exh_Temp_After_TC, ME_1_Current_Consumption, ME_1_SFOC_ISO_Corrected, ME_1_SFOC, ME_1_Pmax, ME_1_Pcomp, ME_2_Load, ME_2_Speed_RPM, Prop_2_Pitch, ME_2_Aux_Blower, ME_2_Shaft_Gen_Power, ME_2_Charge_Air_Inlet_Temp, ME_2_Scav_Air_Pressure, ME_2_Pressure_Drop_Over_Scav_Air_Cooler, ME_2_TC_Speed, ME_2_Exh_Temp_Before_TC, ME_2_Exh_Temp_After_TC, ME_2_Current_Consumption, ME_2_SFOC_ISO_Corrected, ME_2_SFOC, ME_2_Pmax, ME_2_Pcomp, AE_Barometric_Pressure, AE_Charge_Air_Coolant_Inlet_Temp, AE_Air_Intake_Temp, AE_1_Load, AE_1_Charge_Air_Inlet_Temp, AE_1_Charge_Air_Pressure, AE_1_TC_Speed, AE_1_Exh_Gas_Temperature, AE_1_Current_Consumption, AE_1_SFOC_ISO_Corrected, AE_1_SFOC, AE_1_Pmax, AE_1_Pcomp, AE_2_Load, AE_2_Charge_Air_Inlet_Temp, AE_2_Charge_Air_Pressure, AE_2_TC_Speed, AE_2_Exh_Gas_Temperature, AE_2_Current_Consumption, AE_2_SFOC_ISO_Corrected, AE_2_SFOC, AE_2_Pmax, AE_2_Pcomp, AE_3_Load, AE_3_Charge_Air_Inlet_Temp, AE_3_Charge_Air_Pressure, AE_3_TC_Speed, AE_3_Exh_Gas_Temperature, AE_3_Current_Consumption, AE_3_SFOC_ISO_Corrected, AE_3_SFOC, AE_3_Pmax, AE_3_Pcomp, AE_4_Load, AE_4_Charge_Air_Inlet_Temp, AE_4_Charge_Air_Pressure, AE_4_TC_Speed, AE_4_Exh_Gas_Temperature, AE_4_Current_Consumption, AE_4_SFOC_ISO_Corrected, AE_4_SFOC, AE_4_Pmax, AE_4_Pcomp, AE_5_Load, AE_5_Charge_Air_Inlet_Temp, AE_5_Charge_Air_Pressure, AE_5_TC_Speed, AE_5_Exh_Gas_Temperature, AE_5_Current_Consumption, AE_5_SFOC_ISO_Corrected, AE_5_SFOC, AE_5_Pmax, AE_5_Pcomp, AE_6_Load, AE_6_Charge_Air_Inlet_Temp, AE_6_Charge_Air_Pressure, AE_6_TC_Speed, AE_6_Exh_Gas_Temperature, AE_6_Current_Consumption, AE_6_SFOC_ISO_Corrected, AE_6_SFOC, AE_6_Pmax, AE_6_Pcomp, Boiler_1_Operation_Mode, Boiler_1_Feed_Water_Flow, Boiler_1_Steam_Pressure, Boiler_2_Operation_Mode, Boiler_2_Feed_Water_Flow, Boiler_2_Steam_Pressure, Cooling_Water_System_SW_Pumps_In_Service, Cooling_Water_System_SW_Inlet_Temp, Cooling_Water_System_SW_Outlet_Temp, Cooling_Water_System_Pressure_Drop_Over_Heat_Exchanger, Cooling_Water_System_Pump_Pressure, ER_Ventilation_Fans_In_Service, ER_Ventilation_Waste_Air_Temp, Remarks, Entry_Made_By_1, Entry_Made_By_2)
	(SELECT IMO_Vessel_Number, DateTime_UTC, AE_1_Running_Hours, AE_2_Running_Hours, Date_Local, AE_3_Running_Hours, Time_Local, Voyage_From, Voyage_To, Voyage_Number, AE_Consumption, Boiler_Consumption, Latitude_North_South, Cargo_Mt, Current_Dir, Longitude_East_West, Current_Speed, Date_UTC, Distance, Sea_state_Dir, Sea_state_Force_Douglas, Draft_Actual_Aft, Draft_Actual_Fore, Draft_Displacement_Actual, Temperature_Ambient, Latitude_Degree, Latitude_Minutes, Longitude_Degree, Draft_Recommended_Fore, Draft_Recommended_Aft, Draft_Ballast_Actual, Draft_Ballast_Optimum, Longitude_Minutes, ME_Fuel_BDN, AE_Fuel_BDN, Event, ME_1_Load, ME_1_Running_Hours, Time_Elapsed_Maneuvering, Time_Elapsed_Waiting, ME_1_Scav_Air_Pressure, ME_1_Speed_RPM, ME_Consumption, Apparent_Slip, Nominal_Slip, Cargo_Total_TEU, Cargo_Total_Full_TEU, Cargo_Reefer_TEU, Cargo_CEU, Crew, Passengers, People, ME_Projected_Consumption, Speed_GPS, ME_Cylinder_Oil_Consumption, ME_System_Oil_Consumption, Speed_Through_Water, ME_1_Consumption, ME_1_Cylinder_Oil_Consumption, ME_1_System_Oil_Consumption, ME_1_Work, ME_1_Shaft_Power, ME_1_Shaft_Gen_Running_Hours, ME_2_Running_Hours, ME_2_Consumption, ME_2_Cylinder_Oil_Consumption, ME_2_System_Oil_Consumption, ME_2_Work, ME_2_Shaft_Power, ME_2_Shaft_Gen_Running_Hours, AE_Projected_Consumption, Swell_Dir, Swell_Force, AE_1_Consumption, AE_1_Work, Temperature_Water, AE_2_Consumption, AE_2_Work, Time_Elapsed_Loading_Unloading, AE_3_Consumption, AE_3_Work, AE_4_Running_Hours, AE_4_Consumption, AE_4_Work, AE_5_Running_Hours, AE_5_Consumption, AE_5_Work, AE_6_Running_Hours, AE_6_Consumption, AE_6_Work, Time_Elapsed_Sailing, Boiler_1_Running_Hours, Boiler_1_Consumption, Boiler_2_Running_Hours, Boiler_2_Consumption, Air_Compr_1_Running_Time, Air_Compr_2_Running_Time, Thruster_1_Running_Time, Thruster_2_Running_Time, Thruster_3_Running_Time, Lube_Oil_System_Type_Of_Pump_In_Service, Cleaning_Event, Mode, Time_Since_Previous_Report, Time_UTC, Speed_Projected_From_Charter_Party, Water_Depth, ME_Barometric_Pressure, ME_Charge_Air_Coolant_Inlet_Temp, ME_Air_Intake_Temp, Wind_Dir, Wind_Force_Bft, Prop_1_Pitch, ME_1_Aux_Blower, ME_1_Shaft_Gen_Power, ME_1_Charge_Air_Inlet_Temp, Wind_Force_Kn, ME_1_Pressure_Drop_Over_Scav_Air_Cooler, ME_1_TC_Speed, ME_1_Exh_Temp_Before_TC, ME_1_Exh_Temp_After_TC, ME_1_Current_Consumption, ME_1_SFOC_ISO_Corrected, ME_1_SFOC, ME_1_Pmax, ME_1_Pcomp, ME_2_Load, ME_2_Speed_RPM, Prop_2_Pitch, ME_2_Aux_Blower, ME_2_Shaft_Gen_Power, ME_2_Charge_Air_Inlet_Temp, ME_2_Scav_Air_Pressure, ME_2_Pressure_Drop_Over_Scav_Air_Cooler, ME_2_TC_Speed, ME_2_Exh_Temp_Before_TC, ME_2_Exh_Temp_After_TC, ME_2_Current_Consumption, ME_2_SFOC_ISO_Corrected, ME_2_SFOC, ME_2_Pmax, ME_2_Pcomp, AE_Barometric_Pressure, AE_Charge_Air_Coolant_Inlet_Temp, AE_Air_Intake_Temp, AE_1_Load, AE_1_Charge_Air_Inlet_Temp, AE_1_Charge_Air_Pressure, AE_1_TC_Speed, AE_1_Exh_Gas_Temperature, AE_1_Current_Consumption, AE_1_SFOC_ISO_Corrected, AE_1_SFOC, AE_1_Pmax, AE_1_Pcomp, AE_2_Load, AE_2_Charge_Air_Inlet_Temp, AE_2_Charge_Air_Pressure, AE_2_TC_Speed, AE_2_Exh_Gas_Temperature, AE_2_Current_Consumption, AE_2_SFOC_ISO_Corrected, AE_2_SFOC, AE_2_Pmax, AE_2_Pcomp, AE_3_Load, AE_3_Charge_Air_Inlet_Temp, AE_3_Charge_Air_Pressure, AE_3_TC_Speed, AE_3_Exh_Gas_Temperature, AE_3_Current_Consumption, AE_3_SFOC_ISO_Corrected, AE_3_SFOC, AE_3_Pmax, AE_3_Pcomp, AE_4_Load, AE_4_Charge_Air_Inlet_Temp, AE_4_Charge_Air_Pressure, AE_4_TC_Speed, AE_4_Exh_Gas_Temperature, AE_4_Current_Consumption, AE_4_SFOC_ISO_Corrected, AE_4_SFOC, AE_4_Pmax, AE_4_Pcomp, AE_5_Load, AE_5_Charge_Air_Inlet_Temp, AE_5_Charge_Air_Pressure, AE_5_TC_Speed, AE_5_Exh_Gas_Temperature, AE_5_Current_Consumption, AE_5_SFOC_ISO_Corrected, AE_5_SFOC, AE_5_Pmax, AE_5_Pcomp, AE_6_Load, AE_6_Charge_Air_Inlet_Temp, AE_6_Charge_Air_Pressure, AE_6_TC_Speed, AE_6_Exh_Gas_Temperature, AE_6_Current_Consumption, AE_6_SFOC_ISO_Corrected, AE_6_SFOC, AE_6_Pmax, AE_6_Pcomp, Boiler_1_Operation_Mode, Boiler_1_Feed_Water_Flow, Boiler_1_Steam_Pressure, Boiler_2_Operation_Mode, Boiler_2_Feed_Water_Flow, Boiler_2_Steam_Pressure, Cooling_Water_System_SW_Pumps_In_Service, Cooling_Water_System_SW_Inlet_Temp, Cooling_Water_System_SW_Outlet_Temp, Cooling_Water_System_Pressure_Drop_Over_Heat_Exchanger, Cooling_Water_System_Pump_Pressure, ER_Ventilation_Fans_In_Service, ER_Ventilation_Waste_Air_Temp, Remarks, Entry_Made_By_1, Entry_Made_By_2
		FROM dnvglraw WHERE IMO_Vessel_Number = imo);
        
CALL convertDNVGLRawToRawData;

END;