*&---------------------------------------------------------------------*
*&  Include           Z_PCR_UPL_PCRN_RECDES_TOP
*&---------------------------------------------------------------------*

*Types
TYPES: BEGIN OF gty_itab,
         col1  TYPE char20,
         col2  TYPE char20,
         col3  TYPE char20,
         col4  TYPE char20,
         col5  TYPE char20,
         col6  TYPE char20,
         col7  TYPE char20,
         col8  TYPE char20,
         col9  TYPE char20,
         col10 TYPE char20,
         col11 TYPE char20,
         col12 TYPE char20,
       END OF gty_itab.

*Tabelas internas
DATA: gt_intern      TYPE TABLE OF alsmex_tabline,
      gt_itab        TYPE TABLE OF gty_itab.
