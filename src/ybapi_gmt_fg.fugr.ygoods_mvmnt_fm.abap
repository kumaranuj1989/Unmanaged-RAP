FUNCTION ygoods_mvmnt_fm.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(HEADER) TYPE  YHEADER_TT
*"     VALUE(ITEM) TYPE  YITEM_TT
*"  EXPORTING
*"     VALUE(MBLNR) TYPE  YMBLNR_DE
*"     VALUE(MJAHR) TYPE  YMJAHR_DE
*"     REFERENCE(RETURN) TYPE  YBAPIRET2
*"----------------------------------------------------------------------
  DATA lw_return LIKE LINE OF return.
  IF header IS INITIAL.
    IF item IS NOT INITIAL.
      DATA(lv_mblnr) = header[ 1 ]-mblnr.
      DATA(lv_mjahr) = item[ 1 ]-mjahr.
      SELECT * FROM YHEADER_DB  WHERE mblnr = @lv_mblnr AND mjahr = @lv_mjahr INTO TABLE @header.
    ELSE.
      lw_RETURN-type = 'E'.
      lw_return-message = 'Header data cannot be empty'.
      APPEND lw_return TO return.
    ENDIF.

  ENDIF.
  IF item IS INITIAL AND header IS INITIAL.
    lw_RETURN-type = 'E'.
    lw_return-message = 'Item data cannot be empty'.
    APPEND lw_return TO return.

  ENDIF.
  IF lines( header ) GT 1.
    lw_RETURN-type = 'E'.
    lw_return-message = 'Cannot post more that one document at once'.
    APPEND lw_return TO return.

  ENDIF.
  IF header[ 1 ]-bktxt IS INITIAL OR
     header[ 1 ]-gmcode IS INITIAL OR
     header[ 1 ]-lifnr IS INITIAL OR
    header[ 1 ]-rplant IS INITIAL OR
    header[ 1 ]-xblnr IS INITIAL.

    lw_RETURN-type = 'E'.
    lw_return-message = 'Incomplete Header Data'.
    APPEND lw_return TO return.

  ENDIF.
  IF item IS NOT INITIAL.
    LOOP AT item INTO DATA(lw_item).
      IF lw_item-bwart IS INITIAL OR

        lw_item-ebeln IS INITIAL OR
        lw_item-ebelp IS INITIAL OR
       lw_item-fkimg IS INITIAL OR
        lw_item-gmrdt IS INITIAL OR
        lw_item-grund IS INITIAL OR
        lw_item-lgort IS INITIAL OR
        lw_item-matnr IS INITIAL OR

        lw_item-splant IS INITIAL." OR
*      lw_item-meins IS INITIAL .

        lw_RETURN-type = 'E'.
        lw_return-message = 'Incomplete Item Data'.
        APPEND lw_return TO return.
      ENDIF.

      IF lw_item-bwart NE '101'.
        lw_RETURN-type = 'E'.
        lw_return-message = 'Only Movement Type 101 allowed'.
        APPEND lw_return TO return.
      ENDIF.
    ENDLOOP.

  ENDIF.
  IF header[ 1 ]-gmcode NE '01'.
    lw_return-message = 'Invalid Goods Movement Code'.
    APPEND lw_return TO return.
  ENDIF.


  CLEAR lw_return.
  READ TABLE return INTO lw_return WITH KEY type = 'E'.
  IF sy-subrc IS INITIAL.
    lw_RETURN-type = 'I'.
    lw_return-message = 'No Changes Made'.
    APPEND lw_return TO return.
  ELSE.
    DATA lv_mblnr_found TYPE Ymblnr_DE.

    lv_mblnr_found = VALUE #( header[ 1 ]-mblnr OPTIONAL ).
    IF lv_mblnr_found IS INITIAL.
      SELECT MAX( mblnr ) FROM YHEADER_DB INTO @DATA(v_mblnr).
      IF v_mblnr IS INITIAL.
        v_mblnr = '5000000000'.
      ELSE.
        v_mblnr = v_mblnr + 1.
      ENDIF.
      DATA(datum) = cl_abap_context_info=>get_system_date( ).
      DATA(v_mjahr) =  datum(4).
      header[ 1 ]-mblnr = v_mblnr.
      header[ 1 ]-mjahr = v_mjahr.

    ENDIF.
    mblnr = header[ 1 ]-mblnr.
    mjahr = header[ 1 ]-mjahr.

    MODIFY YHEADER_DB  FROM TABLE @header.
    IF item IS NOT INITIAL.
      SELECT MAX( zeile ) FROM YITEM_DB  WHERE mblnr EQ @mblnr AND mjahr EQ @mjahr INTO @DATA(v_zeile).
      LOOP AT item ASSIGNING FIELD-SYMBOL(<fs_item>).
        <fs_item>-mblnr = mblnr.
        <fs_item>-mjahr = mjahr.
        IF <fs_item>-zeile IS INITIAL.
          <fs_item>-zeile = v_zeile + 10.
          v_zeile = <fs_item>-zeile.
        ENDIF.
      ENDLOOP.
      MODIFY YITEM_DB FROM TABLE @item.
    ENDIF.
    lw_RETURN-type = 'S'.
    lw_return-message = 'Document ' && mblnr && ' Year ' && mjahr && ' Posted Successfully'.
    APPEND lw_return TO return.
    mblnr = v_mblnr.
    mjahr = v_mjahr.
  ENDIF.



ENDFUNCTION.
