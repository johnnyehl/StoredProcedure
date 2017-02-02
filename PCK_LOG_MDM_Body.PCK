
  CREATE OR REPLACE PACKAGE BODY "OSEVILLA"."PCK_LOG_MDM" 
AS

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------
-- PROCEDIMIENTO PARA LA CARGA DE MENSAJES DE ERROR EN MEMORIA
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------
PROCEDURE PRC_CARGA_ERRORES IS
BEGIN
	FOR REG IN (SELECT * FROM OSEVILLA.MENSAJEERRORSERVICIO) LOOP
		VCODERR(REG.CODMENSAJEERROR):=REG.IDMENSAJEERRORSERVICIO;
	END LOOP;
END;


--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------
-- FUNCION BUSCA CODIGO ERROR LOG
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------
FUNCTION FUN_BUSCA_ERROR(CODIGO IN VARCHAR2) RETURN NUMBER IS
IDERROR NUMBER;
BEGIN

	RETURN VCODERR(CODIGO);
 	SELECT IDMENSAJEERRORSERVICIO INTO IDERROR
	FROM OSEVILLA.MENSAJEERRORSERVICIO
	WHERE CODMENSAJEERROR = CODIGO;

	RETURN IDERROR;

END FUN_BUSCA_ERROR;


--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- PROCEDIMIENTO PRC_INICIA_LOG
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
PROCEDURE PRC_INICIA_LOG (
NDOC IN dbms_xmldom.DOMNode,
SYSTIME IN TIMESTAMP,
UPDATEROWID OUT ROWID,
LOGID OUT NUMBER,
SYSTEMID OUT VARCHAR2
)
AS
PRAGMA AUTONOMOUS_TRANSACTION;
VXML VARCHAR(100);
Rutaxml VARCHAR2(100);
BEGIN
  --Se PRC_CARGA_ERRORES para cargar los errores en memoria
	PRC_CARGA_ERRORES;
  --Execute immediate 'alter session set sql_trace=true';
	SELECT OSEVILLA.SEQ_LOG_SERV.NEXTVAL INTO LOGID FROM dual;
	VLS.IDLOG := LOGID;

	Rutaxml:='/Header/requestData/destination/name/text()';
	VXML:=TRIM(dbms_xslprocessor.valueOf(NDOC,Rutaxml));
	VLS.DESCSERVICIO:=NVL(VXML,'NA');

	Rutaxml:='/Header/requestData/destination/operation/text()';
	VXML:=TRIM(dbms_xslprocessor.valueOf(NDOC,Rutaxml));
	VLS.OPERACION:=VXML;

	VLS.FECHAEJECUCION:= SYSTIME;

	SELECT USER,sys_context('USERENV','HOST'),sys_context('USERENV','IP_ADDRESS')
  INTO VLS.USUARIOBD,VLS.NOMBREHOST,VLS.HOST FROM dual;

	Rutaxml:='/Header/requestData/userId/userName/text()';
	VXML:=TRIM(dbms_xslprocessor.valueOf(NDOC,Rutaxml));
	VLS.USUARIOAPLICACION:=VXML;

	Rutaxml:='/Header/systemId/text()';
	VXML:=TRIM(dbms_xslprocessor.valueOf(NDOC,Rutaxml));
	VLS.SYSTEMID:=VXML;
  SYSTEMID:=VXML;

	Rutaxml:='/Header/messageId/text()';
	VXML:=TRIM(dbms_xslprocessor.valueOf(NDOC,Rutaxml));
	VLS.MESSAGEID:=VXML;

	VLS.ID_MENSAJE_ERROR_SERVICIO:=FUN_BUSCA_ERROR('HUB000');

	INSERT INTO OSEVILLA.LOGSERVICIOS VALUES VLS RETURNING ROWID INTO UPDATEROWID;

	COMMIT;

 	EXCEPTION
		 WHEN OTHERS THEN
     ROLLBACK;
END PRC_INICIA_LOG;


--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------
-- PROCEDIMIENTO PRC_TERMINA_LOG
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------

PROCEDURE PRC_TERMINA_LOG(
LOGID IN NUMBER,
CIF_ID_HUB IN NUMBER,
COD_TP_ERR IN VARCHAR2,
DESC_TP_ERR IN VARCHAR2,
COD_ORA IN VARCHAR2,
DESC_ORA IN VARCHAR2,
UPDATEROWID IN ROWID
)
AS
PRAGMA AUTONOMOUS_TRANSACTION;
IDMES NUMBER;
BEGIN

  BEGIN
    SELECT
    IDMENSAJEERRORSERVICIO INTO IDMES
    FROM OSEVILLA.MENSAJEERRORSERVICIO
    WHERE CODMENSAJEERROR = COD_TP_ERR;
    EXCEPTION
       WHEN NO_DATA_FOUND THEN
            IDMES:=-1;
  END;

UPDATE OSEVILLA.LOGSERVICIOS
SET
    FECHARESPUESTA = SYSTIMESTAMP
   ,IDOBJETIVO = CIF_ID_HUB
   ,ID_MENSAJE_ERROR_SERVICIO = IDMES
   ,DESC_MENSAJE_LOG = DESC_TP_ERR
   ,ERRORSISTEMABD = COD_ORA
   ,DESCERRORSISTEMABD = DESC_ORA
WHERE ROWID=UPDATEROWID;
COMMIT;
EXCEPTION
         WHEN OTHERS THEN
     ROLLBACK;
END PRC_TERMINA_LOG;


END PCK_LOG_MDM;
/
