SET @PC_ID = 12423; 
    SET @PT_ID = 417; /* Hydraulic Filter, steering system */ 
    SET @SUP_ID = 268; /* JP GROUP */ 
    SET @LINK_TYPE= 2; /* passenger cars */ 
 SET @COUNTRY_FILTER = '14';
   SET @LNGID = 16; /* BOSCH 0 001 106 016 */	
 
    SELECT DISTINCT
           ARTICLES.ART_ID,
           ARTICLES.ART_ARTICLE_NR,
            ART_COUNTRY_SPECIFICS.ACS_STATUS_KV_KV,
           get_text_kt(73,  ART_COUNTRY_SPECIFICS.ACS_STATUS_KV_KV, @LNGID) AS ART_STATUS_TEXT,
                       
           get_text(PRODUCTS.PT_DES_ID, @LNGID) AS DESCRIPTIONS,
/* ------------------------------------------- */                 
          (SELECT 
                CONCAT_WS(0x0a0d2d, get_text_kt(72, ARTICLE_INFO.AIN_KV_TYPE, @LNGID), 
                                    GROUP_CONCAT( DISTINCT(TEXT_MODULE_TEXTS.TMT_TEXT) SEPARATOR 0x0a0d2d ) )
           FROM
                 ARTICLE_INFO
                 LEFT OUTER JOIN TEXT_MODULE_TEXTS ON TEXT_MODULE_TEXTS.TMT_ID = ARTICLE_INFO.AIN_TMT_ID
                      AND (TEXT_MODULE_TEXTS.TMT_LNG_ID = 255 OR TEXT_MODULE_TEXTS.TMT_LNG_ID = @LNGID)
           WHERE
                 ARTICLE_INFO.AIN_ART_ID = ARTICLES.ART_ID AND ARTICLE_INFO.AIN_DISPLAY = 1) AS ART_INFO,
/* ------------------------------------------- */             
         (SELECT
                 GROUP_CONCAT( 
                              CONCAT_WS(': ', get_text(CRITERIA.CRI_DES_ID, @LNGID), 
                                (CASE
                                     WHEN CRITERIA.CRI_TYPE = 3 
										 THEN 
                                           get_text_kt(ARTICLE_CRITERIA.ACR_KV_KT_ID, ARTICLE_CRITERIA.ACR_VALUE, @LNGID) 
                                     ELSE
                                        ARTICLE_CRITERIA.ACR_VALUE
                                END) )
                 SEPARATOR '; ')
          FROM
                 ARTICLE_CRITERIA
                 INNER JOIN CRITERIA ON ARTICLE_CRITERIA.ACR_CRI_ID = CRITERIA.CRI_ID

                 INNER JOIN COUNTRY_RESTRICTIONS ON COUNTRY_RESTRICTIONS.CNTR_ID = ARTICLE_CRITERIA.ACR_CTM
                        AND COUNTRY_RESTRICTIONS.CNTR_COU_ID = @COUNTRY_FILTER
          WHERE
                 ARTICLE_CRITERIA.ACR_ART_ID = ARTICLES.ART_ID AND ARTICLE_CRITERIA.ACR_DISPLAY = 1) AS ARTICLE_CRITERIA,
/* ------------------------------------------- */             
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
                 LA_CRITERIA.LAC_LA_ID = LINK_LA_TYP.LAT_LA_ID AND LA_CRITERIA.LAC_DISPLAY = 1) AS LA_ARTICLE_CRITERIA
/* ------------------------------------------- */ 
    FROM 
           LINK_LA_TYP
                
           INNER JOIN LINK_ART ON LINK_ART.LA_ID = LINK_LA_TYP.LAT_LA_ID
 
           INNER JOIN ARTICLES ON ARTICLES.ART_ID = LINK_ART.LA_ART_ID
        
           INNER JOIN ART_COUNTRY_SPECIFICS ON ART_COUNTRY_SPECIFICS.ACS_ART_ID = ARTICLES.ART_ID
                  AND (ART_COUNTRY_SPECIFICS.ACS_COU_ID = @COUNTRY_FILTER OR ART_COUNTRY_SPECIFICS.ACS_COU_ID = 0)
         
           INNER JOIN SUPPLIERS ON SUPPLIERS.SUP_ID = LINK_LA_TYP.LAT_SUP_ID
           INNER JOIN PRODUCTS ON PRODUCTS.PT_ID = LINK_LA_TYP.LAT_PT_ID
            
    WHERE
           LINK_LA_TYP.LAT_TYP_ID = @PC_ID 
                  AND LINK_LA_TYP.LAT_TYPE = @LINK_TYPE 
                  AND LINK_LA_TYP.LAT_PT_ID = @PT_ID
                  AND LINK_LA_TYP.LAT_SUP_ID = @SUP_ID