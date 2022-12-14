
begin
INSERT INTO EmployeeTerritories(EmployeeID, TerritoryID) VALUES (1, '06897');
INSERT INTO EmployeeTerritories(EmployeeID, TerritoryID) VALUES (1, '19713');
INSERT INTO EmployeeTerritories(EmployeeID, TerritoryID) VALUES (2, '01581');
INSERT INTO EmployeeTerritories(EmployeeID, TerritoryID) VALUES (2, '01730');
INSERT INTO EmployeeTerritories(EmployeeID, TerritoryID) VALUES (2, '01833');
INSERT INTO EmployeeTerritories(EmployeeID, TerritoryID) VALUES (2, '02116');
INSERT INTO EmployeeTerritories(EmployeeID, TerritoryID) VALUES (2, '02139');
INSERT INTO EmployeeTerritories(EmployeeID, TerritoryID) VALUES (2, '02184');
INSERT INTO EmployeeTerritories(EmployeeID, TerritoryID) VALUES (2, '40222');
INSERT INTO EmployeeTerritories(EmployeeID, TerritoryID) VALUES (3, '30346');
INSERT INTO EmployeeTerritories(EmployeeID, TerritoryID) VALUES (3, '31406');
INSERT INTO EmployeeTerritories(EmployeeID, TerritoryID) VALUES (3, '32859');
INSERT INTO EmployeeTerritories(EmployeeID, TerritoryID) VALUES (3, '33607');
INSERT INTO EmployeeTerritories(EmployeeID, TerritoryID) VALUES (4, '20852');
INSERT INTO EmployeeTerritories(EmployeeID, TerritoryID) VALUES (4, '27403');
INSERT INTO EmployeeTerritories(EmployeeID, TerritoryID) VALUES (4, '27511');
INSERT INTO EmployeeTerritories(EmployeeID, TerritoryID) VALUES (5, '02903');
INSERT INTO EmployeeTerritories(EmployeeID, TerritoryID) VALUES (5, '07960');
INSERT INTO EmployeeTerritories(EmployeeID, TerritoryID) VALUES (5, '08837');
INSERT INTO EmployeeTerritories(EmployeeID, TerritoryID) VALUES (5, '10019');
INSERT INTO EmployeeTerritories(EmployeeID, TerritoryID) VALUES (5, '10038');
INSERT INTO EmployeeTerritories(EmployeeID, TerritoryID) VALUES (5, '11747');
INSERT INTO EmployeeTerritories(EmployeeID, TerritoryID) VALUES (5, '14450');
INSERT INTO EmployeeTerritories(EmployeeID, TerritoryID) VALUES (6, '85014');
INSERT INTO EmployeeTerritories(EmployeeID, TerritoryID) VALUES (6, '85251');
INSERT INTO EmployeeTerritories(EmployeeID, TerritoryID) VALUES (6, '98004');
INSERT INTO EmployeeTerritories(EmployeeID, TerritoryID) VALUES (6, '98052');
INSERT INTO EmployeeTerritories(EmployeeID, TerritoryID) VALUES (6, '98104');
INSERT INTO EmployeeTerritories(EmployeeID, TerritoryID) VALUES (7, '60179');
INSERT INTO EmployeeTerritories(EmployeeID, TerritoryID) VALUES (7, '60601');
INSERT INTO EmployeeTerritories(EmployeeID, TerritoryID) VALUES (7, '80202');
INSERT INTO EmployeeTerritories(EmployeeID, TerritoryID) VALUES (7, '80909');
INSERT INTO EmployeeTerritories(EmployeeID, TerritoryID) VALUES (7, '90405');
INSERT INTO EmployeeTerritories(EmployeeID, TerritoryID) VALUES (7, '94025');
INSERT INTO EmployeeTerritories(EmployeeID, TerritoryID) VALUES (7, '94105');
INSERT INTO EmployeeTerritories(EmployeeID, TerritoryID) VALUES (7, '95008');
INSERT INTO EmployeeTerritories(EmployeeID, TerritoryID) VALUES (7, '95054');
INSERT INTO EmployeeTerritories(EmployeeID, TerritoryID) VALUES (7, '95060');
INSERT INTO EmployeeTerritories(EmployeeID, TerritoryID) VALUES (8, '19428');
INSERT INTO EmployeeTerritories(EmployeeID, TerritoryID) VALUES (8, '44122');
INSERT INTO EmployeeTerritories(EmployeeID, TerritoryID) VALUES (8, '45839');
INSERT INTO EmployeeTerritories(EmployeeID, TerritoryID) VALUES (8, '53404');
INSERT INTO EmployeeTerritories(EmployeeID, TerritoryID) VALUES (9, '03049');
INSERT INTO EmployeeTerritories(EmployeeID, TerritoryID) VALUES (9, '03801');
INSERT INTO EmployeeTerritories(EmployeeID, TerritoryID) VALUES (9, '48075');
INSERT INTO EmployeeTerritories(EmployeeID, TerritoryID) VALUES (9, '48084');
INSERT INTO EmployeeTerritories(EmployeeID, TerritoryID) VALUES (9, '48304');
INSERT INTO EmployeeTerritories(EmployeeID, TerritoryID) VALUES (9, '55113');
INSERT INTO EmployeeTerritories(EmployeeID, TerritoryID) VALUES (9, '55439');
commit;
end;
/

create or replace function get_territoryID_for_orders(EmpID number) return Territories.TerritoryID%TYPE
as
	T_ID Territories.TerritoryID%TYPE;
begin
	 SELECT a.TerritoryID into T_ID
		FROM (SELECT ROWNUM as row_num, TerritoryID
			FROM EmployeeTerritories
			WHERE EmployeeID = EmpID) a
		WHERE a.row_num = (
					SELECT 	dbms_utility.get_hash_value
						(
							to_char(dbms_utility.get_time)||empid,
							1,
							(
							SELECT count(*) 
							FROM EmployeeTerritories
							WHERE EmployeeID = EmpID
							)
						) 
					FROM dual
				  );
	return t_id;
end;
/


BEGIN
 update orders set
 territoryid=get_territoryid_for_orders(employeeid);
 commit;
END;
/

DROP FUNCTION get_territoryid_for_orders;
