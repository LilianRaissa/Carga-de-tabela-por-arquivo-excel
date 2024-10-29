*&---------------------------------------------------------------------*
*& Report  Z_PCR_UPL_PCRN_RECDES
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT Z_PCR_UPL_PCRN_RECDES.

INCLUDE z_pcr_upl_pcrn_recdes_top.
INCLUDE z_pcr_upl_pcrn_recdes_scr.
INCLUDE z_pcr_upl_pcrn_recdes_f01.

START-OF-SELECTION.

CLEAR: gt_intern, gt_itab.

PERFORM: f_upload_arq,
         f_trata_arq,
         f_grava_tabela.
