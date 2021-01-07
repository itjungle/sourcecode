CREATE TABLE CUSTMAST (
	"CUST#" DECIMAL(5,0) DEFAULT 0 NOT NULL,
	NAME CHAR(30) DEFAULT '' NOT NULL,
	ADDR CHAR(30) DEFAULT '' NOT NULL,
	CITY CHAR(25) DEFAULT '' NOT NULL,
	STATE CHAR(10) DEFAULT '' NOT NULL,
	ZIP CHAR(10) DEFAULT '' NOT NULL,
	CREDIT DECIMAL(7,2) DEFAULT 0 NOT NULL,
	"ONORD$" DECIMAL(7,2) DEFAULT 0 NOT NULL,
	"CURYR$" DECIMAL(7,2) DEFAULT 0 NOT NULL,
	"YR1$" DECIMAL(7,2) DEFAULT 0 NOT NULL,
	"YR2$" DECIMAL(7,2) DEFAULT 0 NOT NULL,
	CONSTRAINT "Q_SQLBASE_CUSTMAST_CUST#_00001" PRIMARY KEY ("CUST#")
);

INSERT INTO CUSTMAST
("CUST#", NAME, ADDR, CITY, STATE, ZIP, CREDIT, "ONORD$", "CURYR$", "YR1$", "YR2$")
VALUES(15392, 'Jane Smith                    ', '123 Market St.                ',
 'New York                 ', 'NY        ', '11205     ', 2000.00, 29.99, 3266.93,
 21269.41, 2253.82);

INSERT INTO CUSTMAST
("CUST#", NAME, ADDR, CITY, STATE, ZIP, CREDIT, "ONORD$", "CURYR$", "YR1$", "YR2$")
VALUES(92411, 'Bob Hall                      ', '4551 1st Ave.                 ',
 'Cleveland                ', 'OH        ', '44121-1106', 500.00, 220.00, 4365.44,
 14377.93, 11907.00);
INSERT INTO CUSTMAST
("CUST#", NAME, ADDR, CITY, STATE, ZIP, CREDIT, "ONORD$", "CURYR$", "YR1$", "YR2$")
VALUES(93583, 'Paul Stone                    ', '14785 Detroit Ave.            ',
 'Toronto                  ', 'ONTARIO   ', 'L8N 3K1   ', 3600.00, 1039.35, 2318.55,
 5827.50, 0.00);
INSERT INTO CUSTMAST
("CUST#", NAME, ADDR, CITY, STATE, ZIP, CREDIT, "ONORD$", "CURYR$", "YR1$", "YR2$")
VALUES(28395, 'Alice Sundry                  ', '32 East Lane                  ',
 'Milwaukee                ', 'WI        ', '60158     ', 1500.00, 1319.60, 929.80,
 1869.00, 1300.00);
INSERT INTO CUSTMAST
("CUST#", NAME, ADDR, CITY, STATE, ZIP, CREDIT, "ONORD$", "CURYR$", "YR1$", "YR2$")
VALUES(32418, 'Jon Paris                     ', '874 West Circle               ',
 'Mansfield                ', 'OH        ', '44687     ', 15000.00, 2999.70, 4963.95,
 11639.58, 3429.25);
INSERT INTO CUSTMAST
("CUST#", NAME, ADDR, CITY, STATE, ZIP, CREDIT, "ONORD$", "CURYR$", "YR1$", "YR2$")
VALUES(92990, 'Susan Gantner                 ', '129 Ridge Road                ',
 'Birmingham               ', 'AL        ', '53186     ', 5000.00, 750.00, 6150.00,
 13778.00, 6305.00);
INSERT INTO CUSTMAST
("CUST#", NAME, ADDR, CITY, STATE, ZIP, CREDIT, "ONORD$", "CURYR$", "YR1$", "YR2$")
VALUES(84345, 'Joe Brown                     ', '123 Main St.                  ',
 'Buffalo                  ', 'NY        ', '11224     ', 200.00, 0.00, 0.00,
 0.00, 0.00);
INSERT INTO CUSTMAST
("CUST#", NAME, ADDR, CITY, STATE, ZIP, CREDIT, "ONORD$", "CURYR$", "YR1$", "YR2$")
VALUES(38410, 'Tom Terrific                  ', '444 W Creditview Rd           ',
 'Syracuse                 ', 'NY        ', '11253     ', 30.00, 0.00, 0.00, 0.00,
 0.00);
INSERT INTO CUSTMAST
("CUST#", NAME, ADDR, CITY, STATE, ZIP, CREDIT, "ONORD$", "CURYR$", "YR1$", "YR2$")
VALUES(49345, 'Joe''s Skateboards             ', '123 Main St.                  ',
 'Buffalo                  ', 'NY        ', '11224     ', 200.00, 0.00, 0.00, 0.00,
 0.00);
INSERT INTO CUSTMAST
("CUST#", NAME, ADDR, CITY, STATE, ZIP, CREDIT, "ONORD$", "CURYR$", "YR1$", "YR2$")
VALUES(59495, 'Best Stuff You Can Buy        ', '25 2nd St.                    ',
 'Cincinnati               ', 'OH        ', '44121-1106', 20.00, 0.00, 0.00, 0.00,
 0.00);
INSERT INTO CUSTMAST
("CUST#", NAME, ADDR, CITY, STATE, ZIP, CREDIT, "ONORD$", "CURYR$", "YR1$", "YR2$")
VALUES(69518, 'Nancy''s Nails                 ', '874 S Somewhere Ave.          ',
 'Portland                 ', 'OR        ', '33687     ', 30.00, 0.00, 0.00, 0.00,
 0.00);
INSERT INTO CUSTMAST
("CUST#", NAME, ADDR, CITY, STATE, ZIP, CREDIT, "ONORD$", "CURYR$", "YR1$", "YR2$")
VALUES(91538, 'Everyone''s Favorite Candy     ', '1233 Ambling Boulevard        ',
 'Sidney                   ', 'NE        ', '34592     ', 20.00, 0.00, 0.00, 0.00,
 0.00);
INSERT INTO CUSTMAST
("CUST#", NAME, ADDR, CITY, STATE, ZIP, CREDIT, "ONORD$", "CURYR$", "YR1$", "YR2$")
VALUES(345, 'Joe''s Skateboards             ', '123 Main St.                  ',
 'Buffalo                  ', 'NY        ', '11224     ', 200.00, 0.00, 0.00, 0.00,
 0.00);
INSERT INTO CUSTMAST
("CUST#", NAME, ADDR, CITY, STATE, ZIP, CREDIT, "ONORD$", "CURYR$", "YR1$", "YR2$")
VALUES(495, 'Best Stuff You Can Buy        ', '25 2nd St.                    ',
 'Cincinnati               ', 'OH        ', '44121-1106', 20.00, 0.00, 0.00, 0.00,
 0.00);
INSERT INTO CUSTMAST
("CUST#", NAME, ADDR, CITY, STATE, ZIP, CREDIT, "ONORD$", "CURYR$", "YR1$", "YR2$")
VALUES(518, 'Nancy Nail                    ', '874 S Somewhere Ave.          ',
 'Portland                 ', 'OR        ', '33687     ', 30.00, 0.00, 0.00, 0.00,
 0.00);
INSERT INTO CUSTMAST
("CUST#", NAME, ADDR, CITY, STATE, ZIP, CREDIT, "ONORD$", "CURYR$", "YR1$", "YR2$")
VALUES(1538, 'John Carter                   ', '1233 Ambling Boulevard        ',
 'Sidney                   ', 'NE        ', '34592     ', 20.00, 0.00, 0.00, 0.00,
 0.00);
INSERT INTO CUSTMAST
("CUST#", NAME, ADDR, CITY, STATE, ZIP, CREDIT, "ONORD$", "CURYR$", "YR1$", "YR2$")
VALUES(8410, 'Terrific Toys                 ', '444 W Creditview Rd           ',
 'Syracuse                 ', 'NY        ', '11253     ', 30.00, 0.00, 0.00, 0.00,
 0.00);

