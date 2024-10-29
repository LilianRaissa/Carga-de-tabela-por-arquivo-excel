*&---------------------------------------------------------------------*
*&  Include           Z_PCR_UPL_PCRN_RECDES_F01
*&---------------------------------------------------------------------*

*--------------------------------------------------------------------*
*                        FORM f_seleciona_arq                        *
*--------------------------------------------------------------------*
FORM f_seleciona_arq.

  CALL FUNCTION 'F4_FILENAME'
    EXPORTING
      program_name        = syst-cprog
      dynpro_number       = syst-dynnr
      field_name          = 'p_arq'
    IMPORTING
      file_name           = p_arq.

ENDFORM.

*--------------------------------------------------------------------*
*                         FORM f_upload_arq                          *
*--------------------------------------------------------------------*
FORM f_upload_arq.

  CALL FUNCTION 'ALSM_EXCEL_TO_INTERNAL_TABLE'
    EXPORTING
      filename                      = p_arq
      i_begin_col                   = 1
      i_begin_row                   = 2
      i_end_col                     = 12
      i_end_row                     = p_row
    TABLES
      intern                        = gt_intern
    EXCEPTIONS
      inconsistent_parameters       = 1
      upload_ole                    = 2
      OTHERS                        = 3.

ENDFORM.

*--------------------------------------------------------------------*
*                          FORM f_trata_arq                          *
*--------------------------------------------------------------------*
FORM f_trata_arq.

  DATA: ls_intern TYPE alsmex_tabline,
        ls_itab   TYPE gty_itab.

  FIELD-SYMBOLS: <lfs_value> TYPE any.

  LOOP AT gt_intern INTO ls_intern.

    ASSIGN COMPONENT ls_intern-col OF STRUCTURE ls_itab TO <lfs_value>.

    <lfs_value> = ls_intern-value.

    AT END OF row. " row her degistiginde burasý calýsacak.
      APPEND ls_itab TO gt_itab.
    ENDAT.

  ENDLOOP.

ENDFORM.

*--------------------------------------------------------------------*
*                         FORM f_grava_tabela                        *
*--------------------------------------------------------------------*
FORM f_grava_tabela.

  DATA: lt_pcrn_recdes TYPE TABLE OF z_pcrn_recdes.

  DATA: ls_recdes TYPE z_pcrn_recdes.

  DATA: lv_char TYPE c LENGTH 23,
        lv_dec  TYPE p DECIMALS 2.

  FIELD-SYMBOLS: <fs_itab> LIKE LINE OF gt_itab.

  LOOP AT gt_itab ASSIGNING <fs_itab>.

    ls_recdes-mandt        = sy-mandt.
    ls_recdes-apurid       = <fs_itab>-col1.
    ls_recdes-bukrs        = <fs_itab>-col2.
    ls_recdes-branch       = <fs_itab>-col3.
    ls_recdes-gjahr        = <fs_itab>-col4.
    ls_recdes-nivel        = <fs_itab>-col5.
    ls_recdes-id_conta_pcr = <fs_itab>-col6.
    ls_recdes-descr        = <fs_itab>-col7.

    "Converte de char para decimal - Saldo inicial
    CLEAR lv_dec.
    PERFORM f_conv_char_p_dec USING <fs_itab>-col8
                              CHANGING lv_dec.
    ls_recdes-saldo_ini = lv_dec.

    "Converte de char para decimal - Debitos
    CLEAR lv_dec.
    PERFORM f_conv_char_p_dec USING <fs_itab>-col9
                              CHANGING lv_dec.
    ls_recdes-debitos = lv_dec.

    "Converte de char para decimal - Creditos
    CLEAR lv_dec.
    PERFORM f_conv_char_p_dec USING <fs_itab>-col10
                              CHANGING lv_dec.
    ls_recdes-creditos = lv_dec.

    "Converte de char para decimal - Saldo no Período
    CLEAR lv_dec.
    PERFORM f_conv_char_p_dec USING <fs_itab>-col11
                              CHANGING lv_dec.
    ls_recdes-saldo_per = lv_dec.

    "Converte de char para decimal - Saldo Acumulado
    CLEAR lv_dec.
    PERFORM f_conv_char_p_dec USING <fs_itab>-col12
                              CHANGING lv_dec.
    ls_recdes-saldo_acum = lv_dec.

    "Grava linhas na tabela interna
    APPEND ls_recdes TO lt_pcrn_recdes.

  ENDLOOP.

  IF lt_pcrn_recdes IS NOT INITIAL.

    MODIFY z_pcrn_recdes FROM TABLE lt_pcrn_recdes.

    IF sy-subrc IS INITIAL.
      MESSAGE 'Dados gravados com sucesso' TYPE 'S'.
    ELSE.
      MESSAGE 'Erro ao gravar os dados' TYPE 'E'.
    ENDIF.

  ENDIF.

ENDFORM.

*--------------------------------------------------------------------*
*                       FORM f_conv_char_p_dec                       *
*--------------------------------------------------------------------*
FORM f_conv_char_p_dec USING    f_char
                       CHANGING f_dec.

  DATA: lv_sinal TYPE c.

  lv_sinal = f_char.

  REPLACE ALL OCCURRENCES OF SUBSTRING '.' IN f_char WITH ''.
  REPLACE ALL OCCURRENCES OF SUBSTRING ',' IN f_char WITH '.'.
  REPLACE ALL OCCURRENCES OF SUBSTRING '-' IN f_char WITH ''.

  f_dec = f_char.

  IF lv_sinal = '-'.
    f_dec = - f_dec.
  ENDIF.

ENDFORM.
