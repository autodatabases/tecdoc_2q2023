SET @PC_ID = 12423;
    SET @STR_TYPE=7; /* universal product selection */

    SELECT DISTINCT
         SEARCH_TREE.STR_LEVEL,
/* ------------------------------------------- */        
         ELT(SEARCH_TREE.STR_LEVEL, 
             get_text(SEARCH_TREE.STR_DES_ID , @LNGID),
             get_text(PARENT_NODE1.STR_DES_ID , @LNGID),  
             get_text(PARENT_NODE2.STR_DES_ID , @LNGID), 
             get_text(PARENT_NODE3.STR_DES_ID , @LNGID) ) AS ROOT_NODE_TEXT,

          ELT(SEARCH_TREE.STR_LEVEL, 
              SEARCH_TREE.STR_ID, 
              PARENT_NODE1.STR_ID, 
              PARENT_NODE2.STR_ID, 
              PARENT_NODE3.STR_ID) AS ROOT_NODE_STR_ID,
/* ------------------------------------------- */            
          ELT(SEARCH_TREE.STR_LEVEL-1, 
              get_text(SEARCH_TREE.STR_DES_ID , @LNGID),
              get_text(PARENT_NODE1.STR_DES_ID , @LNGID),  
              get_text(PARENT_NODE2.STR_DES_ID , @LNGID), 
              get_text(PARENT_NODE3.STR_DES_ID , @LNGID) ) AS NODE_1_TEXT,

          ELT(SEARCH_TREE.STR_LEVEL-1, 
              SEARCH_TREE.STR_ID, 
              PARENT_NODE1.STR_ID, 
              PARENT_NODE2.STR_ID, 
              PARENT_NODE3.STR_ID) AS NODE_1_STR_ID, 
/* ------------------------------------------- */            
          ELT(SEARCH_TREE.STR_LEVEL-2, 
              get_text(SEARCH_TREE.STR_DES_ID , @LNGID),
              get_text(PARENT_NODE1.STR_DES_ID , @LNGID),  
              get_text(PARENT_NODE2.STR_DES_ID , @LNGID), 
              get_text(PARENT_NODE3.STR_DES_ID , @LNGID)) AS NODE_2_TEXT,

          ELT(SEARCH_TREE.STR_LEVEL-2, 
              SEARCH_TREE.STR_ID, 
              PARENT_NODE1.STR_ID, 
              PARENT_NODE2.STR_ID, 
              PARENT_NODE3.STR_ID) AS NODE_2_STR_ID, 
/* ------------------------------------------- */            
          ELT(SEARCH_TREE.STR_LEVEL-3, 
              get_text(SEARCH_TREE.STR_DES_ID , @LNGID),
              get_text(PARENT_NODE1.STR_DES_ID , @LNGID),  
              get_text(PARENT_NODE2.STR_DES_ID , @LNGID), 
              get_text(PARENT_NODE3.STR_DES_ID , @LNGID) ) AS NODE_3_TEXT,

          ELT(SEARCH_TREE.STR_LEVEL-3, 
              SEARCH_TREE.STR_ID, 
              PARENT_NODE1.STR_ID, 
              PARENT_NODE2.STR_ID, 
              PARENT_NODE3.STR_ID) AS NODE_3_STR_ID
/* ------------------------------------------- */         
    FROM
        STR_LOOKUP
        
        INNER JOIN LINK_PT_STR ON LINK_PT_STR.PT_ID = STR_LOOKUP.STL_PT_ID
         
        INNER JOIN SEARCH_TREE ON SEARCH_TREE.STR_ID = LINK_PT_STR.STR_ID 
              AND SEARCH_TREE.STR_TYPE = @STR_TYPE
              
        LEFT JOIN SEARCH_TREE AS PARENT_NODE1 ON PARENT_NODE1.STR_ID = SEARCH_TREE.STR_ID_PARENT 
              AND PARENT_NODE1.STR_TYPE = @STR_TYPE
              
        LEFT JOIN SEARCH_TREE AS PARENT_NODE2 ON PARENT_NODE2.STR_ID = PARENT_NODE1.STR_ID_PARENT 
              AND PARENT_NODE2.STR_TYPE = @STR_TYPE
               
        LEFT JOIN SEARCH_TREE AS PARENT_NODE3 ON PARENT_NODE3.STR_ID = PARENT_NODE2.STR_ID_PARENT
              AND PARENT_NODE3.STR_TYPE = @STR_TYPE
               
    WHERE
        STR_LOOKUP.STL_SEARCH_TEXT LIKE '%VALVE'