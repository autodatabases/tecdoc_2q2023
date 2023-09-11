 SET @PC_ID = 108275; 
    SET @PT_ID = 1; /* Satelis 125 (J2) */
    SET @SUP_ID = 434; /* DETA */
    SET @LINK_TYPE= 2; /* passenger cars */
 
    SELECT DISTINCT
           ARTICLES.ART_ID,
           LINK_PT_CRI.LPC_CRI_ID,
           get_text(CRITERIA.CRI_DES_ID, @LNGID),
           ARTICLE_CRITERIA.ACR_VALUE,
           LINK_PT_CRI.LPC_SUGGESTION
           
    FROM 
           LINK_PT_CRI
           
           INNER JOIN LINK_LA_TYP ON LINK_LA_TYP.LAT_TYP_ID = @PC_ID 
                  AND LINK_LA_TYP.LAT_TYPE = @LINK_TYPE 
                  AND LINK_LA_TYP.LAT_PT_ID = @PT_ID
                  AND LINK_LA_TYP.LAT_SUP_ID = @SUP_ID
                  
           INNER JOIN LINK_ART ON LINK_ART.LA_ID = LINK_LA_TYP.LAT_LA_ID
            
           INNER JOIN ARTICLES ON ARTICLES.ART_ID = LINK_ART.LA_ART_ID 
           
           INNER JOIN ARTICLE_CRITERIA ON ARTICLE_CRITERIA.ACR_ART_ID = ARTICLES.ART_ID
                  AND ARTICLE_CRITERIA.ACR_CRI_ID = LINK_PT_CRI.LPC_CRI_ID
                  
           INNER JOIN CRITERIA ON ARTICLE_CRITERIA.ACR_CRI_ID = CRITERIA.CRI_ID
           
    WHERE
           LINK_PT_CRI.LPC_PT_ID = @PT_ID