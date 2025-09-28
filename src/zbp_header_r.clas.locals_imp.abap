CLASS lhc_YHEADER_R DEFINITION INHERITING FROM cl_abap_behavior_handler.
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
    METHODS rba_item FOR READ
      IMPORTING keys_rba FOR READ HeaderBD\_item_h FULL result_requested RESULT result LINK association_links.

    METHODS cba_item FOR MODIFY
      IMPORTING entities_cba FOR CREATE HeaderBD\_item_h.

ENDCLASS.

CLASS lhc_YHEADER_R IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD create.
    ycl_crud_um=>factory(  )->create(
        EXPORTING
          entities = entities
        CHANGING
          mapped   = mapped
          failed   = failed
          reported = reported ).
  ENDMETHOD.

  METHOD update.
    ycl_crud_um=>factory(  )->update(
          EXPORTING
            entities = entities
          CHANGING
            mapped   = mapped
            failed   = failed
            reported = reported ).
  ENDMETHOD.

  METHOD delete.
    ycl_crud_um=>factory(  )->delete(
          EXPORTING
            keys     = keys
          CHANGING
            mapped   = mapped
            failed   = failed
            reported = reported ).
  ENDMETHOD.

  METHOD read.
    ycl_crud_um=>factory(  )->read(
       EXPORTING
         keys     = keys
       CHANGING
         failed   = failed
         reported = reported
         result   = result ).
  ENDMETHOD.

  METHOD lock.
    ycl_crud_um=>factory(  )->lock(
        EXPORTING
          keys     = keys
        CHANGING
          failed   = failed
          reported = reported ).
  ENDMETHOD.

  METHOD rba_Item.

  ENDMETHOD.

  METHOD cba_Item.
    ycl_crud_um=>factory(  )->cba_item(
      EXPORTING
        entities_cba = entities_cba
      CHANGING
        mapped       = mapped
        failed       = failed
        reported     = reported ).
  ENDMETHOD.

ENDCLASS.

CLASS lhc_itembd DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE ItemBD.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE ItemBD.

    METHODS read FOR READ
      IMPORTING keys FOR READ ItemBD RESULT result.

    METHODS rba_Head FOR READ
      IMPORTING keys_rba FOR READ ItemBD\_head_i FULL result_requested RESULT result LINK association_links.

ENDCLASS.

CLASS lhc_itembd IMPLEMENTATION.

  METHOD update.
    ycl_crud_um=>factory(  )->item_update(
      EXPORTING
        item_entities = entities
      CHANGING
        mapped   = mapped
        failed   = failed
        reported = reported ).
  ENDMETHOD.

  METHOD delete.
   ycl_crud_um=>factory(  )->item_delete(
     EXPORTING
       item_keys = keys
     CHANGING
       mapped    = mapped
       failed    = failed
       reported  = reported ).
  ENDMETHOD.

  METHOD read.
    ycl_crud_um=>factory(  )->item_read(
      EXPORTING
        keys     = keys
      CHANGING
        result   = result
        failed   = failed
        reported = reported ).
  ENDMETHOD.

  METHOD rba_Head.
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
    ycl_crud_um=>factory(  )->adjust_numbers(
        CHANGING
          mapped   = mapped
          reported = reported ).
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
