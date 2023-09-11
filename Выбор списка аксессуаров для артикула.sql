  SET @ART_ID = 1759869; /* HELLA 1A3 005 760-518 */
    
    SELECT 
          ARTICLES.ART_ID,
          ARTICLES.ART_ARTICLE_NR,
          get_text(ARTICLES.ART_DES_ID, @LNGID) AS ART_DES_TEXT,
          get_text(KEY_VALUES.KV_DES_ID, @LNGID) AS ART_STATUS_TEXT,
-- ---------------------------------------------------------------             
          CONCAT_WS(' ',
                    (SELECT 
                           get_text(PRODUCTS.PT_DES_ID, @LNGID)
                     FROM
                           LINK_ART_PT
                           INNER JOIN PRODUCTS ON PRODUCTS.PT_ID = LINK_ART_PT.LAP_PT_ID
                     WHERE
                           LINK_ART_PT.LAP_ART_ID = ARTICLES.ART_ID 
					 LIMIT 1), 
                           
					 get_text(ARTICLES.ART_DES_ID, @LNGID) ) AS ART_PRODUCT_NAME,
-- ---------------------------------------------------------------              
          (SELECT
                 GROUP_CONCAT( 
                              CONCAT_WS(': ', get_text(CRITERIA.CRI_SHORT_DES_ID, @LNGID), 
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
                 ARTICLE_CRITERIA.ACR_ART_ID = ARTICLES.ART_ID 
                 AND ARTICLE_CRITERIA.ACR_DISPLAY = 1 LIMIT 4 ) AS ARTICLE_CRITERIA
-- ---------------------------------------------------------------
        
    FROM
        ART_ACCS_LIST
        INNER JOIN ARTICLES ON ARTICLES.ART_ID = ART_ACCS_LIST.ART_ACCS_ID
        
        INNER JOIN ART_COUNTRY_SPECIFICS ON ART_COUNTRY_SPECIFICS.ACS_ART_ID = ARTICLES.ART_ID
            AND (ART_COUNTRY_SPECIFICS.ACS_COU_ID = @COUNTRY_FILTER OR ART_COUNTRY_SPECIFICS.ACS_COU_ID = 0)
        
        LEFT OUTER JOIN KEY_VALUES ON KEY_VALUES.KV_KT_ID = 73
            AND KEY_VALUES.KV_KV = ART_COUNTRY_SPECIFICS.ACS_STATUS_KV_KV
            
    WHERE
        ART_ACCS_LIST.ART_ACCS_PARENT_ID = @ART_ID