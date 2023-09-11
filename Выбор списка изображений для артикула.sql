SET @ART_ID = 1830460; /* SPIDAN 20064 */ 
  

    SELECT 
          ART_MEDIA_INFO.ART_MEDIA_TYPE,
 /*-------------------------------------*/ 
          (CASE
               WHEN ART_MEDIA_INFO.ART_MEDIA_TYPE = 4
		  THEN ART_MEDIA_INFO.ART_MEDIA_HIPPERLINK 
               WHEN ART_MEDIA_INFO.ART_MEDIA_TYPE = 2
                  THEN CONCAT_WS('/', 'pdf', ART_MEDIA_INFO.ART_MEDIA_SUP_ID, ART_MEDIA_INFO.ART_MEDIA_FILE_NAME)
               ELSE
                  CONCAT_WS('/', 'img',  ART_MEDIA_INFO.ART_MEDIA_SUP_ID, ART_MEDIA_INFO.ART_MEDIA_FILE_NAME )
          END) AS ART_MEDIA_SOURCE,
 /*-------------------------------------*/ 
          ART_MEDIA_INFO.ART_MEDIA_SUP_ID,
          get_text(ART_MEDIA_INFO.ART_MEDIA_NORM, @LNGID) 
    FROM
          ART_MEDIA_INFO
    WHERE
          ART_MEDIA_INFO.ART_ID = @ART_ID