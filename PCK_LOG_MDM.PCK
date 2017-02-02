
  CREATE OR REPLACE PACKAGE "OSEVILLA"."PCK_LOG_MDM" 
AS
/*---------------------------------------------------------
--PACKAGE NAME: PCK_LOG_MDM
--BASE DE DATOS: MASTEDDB
--ORACLE 11
--DESCRIPCION: Inserta la informacion de LOG de servicios para tener
--             la trazabilidad de la ejecucion de cada llamado.
--FECHA YYYY-MM-DD: 2016-09-22
--AUTOR: Luis Alejandro Herrera
--VERSION: 1.0
---------------------------------------------------------*/
---------------------
-- Variables a declarar
---------------------
RUTA_DATOS  VARCHAR(500);
VLS			SCHMDLOGMDM.LOGSERVICIOS%ROWTYPE;

TYPE TBL_CODERROR IS TABLE OF NUMBER
INDEX BY VARCHAR2(20);
VCODERR TBL_CODERROR;
---------------------
-- Procedimientos
---------------------
PROCEDURE PRC_CARGA_ERRORES;

PROCEDURE PRC_INICIA_LOG(
NDOC IN dbms_xmldom.DOMNode,
SYSTIME IN TIMESTAMP,
UPDATEROWID OUT ROWID,
LOGID OUT NUMBER,
SYSTEMID OUT VARCHAR2
);

PROCEDURE PRC_TERMINA_LOG(
LOGID IN NUMBER,
CIF_ID_HUB IN NUMBER,
COD_TP_ERR IN VARCHAR2,
DESC_TP_ERR IN VARCHAR2,
COD_ORA IN VARCHAR2,
DESC_ORA IN VARCHAR2,
UPDATEROWID IN ROWID
);


END PCK_LOG_MDM;
/
