create or replace
FUNCTION datos_basicos_1 (
    tipoid  VARCHAR2,
    numeroid  VARCHAR2)
    RETURN VARCHAR2 IS v_xml VARCHAR2(20000);
  BEGIN 
  
    SELECT XMLCONCAT(XMLSequenceType(
        XMLFOREST(SUBSTR(c_identificacion.CD_TIPO_DOCUMENTO,8) AS "TIPOID"),
        XMLFOREST(c_identificacion.NUMERO_DOCUMENTO AS "NUMEROID"),
        XMLFOREST(TRIM(c_persona.ROWID_OBJECT) AS "LlaveMDM"),
        XMLFOREST(c_persona.NOMBRE_O_RAZON AS "NombreCliente"),
        XMLFOREST(c_persona_natural.PRIMER_NOMBRE AS "PrimerNombre"),
        XMLFOREST(c_persona_natural.SEGUNDO_NOMBRE AS "SegundoNombre"),
        XMLFOREST(c_persona_natural.PRIMER_APELLIDO AS "PrimerApellido"),
        XMLFOREST(c_persona_natural.SEGUNDO_APELLIDO AS "SegundoApellido"),
        XMLFOREST(CASE WHEN C_PERSONA_XREF.ROWID_SYSTEM='CRM' THEN c_persona_xref.PKEY_SRC_OBJECT ELSE '' END AS "BP"),
		    XMLFOREST(CASE WHEN C_PERSONA_XREF.ROWID_SYSTEM='CIF' THEN c_persona_xref.PKEY_SRC_OBJECT ELSE '' END AS "LlaveCIF"),
        XMLFOREST(infa_intermediate.get_codcatsisfte('CRM','TIPINTERLOC',c_persona.CD_TIPO_INTERLOCUTOR_COMER) AS "TipoPersona"),
        XMLFOREST(infa_intermediate.get_codcatsisfte('CRM','CIIU',c_persona.CD_CIIU) AS "CodigoCIIU"),
        XMLFOREST(infa_intermediate.get_codcatsisfte('CRM','SUBCIIU',c_persona.CD_SUB_CIIU) AS "CodigoSubCIIU"),
        XMLFOREST(infa_intermediate.get_codcatsisfte('CRM','SEGMENTO',c_persona.CD_SEGMENTO) AS "Segmento"),
        XMLFOREST(infa_intermediate.get_codcatsisfte('CRM','SUBSEGMENTO',c_persona.CD_SUBSEGMENTO) AS "Subsegmento"),
        XMLFOREST((SELECT CPR.NOMBRE_O_RAZON FROM SCHMASTE.pkg_ro_persona CPR WHERE CPR.ROWID_OBJECT = get_rowid_persona_2(c_persona.ROWID_OBJECT,'ZCHM04')) AS "NombreGerenteExt"),
        XMLFOREST(CASE WHEN get_rowid_persona_2(c_persona.ROWID_OBJECT,'ZCHM04') = c_persona_xref.ROWID AND c_persona_xref.ROWID_SYSTEM = 'CRM' 
        THEN GET_CODEMPDIA(c_persona_xref.PKEY_SRC_OBJECT)ELSE '' END AS "CodigoGerenteExt"),
        XMLFOREST((SELECT IDN.NUMERO_DOCUMENTO FROM SCHMASTE.pkg_ro_identificacion IDN WHERE IDN.ID_PERSONA = get_rowid_persona_2(c_persona.ROWID_OBJECT,'ZCHM04')) AS  "NumDocGerenteExt"),
        XMLFOREST(CASE WHEN c_rel_persona.REL_DESC = 'BUR011' AND c_persona_xref.ROWID_SYSTEM = 'CRM' 
        THEN get_CODEMPDIA(c_persona_xref.PKEY_SRC_OBJECT)ELSE '' END AS "CodigoGerente"),           
        XMLFOREST(CASE WHEN c_rel_persona.ROWID_PERSONA_2 = c_persona.ROWID_OBJECT 
        AND c_rel_persona.REL_DESC = 'BUR011' THEN c_persona.NOMBRE_O_RAZON ELSE '' END AS "NombreGerente"), 
        XMLFOREST(infa_intermediate.get_codcatsisfte('CRM','ROL',c_persona.CD_ROL_DE_NEGOCIO) AS "Rol"),        
        XMLFOREST(infa_intermediate.get_codcatsisfte('CRM','ESTADO',c_persona.CD_ESTADO_CLIENTE) AS "EstadoCliente"),        
        XMLFOREST(infa_intermediate.get_codcatsisfte('CRM','ESTAVINC',c_persona.CD_ESTADO_VINCULACION) AS "EstadoVincula"),
        XMLFOREST(c_persona.FECHA_VINCULACION AS "FechaEstadoVincula"),
        XMLFOREST('0001-01-03' AS "FechaEstado"),        
        XMLFOREST(infa_intermediate.get_codcatsisfte('CRM','SECTOR',c_oficinas_y_canales.CD_SECTOR_VENTAS) AS "Region"),
        XMLFOREST(infa_intermediate.get_codcatsisfte('CRM','OFIVENTA',c_oficinas_y_canales.CD_OFICINA_VENTAS) AS "CodigoOficina"),      
        XMLFOREST(c_persona.NOMBRE_CORTO_O_SIGLA AS "NombreCCliente"),
        XMLFOREST(infa_intermediate.get_codcatsisfte('CRM','SECCIIU',c_persona.CD_SECTOR) AS "Sector"),
        XMLFOREST(infa_intermediate.get_codcatsisfte('CRM','SUBSECTOR',c_persona.CD_SUBSECTOR) AS "Subsector"),
        XMLFOREST(c_identificacion.FECHA_EXPEDICION AS "FechaExpedicion"),        
        XMLFOREST(infa_intermediate.get_codcatsisfte('CRM','CIUDAD',c_identificacion.CD_CIUDAD_EXPEDICION) AS "CiudadExpedicion"),
        XMLFOREST(c_persona_natural.FECHA_NACIMIENTO AS "FechaNacimiento"),
        XMLFOREST(infa_intermediate.get_codcatsisfte('CRM','PAIS',c_persona_natural.CD_PAIS_NACIMIENTO) AS "PaisNacimiento"),
        XMLFOREST(infa_intermediate.get_codcatsisfte('CRM','CIUDAD',c_persona_natural.CD_PAIS_NACIMIENTO) AS "CiudadNacimiento"),  ---      
        XMLFOREST(infa_intermediate.get_codcatsisfte('CRM','OCUPACION',c_persona_natural.CD_OCUPACION) AS "Ocupacion"),
        XMLFOREST(infa_intermediate.get_codcatsisfte('CRM','PAIS',c_identificacion.CD_PAIS_EXPEDICION) AS "paisExpedicion"),
        XMLFOREST(infa_intermediate.get_codcatsisfte('CRM','RESPUESTA_S_N',c_informaccion_tributar.CD_INTERMEDIARIO_MERC_CAMB) AS "intermediarioMercadoCambiario"),
        XMLFOREST(infa_intermediate.get_codcatsisfte('CRM','VIGSUPER',c_informaccion_tributar.CD_VIGILADO_SUPERFINANCIER) AS "vigiladaSuperfinanciera"),
        XMLFOREST(TO_CHAR(c_persona.FECHA_ACTUALIZACION,'YYYYMMDD') AS "fechaUltimaActualizacion"),
        XMLFOREST(c_persona.FL_TESORERIA AS "esClienteTesoreria"),
        XMLFOREST(CASE WHEN c_rel_persona.REL_TYPE_CODE = 'ZCHM14' AND c_persona_xref.ROWID_SYSTEM = 'CRM' THEN get_USREMPDIA(c_persona_xref.PKEY_SRC_OBJECT)ELSE '' END AS "usuarioRedTrader"),
        XMLFOREST(infa_intermediate.get_codcatsisfte('CRM','CLAGRUPO',c_persona_grupo.CD_CLASE_DE_GRUPO) AS "TipoPersonaGrupo")
    )).getClobVal()
    into v_xml
    from SCHMASTE.pkg_ro_persona c_persona
    inner join SCHMASTE.pkg_ro_persona_xref c_persona_xref on c_persona.ROWID_OBJECT=c_persona_xref.ROWID_OBJECT
    left join SCHMASTE.pkg_ro_rel_persona c_rel_persona on c_persona.ROWID_OBJECT=c_rel_persona.ROWID_PERSONA
    inner join SCHMASTE.pkg_ro_identificacion c_identificacion on c_persona.ROWID_OBJECT=c_identificacion.ID_PERSONA
    inner join SCHMASTE.pkg_ro_persona_natural c_persona_natural on c_persona.ROWID_OBJECT=c_persona_natural.ID_PERSONA
    left join SCHMASTE.pkg_ro_rel_persona c_rel_persona_2 on c_persona.ROWID_OBJECT=c_rel_persona.ROWID_PERSONA_2 -- Agregados para que no falle la consulta pero no esta retornando relaciones
    left join SCHMASTE.pkg_ro_identificacion c_identificacion_2 on c_rel_persona.ROWID_PERSONA_2=c_identificacion_2.ID_PERSONA -- Agreado para lo mismo que el anterior
    left join SCHMASTE.pkg_ro_rel_personas_oficinas c_rel_personas_oficinas on c_persona.ROWID_OBJECT=c_rel_personas_oficinas.ID_PERSONA
    left join SCHMASTE.pkg_ro_oficinas_y_canales c_oficinas_y_canales on c_rel_personas_oficinas.ID_OFICINAS_Y_CANALES=c_oficinas_y_canales.ROWID_OBJECT
    left join SCHMASTE.pkg_ro_informacion_tributar c_informaccion_tributar on c_persona.ROWID_OBJECT=c_informaccion_tributar.ID_PERSONA
    left join SCHMASTE.pkg_ro_persona_grupo c_persona_grupo on c_persona.ROWID_OBJECT=c_persona_grupo.ROWID_OBJECT
    where 
    SUBSTR(c_identificacion.CD_TIPO_DOCUMENTO,8)=tipoid and
    c_identificacion.NUMERO_DOCUMENTO=numeroid and
    c_persona.CONSOLIDATION_IND= 1 and
    c_persona.HUB_STATE_IND = 1 and
    rownum = 1;
    RETURN(v_xml);
     EXCEPTION
     WHEN OTHERS THEN
      v_xml := SQLCODE||SUBSTR(SQLERRM, 1 , 200);
      RETURN(v_xml);
  END;