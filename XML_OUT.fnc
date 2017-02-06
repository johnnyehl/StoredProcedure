create or replace
FUNCTION XML_OUT (
    ind CHAR,
    xml_resp  VARCHAR2
    )
    RETURN VARCHAR2 IS v_xml VARCHAR2(20000);
  BEGIN 
  CASE ind
      WHEN '1' THEN
        IF SUBSTR(xml_resp, 0 , 1)<>'<'  THEN
        v_xml := 'FHUB002'||xml_resp||'<parametrosProcedimientoAlmacenado><nombre>XMLOUT</nombre><tipo>string</tipo><entrada>false</entrada><valor>' ||
         '<datosCamposFinancieros></datosCamposFinancieros>' ||
         '</valor></parametrosProcedimientoAlmacenado>
         <parametrosProcedimientoAlmacenado><nombre>Retcode</nombre><tipo>string</tipo><entrada>false</entrada><valor>FHUB002</valor></parametrosProcedimientoAlmacenado>
         <parametrosProcedimientoAlmacenado><nombre>GlosaRetcode</nombre><tipo>string</tipo><entrada>false</entrada><valor>No se encontraron datos</valor></parametrosProcedimientoAlmacenado>';
 
        ELSIF xml_resp IS NOT NULL THEN
        v_xml := 'HUB000<parametrosProcedimientoAlmacenado><nombre>XMLOUT</nombre><tipo>string</tipo><entrada>false</entrada><valor>' ||
        '<datosCamposBasicos>' || xml_resp || '</datosCamposBasicos>' ||
        '</valor></parametrosProcedimientoAlmacenado>
        <parametrosProcedimientoAlmacenado><nombre>Retcode</nombre><tipo>string</tipo><entrada>false</entrada><valor>HUB000</valor></parametrosProcedimientoAlmacenado>
        <parametrosProcedimientoAlmacenado><nombre>GlosaRetcode</nombre><tipo>string</tipo><entrada>false</entrada><valor>Ejecucion Exitosa</valor></parametrosProcedimientoAlmacenado>';
        END IF;
      WHEN '2' THEN
         IF xml_resp IS NULL  THEN
         v_xml := 'FHUB002<parametrosProcedimientoAlmacenado><nombre>XMLOUT</nombre><tipo>string</tipo><entrada>false</entrada><valor>' ||
         '<datosCamposGenerales></datosCamposGenerales>' ||
         '</valor></parametrosProcedimientoAlmacenado>
         <parametrosProcedimientoAlmacenado><nombre>Retcode</nombre><tipo>string</tipo><entrada>false</entrada><valor>FHUB002</valor></parametrosProcedimientoAlmacenado>
         <parametrosProcedimientoAlmacenado><nombre>GlosaRetcode</nombre><tipo>string</tipo><entrada>false</entrada><valor>No se encontraron datos</valor></parametrosProcedimientoAlmacenado>';
 
         ELSIF xml_resp IS NOT NULL THEN
         v_xml := 'HUB000<parametrosProcedimientoAlmacenado><nombre>XMLOUT</nombre><tipo>string</tipo><entrada>false</entrada><valor>' ||
         '<datosCamposGenerales>' || xml_resp || '</datosCamposGenerales>' ||
         '</valor></parametrosProcedimientoAlmacenado>
         <parametrosProcedimientoAlmacenado><nombre>Retcode</nombre><tipo>string</tipo><entrada>false</entrada><valor>HUB000</valor></parametrosProcedimientoAlmacenado>
         <parametrosProcedimientoAlmacenado><nombre>GlosaRetcode</nombre><tipo>string</tipo><entrada>false</entrada><valor>Ejecucion Exitosa</valor></parametrosProcedimientoAlmacenado>';
         END IF;
      WHEN '3' THEN
        IF xml_resp IS NULL  THEN
         v_xml := 'FHUB002<parametrosProcedimientoAlmacenado><nombre>XMLOUT</nombre><tipo>string</tipo><entrada>false</entrada><valor>' ||
         '<datosCamposFinancieros></datosCamposFinancieros>' ||
         '</valor></parametrosProcedimientoAlmacenado>
         <parametrosProcedimientoAlmacenado><nombre>Retcode</nombre><tipo>string</tipo><entrada>false</entrada><valor>FHUB002</valor></parametrosProcedimientoAlmacenado>
         <parametrosProcedimientoAlmacenado><nombre>GlosaRetcode</nombre><tipo>string</tipo><entrada>false</entrada><valor>No se encontraron datos</valor></parametrosProcedimientoAlmacenado>';
 
         ELSIF xml_resp IS NOT NULL THEN
         v_xml := 'HUB000<parametrosProcedimientoAlmacenado><nombre>XMLOUT</nombre><tipo>string</tipo><entrada>false</entrada><valor>' ||
         '<datosCamposFinancieros>' || xml_resp || '</datosCamposFinancieros>' ||
         '</valor></parametrosProcedimientoAlmacenado>
         <parametrosProcedimientoAlmacenado><nombre>Retcode</nombre><tipo>string</tipo><entrada>false</entrada><valor>HUB000</valor></parametrosProcedimientoAlmacenado>
         <parametrosProcedimientoAlmacenado><nombre>GlosaRetcode</nombre><tipo>string</tipo><entrada>false</entrada><valor>Ejecucion Exitosa</valor></parametrosProcedimientoAlmacenado>';
         END IF;
      WHEN '4' THEN
         IF xml_resp IS NULL  THEN
         v_xml := 'FHUB002<parametrosProcedimientoAlmacenado><nombre>XMLOUT</nombre><tipo>string</tipo><entrada>false</entrada><valor>' ||
         '<datosCamposFinancieros></datosCamposFinancieros>' ||
         '</valor></parametrosProcedimientoAlmacenado>
         <parametrosProcedimientoAlmacenado><nombre>Retcode</nombre><tipo>string</tipo><entrada>false</entrada><valor>FHUB002</valor></parametrosProcedimientoAlmacenado>
         <parametrosProcedimientoAlmacenado><nombre>GlosaRetcode</nombre><tipo>string</tipo><entrada>false</entrada><valor>No se encontraron datos</valor></parametrosProcedimientoAlmacenado>';
 
         ELSIF xml_resp IS NOT NULL THEN
         v_xml := 'HUB000<parametrosProcedimientoAlmacenado><nombre>XMLOUT</nombre><tipo>string</tipo><entrada>false</entrada><valor>' ||
         '<datosCamposCamposDireccion>' || xml_resp || '</datosCamposCamposDireccion>' ||
         '</valor></parametrosProcedimientoAlmacenado>
         <parametrosProcedimientoAlmacenado><nombre>Retcode</nombre><tipo>string</tipo><entrada>false</entrada><valor>HUB000</valor></parametrosProcedimientoAlmacenado>
         <parametrosProcedimientoAlmacenado><nombre>GlosaRetcode</nombre><tipo>string</tipo><entrada>false</entrada><valor>Ejecucion Exitosa</valor></parametrosProcedimientoAlmacenado>';
         END IF;
    END CASE;
    RETURN(v_xml);
  END;