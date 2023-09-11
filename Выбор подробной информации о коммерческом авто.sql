SET @CV_ID=17582; -- DAF CF FA 290

    SELECT DISTINCT
           CV_ID AS TECDOC_TYPE_NO,
           CONCAT_WS(' ', MFA_BRAND,  
                   get_text(IFNULL(`MS_COUNTRY_SPECIFICS`.`MSCS_NAME_DES`,`MODELS_SERIES`.`MS_NAME_DES`), @LNGID),
                   get_text(COMMERCIAL_VEHICLES.CV_MODEL_DES, @LNGID) ) AS TYPEL,        
           CV_COUNTRY_SPECIFICS.CCS_CONSTRUCTION_INTERVAL_START,
           CV_COUNTRY_SPECIFICS.CCS_CONSTRUCTION_INTERVAL_END,
           CV_COUNTRY_SPECIFICS.CCS_POWER_PS_START,
           CV_COUNTRY_SPECIFICS.CCS_POWER_PS_UPTO,
           CV_COUNTRY_SPECIFICS.CCS_POWER_KW_START,
           CV_COUNTRY_SPECIFICS.CCS_POWER_KW_UPTO,
           CV_COUNTRY_SPECIFICS.CCS_CAPACITY_TECH,
           CV_COUNTRY_SPECIFICS.CCS_TONNAGE,
        
           get_text(CV_COUNTRY_SPECIFICS.CCS_PLATFORM_TYPE , @LNGID) AS CV_PLATFORM_TYPE,
           get_text(CV_COUNTRY_SPECIFICS.CCS_ENGINE_TYPE , @LNGID) AS CV_ENGINE_TYPE,
           get_text(CV_COUNTRY_SPECIFICS.CCS_AXLE_CONFIGURATION , @LNGID) AS CV_AXLE_CONFIGURATION,
-- ---------------------------------------------------------------    
           (SELECT
                  GROUP_CONCAT( CONCAT(  WHEELBASES.AXLE_GROUP, '/',  WHEELBASES.WHELL_BASE, ' mm' ) )
            FROM
                  WHEELBASES
            WHERE
                  WHEELBASES.CV_ID = COMMERCIAL_VEHICLES.CV_ID) as CV_WHEELBASES,
-- ---------------------------------------------------------------
            (SELECT
                  GROUP_CONCAT( CONCAT( get_text(CV_SUSPENSIONS.AXLE_POS_DES, @LNGID), '/',  get_text(CV_SUSPENSIONS.SUSPENSION_DES, @LNGID) ) )
             FROM
                  CV_SUSPENSIONS
             WHERE
                  CV_SUSPENSIONS.CV_ID = COMMERCIAL_VEHICLES.CV_ID) as CV_SUSPENSIONS,
-- ---------------------------------------------------------------
            (SELECT
                  GROUP_CONCAT( get_text(DRIVERS_CABS.DC_MODEL_DES, @LNGID) )
             FROM
                  DRIVERS_CABS
                  LEFT OUTER JOIN DRIVERS_CABS_DES ON DRIVERS_CABS_DES.DC_ID = DRIVERS_CABS.DC_ID 
             WHERE
                  DRIVERS_CABS_DES.CV_ID = COMMERCIAL_VEHICLES.CV_ID) as DRIVERS_CABS,
-- ---------------------------------------------------------------
            (SELECT
                  GROUP_CONCAT( AXLES.AXL_DESCRIPTION )
             FROM
                  AXLES
                  LEFT OUTER JOIN CV_AXLES_DES ON CV_AXLES_DES.AXL_ID = AXLES.AXL_ID
             WHERE
                  CV_AXLES_DES.CV_ID = COMMERCIAL_VEHICLES.CV_ID) as AXLES,
-- ---------------------------------------------------------------
            (SELECT
                  GROUP_CONCAT( CV_MANUFACTURER_IDS.CV_MANUF_NUM )
             FROM
                  CV_MANUFACTURER_IDS
                  LEFT OUTER JOIN CV_MANUF_IDS_DES ON CV_MANUF_IDS_DES.CV_MANUF_ID = CV_MANUFACTURER_IDS.CV_MANUF_ID
             WHERE
                  CV_MANUF_IDS_DES.CV_ID = COMMERCIAL_VEHICLES.CV_ID) as CV_MANUF_CODES,
-- ---------------------------------------------------------------
            (SELECT
                  GROUP_CONCAT(ENGINES.ENG_CODE)
             FROM
                  ENGINES
                  JOIN ENG_DESIGNATIONS ON (ENGINES.ENG_ID=ENG_DESIGNATIONS.ENG_ID)
             WHERE
                  ENG_DESIGNATIONS.CV_ID = COMMERCIAL_VEHICLES.CV_ID) as CV_ENG_CODES
    FROM
        COMMERCIAL_VEHICLES
        
        INNER JOIN CV_COUNTRY_SPECIFICS ON CV_COUNTRY_SPECIFICS.CCS_CV_ID = COMMERCIAL_VEHICLES.CV_ID
             AND (CV_COUNTRY_SPECIFICS.CCS_COU_ID = @COUNTRY_FILTER OR CV_COUNTRY_SPECIFICS.CCS_COU_ID = 0)
             
        INNER JOIN MODELS_SERIES ON COMMERCIAL_VEHICLES.CV_MS_ID = MODELS_SERIES.MS_ID
        
        LEFT OUTER JOIN `MS_COUNTRY_SPECIFICS`
                     ON `MS_COUNTRY_SPECIFICS`.`MSCS_ID` = `MODELS_SERIES`.`MS_ID`
                    AND `MS_COUNTRY_SPECIFICS`.`MSCS_COU_ID` = @COUNTRY_FILTER 
        
        INNER JOIN MANUFACTURERS ON COMMERCIAL_VEHICLES.CV_MFA_ID = MANUFACTURERS.MFA_ID
       
    WHERE
        COMMERCIAL_VEHICLES.CV_ID = @CV_ID