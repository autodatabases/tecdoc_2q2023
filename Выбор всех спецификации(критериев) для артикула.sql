 SET @ART_ID = 29; /* BOSCH 0 001 106 016 */	
  SET @LNGID = 16; /* BOSCH 0 001 106 016 */	
		SET SESSION group_concat_max_len = 10000000;

   SELECT 
          *
   FROM
   (SELECT DISTINCT
          get_text(CRITERIA.CRI_DES_ID, @LNGID ) AS CRITERIA_NAME, 
          GROUP_CONCAT( DISTINCT              
                 CASE
                     WHEN CRITERIA.CRI_TYPE = 3 
		        THEN 
                            get_text_kt(ARTICLE_CRITERIA.ACR_KV_KT_ID, ARTICLE_CRITERIA.ACR_VALUE, @LNGID) 
                        ELSE
                             ARTICLE_CRITERIA.ACR_VALUE
		        END
          SEPARATOR '; ') AS CRITERIA_VALUE
	 FROM
		  ARTICLE_CRITERIA
          INNER JOIN CRITERIA ON CRITERIA.CRI_ID = ARTICLE_CRITERIA.ACR_CRI_ID
	WHERE
          ARTICLE_CRITERIA.ACR_ART_ID = @ART_ID
    GROUP BY 
          CRITERIA.CRI_ID   
   UNION
   
   SELECT 
	       get_text(L_CRITERIA.CRI_DES_ID, @LNGID ) AS CRITERIA_NAME,
               GROUP_CONCAT( DISTINCT              
               CASE
                    WHEN L_CRITERIA.CRI_TYPE = 3 
		      THEN 
                        get_text_kt(LA_CRITERIA.LAC_KV_KT_ID, LA_CRITERIA.LAC_VALUE, @LNGID) 
                      ELSE
                        LA_CRITERIA.LAC_VALUE
		    END
           SEPARATOR '; ') AS CRITERIA_VALUE
	 FROM
          LINK_ART
          INNER JOIN LA_CRITERIA ON LA_CRITERIA.LAC_LA_ID = LINK_ART.LA_ID
          INNER JOIN CRITERIA AS L_CRITERIA ON L_CRITERIA.CRI_ID = LA_CRITERIA.LAC_CRI_ID
    WHERE
		  LINK_ART.LA_ART_ID = @ART_ID
   GROUP BY 
          L_CRITERIA.CRI_ID) AS ALL_CRITERIA
GROUP BY CRITERIA_NAME