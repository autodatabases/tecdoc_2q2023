SET @PC_ID = 19964;
SET @LNGID = 16;
    SET SESSION group_concat_max_len = 10000000;

    SELECT
          distinct *
    FROM 
    (
        SELECT distinct
               get_text(CRITERIA.CRI_DES_ID, @LNGID ) AS CRITERIA_NAME, 
               GROUP_CONCAT( distinct              
                 CASE
                     WHEN CRITERIA.CRI_TYPE = 3 
		        THEN 
                            get_text_kt(ARTICLE_CRITERIA.ACR_KV_KT_ID, ARTICLE_CRITERIA.ACR_VALUE, @LNGID) 
                        ELSE
                             ARTICLE_CRITERIA.ACR_VALUE
		        END
                 SEPARATOR '; ') AS CRITERIA_VALUE

        FROM 
               LINK_LA_TYP 
               INNER JOIN LINK_ART ON LINK_ART.LA_ID = LINK_LA_TYP.LAT_LA_ID
               INNER JOIN ARTICLE_CRITERIA ON ARTICLE_CRITERIA.ACR_ART_ID = LINK_ART.LA_ART_ID
               INNER JOIN CRITERIA ON CRITERIA.CRI_ID = ARTICLE_CRITERIA.ACR_CRI_ID
        WHERE
               LINK_LA_TYP.LAT_TYP_ID = @PC_ID
                    AND LINK_LA_TYP.LAT_TYPE = 2 -- passenger cars
        GROUP BY 
               CRITERIA.CRI_ID
   UNION  
       SELECT distinct
               get_text(L_CRITERIA.CRI_DES_ID, @LNGID ) AS CRITERIA_NAME,
               GROUP_CONCAT( distinct              
               CASE
                    WHEN L_CRITERIA.CRI_TYPE = 3 
		      THEN 
                        get_text_kt(LA_CRITERIA.LAC_KV_KT_ID, LA_CRITERIA.LAC_VALUE, @LNGID) 
                      ELSE
                        LA_CRITERIA.LAC_VALUE
		    END
               SEPARATOR '; ') AS CRITERIA_VALUE

       FROM 
               LINK_LA_TYP 
               INNER JOIN LA_CRITERIA ON LA_CRITERIA.LAC_LA_ID = LINK_LA_TYP.LAT_LA_ID
               INNER JOIN CRITERIA AS L_CRITERIA ON L_CRITERIA.CRI_ID = LA_CRITERIA.LAC_CRI_ID
       WHERE
               LINK_LA_TYP.LAT_TYP_ID = @PC_ID
               AND LINK_LA_TYP.LAT_TYPE = 2 /* passenger cars */
       GROUP BY 
               L_CRITERIA.CRI_ID) all_criteria
GROUP BY CRITERIA_NAME