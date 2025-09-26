FUNCTION ygoods_mvmnt_read_fm.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(MBLNR) TYPE  YMBLNR_TT OPTIONAL
*"     VALUE(MJAHR) TYPE  YMJAHR_TT OPTIONAL
*"  EXPORTING
*"     VALUE(HEADER) TYPE  YHEADER_TT
*"     VALUE(ITEM) TYPE  YITEM_TT
*"     REFERENCE(RETURN) TYPE  YBAPIRET2
*"----------------------------------------------------------------------
  DATA lw_return LIKE LINE OF return.

  SELECT * FROM yheader_db  WHERE mblnr IN @mblnr AND mjahr IN @mjahr INTO TABLE @header.
  IF sy-subrc IS NOT INITIAL.
    lw_RETURN-type = 'E'.
    lw_return-message = 'No records found'.
    APPEND lw_return TO return.
  ELSE.
    SELECT * FROM yitem_db  WHERE mblnr IN @mblnr AND mjahr IN @mjahr INTO TABLE @item.
  ENDIF.



ENDFUNCTION.
