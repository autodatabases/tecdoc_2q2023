 SET @STR_ID = 100470; /* /Engine/Lubrication/Oil Filter */
    SET @PC_ID = 9877; 
    SET @STR_TYPE=1;  /* passenger cars */
    SET @LINK_TYPE= 2;  /* passenger cars */

 
    SELECT DISTINCT
           SUPPLIERS.SUP_BRAND,
           SUPPLIERS.SUP_ID,
           get_text(PRODUCTS.PT_DES_ID, @LNGID) AS "PRODUCT GROUP",
           PRODUCTS.PT_ID
    FROM 
           SEARCH_TREE
           INNER JOIN LINK_PT_STR ON LINK_PT_STR.STR_ID = @STR_ID 
                 AND LINK_PT_STR.STR_TYPE = @STR_TYPE 
		
           INNER JOIN LINK_LA_TYP ON LINK_LA_TYP.LAT_TYP_ID = @PC_ID 
                 AND LINK_LA_TYP.LAT_TYPE = @LINK_TYPE 
                 AND LINK_LA_TYP.LAT_PT_ID = LINK_PT_STR.PT_ID
     
           INNER JOIN LINK_ART ON LINK_ART.LA_ID = LINK_LA_TYP.LAT_LA_ID
            
           INNER JOIN ARTICLES ON ARTICLES.ART_ID = LINK_ART.LA_ART_ID

           INNER JOIN SUPPLIERS ON SUPPLIERS.SUP_ID = LINK_LA_TYP.LAT_SUP_ID
           INNER JOIN PRODUCTS ON PRODUCTS.PT_ID = LINK_LA_TYP.LAT_PT_ID
    WHERE
           SEARCH_TREE.STR_ID = @STR_ID 
            AND SEARCH_TREE.STR_TYPE = @STR_TYPE  
    ORDER BY SUP_BRAND