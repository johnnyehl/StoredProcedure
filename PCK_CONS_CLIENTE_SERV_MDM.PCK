
  CREATE OR REPLACE PACKAGE "OSEVILLA"."PCK_CONS_CLIENTE_SERV_MDM" 
AS
  /*---------------------------------------------------------
  --PACKAGE NAME: PCK_CONS_CLIENTE_SERV_HUB2
  --BASE DE DATOS: MASTEDDB
  --ORACLE 11
  --DESCRIPCION:  Operacion de consulta datos basicos del cliente
  --FECHA YYYY-MM-DD: 2016-09-20
  --AUTOR: POWERDATA
  --VERSION: 1.0
  */

  --------------------------
  -- Definicion de variables
  --------------------------
  v_xml XMLTYPE;
  v_xml_resp varchar2(20000);
  v_doc dbms_xmldom.DOMDocument;
  v_ndoc dbms_xmldom.DOMNode;
  v_log_id NUMBER;
  v_code VARCHAR2(20);
  v_errm VARCHAR2(200);
  ---------------------
  -- Procedimientos
  ---------------------
  PROCEDURE INICIO (
    xml_header IN VARCHAR2,
    -----------------------
    tipoid IN VARCHAR2,
    numeroid IN OUT VARCHAR2,
    tipoconsulta IN VARCHAR2,
    contenedor IN VARCHAR2,
    xml_participante OUT VARCHAR,
    -----------------------------
    Retcode OUT VARCHAR2,
    GlosaRetcode OUT VARCHAR2
  );
END PCK_CONS_CLIENTE_SERV_MDM;
/
