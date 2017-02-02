create or replace
PACKAGE BODY                   PCK_CONS_CLIENTE_SERV_MDM 
AS
  ------------------------------------------------------------------------------
  -- Procedimiento que consulta los datos basicos del participante
  ------------------------------------------------------------------------------
  PROCEDURE prc_datos_basicos (
    tipoid IN VARCHAR2,
    numeroid IN VARCHAR2,
    tipoconsulta IN CHAR,
    xml_participante OUT VARCHAR,
    Retcode OUT VARCHAR2,
    GlosaRetcode OUT VARCHAR2
  ) IS
    v_update_rowid ROWID;
    v_tp_id NUMBER;
    v_system_id VARCHAR2(100);
    v_ip_id NUMBER := NULL;
  BEGIN 
  
  PCK_LOG_MDM.prc_inicia_log(v_ndoc, SYSDATE, v_update_rowid, v_log_id, v_system_id);
  CASE tipoconsulta
      WHEN '1' THEN
        select DATOS_BASICOS_1(tipoid,numeroid) into v_xml_resp from dual;
      WHEN '2' THEN
        select DATOS_BASICOS_2(numeroid) into v_xml_resp from dual;
      WHEN '3' THEN
        select DATOS_BASICOS_3(numeroid) into v_xml_resp from dual;
      WHEN '4' THEN
        select DATOS_BASICOS_4(numeroid) into v_xml_resp from dual;
    END CASE;
    
    xml_participante :=XML_OUT('1',v_xml_resp) ; 
    Retcode := SUBSTR(xml_participante,0,7);
    IF Retcode='FHUB002' then
      GlosaRetcode := 'No se encontraron datos';
      v_code := SUBSTR(xml_participante,8,3);--CODIGO
      v_errm := SUBSTR(xml_participante,INSTR(xml_participante,'ORA'));--DESC
      PCK_LOG_MDM.prc_termina_log(v_log_id, NULL, Retcode, GlosaRetcode, v_code, v_errm, v_update_rowid);
    else
      v_code := SUBSTR(xml_participante,8,3);--CODIGO
      v_errm := SUBSTR(xml_participante,INSTR(xml_participante,'ORA'));--DESC
      xml_participante :='<datosConsultarClienteResp>' || xml_participante||'</datosConsultarClienteResp>';
      GlosaRetcode := 'Ejecución Exitosa';
      PCK_LOG_MDM.prc_termina_log(v_log_id, NULL, Retcode, GlosaRetcode, v_code, v_errm, v_update_rowid);
    end if;
    EXCEPTION
    WHEN OTHERS THEN
      Retcode:= 'THUB001';
      GlosaRetcode:= 'Error Tecnico de Base de Datos';
      v_code := SQLCODE;
      v_errm := SUBSTR(SQLERRM, 1 , 200);
      PCK_LOG_MDM.prc_termina_log(v_log_id, NULL, Retcode, GlosaRetcode, v_code, v_errm, v_update_rowid);
  END prc_datos_basicos;
  
  ------------------------------------------------------------------------------
  -- Procedimiento que consulta los datos generales del participante
  ------------------------------------------------------------------------------
  PROCEDURE prc_datos_generales (
    tipoid IN VARCHAR2,
    numeroid IN VARCHAR2,
    tipoconsulta IN VARCHAR2,---NUEVO
    xml_participante OUT VARCHAR
  ) IS
  BEGIN  
    CASE tipoconsulta
      WHEN '1' THEN
        select DATOS_GENERALES_1(tipoid,numeroid) into v_xml_resp from dual;
      WHEN '2' THEN
        select DATOS_GENERALES_2(numeroid) into v_xml_resp from dual;
      WHEN '3' THEN
        select DATOS_GENERALES_3(numeroid) into v_xml_resp from dual;
      WHEN '4' THEN
        select DATOS_GENERALES_4(numeroid) into v_xml_resp from dual;
    END CASE;
    
    xml_participante := XML_OUT('2',v_xml_resp);
    
  END prc_datos_generales;
  
  ------------------------------------------------------------------------------
  -- Procedimiento que consulta los financieros y tributarios del participante
  ------------------------------------------------------------------------------
  PROCEDURE prc_inf_finan_trib (
    tipoid IN VARCHAR2,
    numeroid IN VARCHAR2,
    tipoconsulta IN VARCHAR2,---NUEVO
    xml_participante OUT VARCHAR
  ) IS
  BEGIN
    CASE tipoconsulta
      WHEN '1' THEN
        select INF_FINAN_TRIB_1(tipoid,numeroid) into v_xml_resp from dual;
      WHEN '2' THEN
        select INF_FINAN_TRIB_2(numeroid) into v_xml_resp from dual;
      WHEN '3' THEN
        select INF_FINAN_TRIB_3(numeroid) into v_xml_resp from dual;
      WHEN '4' THEN
        select INF_FINAN_TRIB_4(numeroid) into v_xml_resp from dual;
    END CASE;
    
    xml_participante := XML_OUT('3',v_xml_resp);
    
  END prc_inf_finan_trib;  

  ------------------------------------------------------------------------------
  -- Procedimiento que consulta los financieros y tributarios del participante
  ------------------------------------------------------------------------------
  PROCEDURE prc_ubicacion_cte (
    tipoid IN VARCHAR2,
    numeroid IN VARCHAR2,
    tipoconsulta IN VARCHAR2,---NUEVO
    xml_participante OUT VARCHAR
  ) IS
  BEGIN 
    CASE tipoconsulta
      WHEN '1' THEN
        select UBICACION_CTE_1(tipoid,numeroid) into v_xml_resp from dual;
      WHEN '2' THEN
        select UBICACION_CTE_2(numeroid) into v_xml_resp from dual;
      WHEN '3' THEN
        select UBICACION_CTE_3(numeroid) into v_xml_resp from dual;
      WHEN '4' THEN
        select UBICACION_CTE_4(numeroid) into v_xml_resp from dual;
    END CASE;
    
    xml_participante := XML_OUT('4',v_xml_resp);
    
  END prc_ubicacion_cte;  

  ------------------------------------------------------------------------------
  -- Procedimiento de inicio
  ------------------------------------------------------------------------------
  PROCEDURE INICIO (
    xml_header IN VARCHAR2,
    tipoid IN VARCHAR2,
    numeroid IN OUT VARCHAR2,
    tipoconsulta IN VARCHAR2,
    contenedor IN VARCHAR2,
    xml_participante OUT VARCHAR,
    Retcode OUT VARCHAR2,
    GlosaRetcode OUT VARCHAR2
  ) IS
   v_update_rowid ROWID;
    v_tp_id NUMBER;
    v_system_id VARCHAR2(100);
    v_ip_id NUMBER := NULL;
  
  BEGIN
    v_doc := dbms_xmldom.newDOMDocument(XMLType(xml_header));
    v_ndoc := dbms_xmldom.makeNode(v_doc);
    
    CASE contenedor
      -- Datos Basicos
      WHEN '1' THEN
        prc_datos_basicos(tipoid, numeroid,tipoconsulta,xml_participante,Retcode,GlosaRetcode);
      -- Datos Generales
      WHEN '2' THEN
        prc_datos_generales(tipoid, numeroid,tipoconsulta,xml_participante);
      -- Datos Financieros
      WHEN '3' THEN
        prc_inf_finan_trib(tipoid, numeroid,tipoconsulta,xml_participante);
      -- Se solicita el contenedor de datos de informacion financiera y tributaria
      WHEN '4' THEN
        prc_ubicacion_cte(tipoid, numeroid,tipoconsulta,xml_participante);
        
      ELSE 
        PCK_LOG_MDM.prc_inicia_log(v_ndoc, SYSDATE, v_update_rowid, v_log_id, v_system_id);
        Retcode:= 'THUB001';
        GlosaRetcode:= 'Error Tecnico de Base de Datos';
        v_code := '-6592';
        v_errm := 'ORA-06592: No se ha encontrado la opción CASE al ejecutar la sentencia CASE';
        PCK_LOG_MDM.prc_termina_log(v_log_id, NULL, Retcode, GlosaRetcode, v_code, v_errm, v_update_rowid);
    END CASE;
    xml_participante :=  xml_participante;
  END INICIO;

END PCK_CONS_CLIENTE_SERV_MDM;