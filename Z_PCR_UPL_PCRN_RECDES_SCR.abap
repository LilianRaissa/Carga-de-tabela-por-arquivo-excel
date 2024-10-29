*&---------------------------------------------------------------------*
*&  Include           Z_PCR_UPL_PCRN_RECDES_SCR
*&---------------------------------------------------------------------*
**********************************************************************
*                          SELECTION SCREEN                          *
**********************************************************************

SELECTION-SCREEN BEGIN OF BLOCK 001 WITH FRAME TITLE text-001.
  PARAMETERS: p_row TYPE i OBLIGATORY.
SELECTION-SCREEN END OF BLOCK 001.

SELECTION-SCREEN BEGIN OF BLOCK 002 WITH FRAME TITLE text-002.
  PARAMETERS: p_arq TYPE rlgrap-filename OBLIGATORY.
SELECTION-SCREEN END OF BLOCK 002.

**********************************************************************
*                         AT SELECTION SCREEN                        *
**********************************************************************

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_arq.
  PERFORM f_seleciona_arq.
