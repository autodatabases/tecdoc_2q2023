 SET @ART_ID = 96; /* BOSCH 0 001 107 066 */	

    SELECT DISTINCT
        (SELECT
                 GROUP_CONCAT(
                              CONCAT_WS(': ', get_text(CRITERIA.CRI_DES_ID, @LNGID),
                                (CASE
                                     WHEN CRITERIA.CRI_TYPE = 3
                                         THEN
                                           get_text_kt(LA_CRITERIA.LAC_KV_KT_ID, LA_CRITERIA.LAC_VALUE, @LNGID)
                                     ELSE
                                        LA_CRITERIA.LAC_VALUE
                                END) )
                 SEPARATOR '; ')
           FROM
                 LA_CRITERIA
                 INNER JOIN CRITERIA ON LA_CRITERIA.LAC_CRI_ID = CRITERIA.CRI_ID
           WHERE
                 LA_CRITERIA.LAC_LA_ID = LINK_LA_TYP.LAT_LA_ID AND LA_CRITERIA.LAC_DISPLAY = 1) AS 'TERM_OF_USE',

           PASSENGER_CARS.PC_ID,
           MODELS_SERIES.MS_ID,
           CONCAT_WS(' ', MFA_BRAND,  
                 get_text(IFNULL(`MS_COUNTRY_SPECIFICS`.`MSCS_NAME_DES`,`MODELS_SERIES`.`MS_NAME_DES`), @LNGID),
                 get_text(PASSENGER_CARS.PC_MODEL_DES, @LNGID) ) AS TYPEL,
           PC_COUNTRY_SPECIFICS.PCS_CONSTRUCTION_INTERVAL_START,
           PC_COUNTRY_SPECIFICS.PCS_CONSTRUCTION_INTERVAL_END,
           PC_COUNTRY_SPECIFICS.PCS_POWER_KW,
           PC_COUNTRY_SPECIFICS.PCS_POWER_PS,
           PC_COUNTRY_SPECIFICS.PCS_CAPACITY_TECH,
           get_text(PC_COUNTRY_SPECIFICS.PCS_BODY_TYPE, @LNGID) AS PC_BODY_TYPE,

           (SELECT
                  GROUP_CONCAT(ENGINES.ENG_CODE)
            FROM
                  ENGINES
                  JOIN ENG_DESIGNATIONS ON (ENGINES.ENG_ID=ENG_DESIGNATIONS.ENG_ID)
            WHERE
                  ENG_DESIGNATIONS.PC_ID = PASSENGER_CARS.PC_ID) AS PC_ENG_CODES
    FROM
           LINK_ART 
         
           INNER JOIN LINK_LA_TYP ON LINK_LA_TYP.LAT_LA_ID = LINK_ART.LA_ID
                  AND LINK_LA_TYP.LAT_TYPE = 2
             
           INNER JOIN PASSENGER_CARS ON PASSENGER_CARS.PC_ID = LINK_LA_TYP.LAT_TYP_ID
         
           INNER JOIN PC_COUNTRY_SPECIFICS ON PC_COUNTRY_SPECIFICS.PCS_PC_ID = PASSENGER_CARS.PC_ID
               AND (PC_COUNTRY_SPECIFICS.PCS_COU_ID = @COUNTRY_FILTER OR PC_COUNTRY_SPECIFICS.PCS_COU_ID = 0)

           INNER JOIN MODELS_SERIES ON MODELS_SERIES.MS_ID = PASSENGER_CARS.PC_MS_ID       

           INNER JOIN MANUFACTURERS ON MANUFACTURERS.MFA_ID = PASSENGER_CARS.PC_MFA_ID

          LEFT OUTER JOIN `MS_COUNTRY_SPECIFICS`
                       ON `MS_COUNTRY_SPECIFICS`.`MSCS_ID` = `MODELS_SERIES`.`MS_ID`
                      AND `MS_COUNTRY_SPECIFICS`.`MSCS_COU_ID` = @COUNTRY_FILTER 
    WHERE
           LINK_ART.LA_ART_ID = @ART_ID