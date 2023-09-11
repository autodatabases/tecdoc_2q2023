SET @ART_NUM = "0 001 108 466";
     SET @SUP_ID = 30; /* BOSCH */ 

     SELECT
          ARTICLES.ART_ID,
          ARTICLES.ART_ARTICLE_NR,
          ARTICLES.ART_SUP_BRAND,
          ART_COUNTRY_SPECIFICS.ACS_PACK_UNIT,
          ART_COUNTRY_SPECIFICS.ACS_QUANTITY_PER_UNIT,
          ART_COUNTRY_SPECIFICS.ACS_STATUS_DATE,
          get_text(KEY_VALUES.KV_DES_ID, @LNGID) AS ART_STATUS_TEXT,
-- ---------------------------------------------------------------        
          CONCAT_WS(' ', get_text(ARTICLES.ART_COMPLETE_DES_ID, @LNGID), get_text(ARTICLES.ART_DES_ID, @LNGID) ) AS ART_PRODUCT_NAME,
-- ---------------------------------------------------------------                  
          (SELECT 
                CONCAT_WS(0x0a0d2d, get_text_kt(72, ARTICLE_INFO.AIN_KV_TYPE, @LNGID), 
                                    GROUP_CONCAT(  IFNULL( TEXT_MODULE_TEXTS.TMT_TEXT, TEXT_MODULE_TEXTS_UNI.TMT_TEXT )  SEPARATOR 0x0a0d2d ) )
           FROM
                 ARTICLE_INFO
                 LEFT OUTER JOIN TEXT_MODULE_TEXTS ON TEXT_MODULE_TEXTS.TMT_ID = ARTICLE_INFO.AIN_TMT_ID
                      AND  TEXT_MODULE_TEXTS.TMT_LNG_ID = @LNGID
                      
                 LEFT OUTER JOIN TEXT_MODULE_TEXTS AS TEXT_MODULE_TEXTS_UNI ON TEXT_MODULE_TEXTS_UNI.TMT_ID = ARTICLE_INFO.AIN_TMT_ID
                      AND  TEXT_MODULE_TEXTS_UNI.TMT_LNG_ID = 255
            WHERE
                 ARTICLE_INFO.AIN_ART_ID = ARTICLES.ART_ID) AS ART_INFO,
-- ---------------------------------------------------------------                 
           (SELECT
                 GROUP_CONCAT( SUPERSEDED_ARTICLES.SUA_NUMBER )
            FROM
                 SUPERSEDED_ARTICLES
				 INNER JOIN COUNTRY_RESTRICTIONS ON COUNTRY_RESTRICTIONS.CNTR_ID = SUPERSEDED_ARTICLES.SUA_CTM
						AND COUNTRY_RESTRICTIONS.CNTR_COU_ID = @COUNTRY_FILTER
            WHERE
                 SUPERSEDED_ARTICLES.SUA_ART_ID = ARTICLES.ART_ID) AS 'SUPERSEDED BY',
-- ---------------------------------------------------------------                 
           (SELECT
                  GROUP_CONCAT( ARTICLES.ART_ARTICLE_NR )
            FROM
                  SUPERSEDED_ARTICLES
                  INNER JOIN ARTICLES ON ARTICLES.ART_ID = SUPERSEDED_ARTICLES.SUA_ART_ID
				  INNER JOIN COUNTRY_RESTRICTIONS ON COUNTRY_RESTRICTIONS.CNTR_ID = SUPERSEDED_ARTICLES.SUA_CTM
						AND COUNTRY_RESTRICTIONS.CNTR_COU_ID = @COUNTRY_FILTER
           WHERE
                  SUPERSEDED_ARTICLES.SUA_NEW_ART_ID = ARTICLES.ART_ID) AS 'SUPERSEDED',
-- ---------------------------------------------------------------                
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
           WHERE
                 ARTICLE_CRITERIA.ACR_ART_ID = ARTICLES.ART_ID LIMIT 4 ) AS ARTICLE_CRITERIA,
-- --------------------------------------------------------------- 
		   GROUP_CONCAT(
                         IF( ART_LOOKUP.ARL_KIND = 3,
							 CONCAT_WS( ': ', ART_LOOKUP.ARL_BRA_BRAND, ART_LOOKUP.ARL_DISPLAY_NR ),
                             NULL )
		   SEPARATOR 0x0a ) AS OEM_NUMBERS,
-- --------------------------------------------------------------- 
		   GROUP_CONCAT( 
						 IF( ART_LOOKUP.ARL_KIND = 5,
                             ART_LOOKUP.ARL_DISPLAY_NR,
                             NULL )
		   SEPARATOR 0x0a ) AS EAN_NUMBERS
-- ---------------------------------------------------------------       
    FROM
        ARTICLES
        INNER JOIN ART_COUNTRY_SPECIFICS ON ART_COUNTRY_SPECIFICS.ACS_ART_ID = ARTICLES.ART_ID
             AND (ART_COUNTRY_SPECIFICS.ACS_COU_ID = @COUNTRY_FILTER OR ART_COUNTRY_SPECIFICS.ACS_COU_ID = 255)
              
        LEFT OUTER JOIN KEY_VALUES ON KEY_VALUES.KV_KT_ID = 73
             AND KEY_VALUES.KV_KV = ART_COUNTRY_SPECIFICS.ACS_STATUS_KV_KV
  
        INNER JOIN SUPPLIERS ON ARTICLES.ART_SUP_ID = SUP_ID
        
        INNER JOIN ART_LOOKUP ON ART_LOOKUP.ARL_ART_ID = ARTICLES.ART_ID
 
    WHERE
        ARTICLES.ART_ARTICLE_NR = @ART_NUM 
        AND ARTICLES.ART_SUP_ID = @SUP_ID