SET @ART_ID = 373681; -- EBERSPÄCHER 032025

    SELECT 
          ARTICLES.ART_ID,
          ARTICLES.ART_ARTICLE_NR,
          SENSITIVE_COORDINATES.SEN_COORD_ID,
          SENSITIVE_COORDINATES.SEN_COORD_X,
          SENSITIVE_COORDINATES.SEN_COORD_Y,
          SENSITIVE_COORDINATES.SEN_COORD_WIDTH,
          SENSITIVE_COORDINATES.SEN_COORD_HEIGHT,
          SENSITIVE_COORDINATES.SEN_COORD_TYPE
    FROM
          ART_PL_PIC_DATA
          INNER JOIN ARTICLES ON ARTICLES.ART_ID = ART_PL_PIC_DATA.APL_ART_ID_COMPONENT
        
          INNER JOIN SENSITIVE_COORDINATES ON SENSITIVE_COORDINATES.ART_PARENT_GRP_ID = ART_PL_PIC_DATA.APL_ART_ID
                AND SENSITIVE_COORDINATES.SEN_COORD_ID = ART_PL_PIC_DATA.SEN_COORD_ID
    WHERE
          ART_PL_PIC_DATA.APL_ART_ID = @ART_ID