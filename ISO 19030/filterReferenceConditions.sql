/* Update filter columns for rows which do not meet the reference 
conditions given in standard ISO 19030-2. */

DROP PROCEDURE IF EXISTS filterReferenceConditions;

delimiter //

CREATE PROCEDURE filterReferenceConditions(vcid INT)

BEGIN
	
    DECLARE DepthFormula5 DOUBLE(10, 5);
    DECLARE DepthFormula6 DOUBLE(10, 5);
    DECLARE ShipBreadth DOUBLE(10, 5);
    DECLARE g1 DOUBLE(10, 5);
    
    /*
    DROP TABLE IF EXISTS `inservice`.DepthFormula;
    CREATE TABLE `inservice`.DepthFormula (id INT PRIMARY KEY AUTO_INCREMENT, 
								Timestamp DATETIME, 
								Water_Depth DOUBLE(10, 5), 
								DepthFormula5 DOUBLE(10, 5), 
								DepthFormula6 DOUBLE(10, 5));
    
    INSERT INTO `inservice`.DepthFormula (Timestamp) SELECT Timestamp FROM temprawiso;
    UPDATE `inservice`.DepthFormula, temprawiso SET `inservice`.DepthFormula.Water_Depth = `inservice`.temprawiso.Water_Depth;
    */
    SET ShipBreadth := (SELECT Breadth_Moulded FROM `static`.vesselconfiguration WHERE vessel_configuration_id = vcid);
    SET g1 := (SELECT g FROM `static`.globalConstants);
    /*
	UPDATE `inservice`.DepthFormula d 
		INNER JOIN temprawiso t
			ON d.Timestamp = t.Timestamp
				SET 
                d.DepthFormula5 = 3 * SQRT( ShipBreadth * (t.Static_Draught_Aft + t.Static_Draught_Fore) / 2 ),
                d.DepthFormula6 = 2.75 * POWER(t.Speed_Through_Water, 2) / g1, 
                d.Water_Depth = t.Water_Depth;
    */
    UPDATE temprawiso SET Filter_Reference_Seawater_Temp = TRUE WHERE Seawater_Temperature <= 2;
    UPDATE temprawiso SET Filter_Reference_Seawater_Temp = FALSE WHERE NOT Seawater_Temperature <= 2;
    UPDATE temprawiso SET Filter_Reference_Wind_Speed = TRUE WHERE Relative_Wind_Speed > 7.9;
    UPDATE temprawiso SET Filter_Reference_Wind_Speed = FALSE WHERE NOT Relative_Wind_Speed > 7.9;
    UPDATE temprawiso SET Filter_Reference_Water_Depth = TRUE WHERE Water_Depth < 3 * SQRT( ShipBreadth * (Static_Draught_Aft + Static_Draught_Fore) / 2 ) 
		OR Water_Depth < 2.75 * POWER(Speed_Through_Water, 2) / g1 OR Water_Depth < 2.75 * POWER(Speed_Through_Water, 2) / g1;
    UPDATE temprawiso SET Filter_Reference_Water_Depth = FALSE WHERE NOT (Water_Depth < 3 * SQRT( ShipBreadth * (Static_Draught_Aft + Static_Draught_Fore) / 2 ) 
		OR Water_Depth < 2.75 * POWER(Speed_Through_Water, 2) / g1 OR Water_Depth < 2.75 * POWER(Speed_Through_Water, 2) / g1);
    UPDATE temprawiso SET Filter_Reference_Rudder_Angle = TRUE WHERE Rudder_Angle > 5;
    UPDATE temprawiso SET Filter_Reference_Rudder_Angle = FALSE WHERE NOT Rudder_Angle > 5;
    
	/* DELETE FROM temprawiso WHERE Seawater_Temperature <= 2; */
    /* 
	DELETE FROM temprawiso WHERE Relative_Wind_Speed < 0 OR Relative_Wind_Speed > 7.9;
	DELETE FROM temprawiso WHERE Rudder_Angle > 5;
    DELETE d
		FROM temprawiso d
        JOIN DepthFormula dd ON d.Timestamp = dd.Timestamp
        WHERE d.Water_Depth < dd.DepthFormula5 OR
			  d.Water_Depth < dd.DepthFormula6;
    /* DROP TABLE DepthFormula; */
END;