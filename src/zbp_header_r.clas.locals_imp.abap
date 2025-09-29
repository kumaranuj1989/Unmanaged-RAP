CLASS lhc_HeaderBD DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR HeaderBD RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR HeaderBD RESULT result.

    METHODS create FOR MODIFY
      IMPORTING entities FOR CREATE HeaderBD.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE HeaderBD.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE HeaderBD.

    METHODS read FOR READ
      IMPORTING keys FOR READ HeaderBD RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK HeaderBD.

    METHODS rba_Item_h FOR READ
      IMPORTING keys_rba FOR READ HeaderBD\_Item_h FULL result_requested RESULT result LINK association_links.

    METHODS rba_Subitem_h FOR READ
      IMPORTING keys_rba FOR READ HeaderBD\_Subitem_h FULL result_requested RESULT result LINK association_links.

    METHODS cba_Item_h FOR MODIFY
      IMPORTING entities_cba FOR CREATE HeaderBD\_Item_h.

    METHODS cba_Subitem_h FOR MODIFY
      IMPORTING entities_cba FOR CREATE HeaderBD\_Subitem_h.

ENDCLASS.

CLASS lhc_HeaderBD IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD get_global_authorizations.
  ENDMETHOD.
**********************************************************************
*Header Create
  METHOD create.
    ycl_crud_um=>factory(  )->header_create(
          EXPORTING
            entities = entities
          CHANGING
            mapped   = mapped
            failed   = failed
            reported = reported ).
  ENDMETHOD.
**********************************************************************
*Header Update
  METHOD update.
    ycl_crud_um=>factory(  )->header_update(
          EXPORTING
            entities = entities
          CHANGING
            mapped   = mapped
            failed   = failed
            reported = reported ).
  ENDMETHOD.
**********************************************************************
*Header Delete
  METHOD delete.
    ycl_crud_um=>factory(  )->header_delete(
      EXPORTING
        keys     = keys
      CHANGING
        mapped   = mapped
        failed   = failed
        reported = reported ).
  ENDMETHOD.
**********************************************************************
*Header Read
  METHOD read.
    ycl_crud_um=>factory(  )->header_read(
      EXPORTING
        keys     = keys
      CHANGING
        result   = result
        failed   = failed
        reported = reported ).
  ENDMETHOD.
**********************************************************************
*Header Lock
  METHOD lock.
  ENDMETHOD.
**********************************************************************
*Item Read w.r.t to header
  METHOD rba_Item_h.
  ENDMETHOD.
**********************************************************************
*Sub Item Read w.r.t to header
  METHOD rba_Subitem_h.
  ENDMETHOD.
**********************************************************************
*Item Create w.r.t to header
  METHOD cba_Item_h.
    ycl_crud_um=>factory(  )->item_create(
      EXPORTING
        entities_cba = entities_cba
      CHANGING
        mapped       = mapped
        failed       = failed
        reported     = reported ).
  ENDMETHOD.
**********************************************************************
*Sub Item Create w.r.t to header
  METHOD cba_Subitem_h.
  ENDMETHOD.

ENDCLASS.

CLASS lhc_ItemBD DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR ItemBD RESULT result.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE ItemBD.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE ItemBD.

    METHODS read FOR READ
      IMPORTING keys FOR READ ItemBD RESULT result.

    METHODS rba_Head_i FOR READ
      IMPORTING keys_rba FOR READ ItemBD\_Head_i FULL result_requested RESULT result LINK association_links.

    METHODS rba_Subitem_i FOR READ
      IMPORTING keys_rba FOR READ ItemBD\_Subitem_i FULL result_requested RESULT result LINK association_links.

    METHODS cba_Subitem_i FOR MODIFY
      IMPORTING entities_cba FOR CREATE ItemBD\_Subitem_i.

ENDCLASS.

CLASS lhc_ItemBD IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.
**********************************************************************
*Item Update
  METHOD update.
    ycl_crud_um=>factory(  )->item_update(
      EXPORTING
        item_entities = entities
      CHANGING
        mapped        = mapped
        failed        = failed
        reported      = reported ).
  ENDMETHOD.
**********************************************************************
*Item Delete
  METHOD delete.
    ycl_crud_um=>factory(  )->item_delete(
      EXPORTING
        item_keys = keys
      CHANGING
        mapped    = mapped
        failed    = failed
        reported  = reported ).
  ENDMETHOD.
**********************************************************************
*Item Read
  METHOD read.
    ycl_crud_um=>factory(  )->item_read(
      EXPORTING
        keys     = keys
      CHANGING
        result   = result
        failed   = failed
        reported = reported ).
  ENDMETHOD.
**********************************************************************
*Header read w.r.t Item
  METHOD rba_Head_i.
  ENDMETHOD.
**********************************************************************
*Sub Item read w.r.t Item
  METHOD rba_Subitem_i.
  ENDMETHOD.
**********************************************************************
*Sub Item Create w.r.t Item
  METHOD cba_Subitem_i.
  ENDMETHOD.

ENDCLASS.

CLASS lhc_SubItemBD DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE SubItemBD.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE SubItemBD.

    METHODS read FOR READ
      IMPORTING keys FOR READ SubItemBD RESULT result.

    METHODS rba_Head_s FOR READ
      IMPORTING keys_rba FOR READ SubItemBD\_Head_s FULL result_requested RESULT result LINK association_links.

ENDCLASS.

CLASS lhc_SubItemBD IMPLEMENTATION.
**********************************************************************
*Sub Item Update
  METHOD update.
  ENDMETHOD.
**********************************************************************
*Sub Item Delete
  METHOD delete.
  ENDMETHOD.
**********************************************************************
*Sub Item Read
  METHOD read.
  ENDMETHOD.
**********************************************************************
*Header read w.r.t Sub Item
  METHOD rba_Head_s.
  ENDMETHOD.

ENDCLASS.

CLASS lsc_YHEADER_R DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS adjust_numbers REDEFINITION.

    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_YHEADER_R IMPLEMENTATION.

  METHOD finalize.
  ENDMETHOD.

  METHOD check_before_save.
  ENDMETHOD.

  METHOD adjust_numbers.
  ENDMETHOD.

  METHOD save.
    ycl_crud_um=>factory(  )->save(
          CHANGING
            reported = reported ).
  ENDMETHOD.

  METHOD cleanup.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
