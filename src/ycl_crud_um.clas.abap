CLASS ycl_crud_um DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
**********************************************************************
*  Type Declaration
**********************************************************************
    TYPES:
      tt_early_mapped    TYPE RESPONSE FOR MAPPED EARLY   yheader_r,     "Mapped
      tt_early_failed    TYPE RESPONSE FOR FAILED EARLY   yheader_r,     "Failed
      tt_early_reported  TYPE RESPONSE FOR REPORTED EARLY yheader_r,     "Reported
      tt_late_mapped     TYPE RESPONSE FOR MAPPED LATE    yheader_r,
      tt_late_reported   TYPE RESPONSE FOR REPORTED LATE  yheader_r,
      tt_create_entities TYPE TABLE FOR CREATE            yheader_r,
      tt_update_entities TYPE TABLE FOR UPDATE            yheader_r,
      tt_delete_keys     TYPE TABLE FOR DELETE            yheader_r,
      tt_read_keys       TYPE TABLE FOR READ IMPORT       yheader_r,
      tt_read_result     TYPE TABLE FOR READ RESULT       yheader_r,
      tt_lock_keys       TYPE TABLE FOR KEY OF            yheader_r.


**********************************************************************
*   Method Declaration
**********************************************************************
    CLASS-METHODS factory RETURNING VALUE(ro_api) TYPE REF TO ycl_crud_um.

    METHODS:Create
      IMPORTING entities TYPE tt_create_entities
      CHANGING  mapped   TYPE tt_early_mapped
                failed   TYPE tt_early_failed
                reported TYPE tt_early_reported.

    METHODS:update
      IMPORTING entities TYPE tt_update_entities
      CHANGING  mapped   TYPE tt_early_mapped
                failed   TYPE tt_early_failed
                reported TYPE tt_early_reported.

    METHODS:delete
      IMPORTING keys     TYPE tt_delete_keys
      CHANGING  mapped   TYPE tt_early_mapped
                failed   TYPE tt_early_failed
                reported TYPE tt_early_reported.

    METHODS:read
      IMPORTING keys     TYPE tt_read_keys
      CHANGING  result   TYPE tt_read_result
                failed   TYPE tt_early_failed
                reported TYPE tt_early_reported.

    METHODS:lock
      IMPORTING keys     TYPE tt_lock_keys
      CHANGING  failed   TYPE tt_early_failed
                reported TYPE tt_early_reported.

    METHODS:adjust_numbers
      CHANGING mapped   TYPE tt_late_mapped
               reported TYPE tt_late_reported.

    METHODS:save
      CHANGING reported TYPE tt_late_reported.

  PROTECTED SECTION.
  PRIVATE SECTION.
**********************************************************************
*   Data Declaration
**********************************************************************
    CLASS-DATA :
      lo_api      TYPE REF TO   ycl_crud_um,
      gt_header   TYPE TABLE OF yheader_db,
      gt_item     TYPE TABLE OF yitem_db,
      gt_subitem  TYPE TABLE OF ysubitem_db,
      gt_dheader  TYPE TABLE OF yheader_db,
      gt_ditem    TYPE TABLE OF yitem_db,
      gt_dsubitem TYPE TABLE OF ysubitem_db.
ENDCLASS.



CLASS ycl_crud_um IMPLEMENTATION.
  METHOD factory.     "Create Instance of the class

    lo_api = ro_api = COND #( WHEN lo_api IS BOUND THEN lo_api
                              ELSE NEW #(  ) ).
  ENDMETHOD.

  METHOD create.        "Header Create
    gt_header = CORRESPONDING #( entities MAPPING mblnr  = MaterialDocument
                                                  mjahr  = DocumentYear
                                                  gmcode = GoodsMovementCode
                                                  bktxt  = MaterialDocumentHeaderText
                                                  rplant = ReceivingPlant
                                                  xblnr  = ReferenceDocument
                                                  lifnr  = Supplier  ).
    IF gt_header IS NOT INITIAL.
      GET TIME STAMP FIELD DATA(ts).
      gt_header[ 1 ]-lastchangedat = ts.
      gt_header[ 1 ]-totallastchangedat = ts.
    ENDIF.
  ENDMETHOD.

  METHOD update.        "Header Update

  ENDMETHOD.

  METHOD delete.        "Header Delete
    "When Multiple entries are available in Keys
    READ ENTITIES OF yheader_r
    ENTITY HeaderBD
    ALL FIELDS WITH VALUE #( FOR ls_keys IN keys ( MaterialDocument = ls_keys-MaterialDocument
                                                   DocumentYear     = ls_keys-DocumentYear ) )
    RESULT DATA(lt_result1).

    READ ENTITIES OF yheader_r
    ENTITY HeaderBD
    ALL FIELDS WITH VALUE #( FOR ls_keys IN keys ( %tky-MaterialDocument = ls_keys-MaterialDocument
                                                   %tky-DocumentYear     = ls_keys-DocumentYear ) )
    RESULT DATA(lt_result2).

    READ ENTITIES OF yheader_r
    ENTITY HeaderBD
    ALL FIELDS WITH VALUE #( FOR ls_keys IN keys ( %tky = ls_keys-%tky ) )
    RESULT DATA(lt_result3).

    "When single entry is available in Keys
    READ ENTITIES OF yheader_r
    ENTITY HeaderBD
    ALL FIELDS WITH VALUE #( ( %tky-MaterialDocument = keys[ 1 ]-MaterialDocument
                               %tky-DocumentYear     = keys[ 1 ]-DocumentYear ) )
    RESULT DATA(lt_result4).

    READ ENTITIES OF yheader_r
    ENTITY HeaderBD
    ALL FIELDS WITH VALUE #( ( MaterialDocument = keys[ 1 ]-MaterialDocument
                               DocumentYear     = keys[ 1 ]-DocumentYear ) )
    RESULT DATA(lt_result5).

    READ ENTITIES OF yheader_r
    ENTITY HeaderBD
    ALL FIELDS WITH VALUE #( ( %tky = keys[ 1 ]-%tky ) )
    RESULT DATA(lt_result6).


    SELECT * FROM yheader_db
    FOR ALL ENTRIES IN @keys
    WHERE mblnr = @keys-MaterialDocument AND
          mjahr = @keys-DocumentYear
    INTO TABLE @gt_dheader.
  ENDMETHOD.

  METHOD read.          "Header Read
    IF keys IS NOT INITIAL.
      DATA : lt_header TYPE yheader_tt,
             lt_item   TYPE yitem_tt,
             lr_mblnr  TYPE ymblnr_tt,
             lr_mjahr  TYPE ymjahr_tt,
             lt_return TYPE ybapiret2.

      LOOP AT keys ASSIGNING FIELD-SYMBOL(<lfs_key>).
        APPEND VALUE #( sign = 'I' opti = 'EQ' low = <lfs_key>-MaterialDocument ) TO lr_mblnr.
        APPEND VALUE #( sign = 'I' opti = 'EQ' low = <lfs_key>-DocumentYear )     TO lr_mjahr.
      ENDLOOP.

      IF lr_mblnr IS NOT INITIAL AND
         lr_mjahr IS NOT INITIAL.
        CALL FUNCTION 'YGOODS_MVMNT_READ_FM'
          EXPORTING
            mblnr  = lr_mblnr
            mjahr  = lr_mjahr
          IMPORTING
            header = lt_header
            item   = lt_item
            return = lt_return.
      ENDIF.

      IF line_exists( lt_return[ type = 'E' ] ).
        APPEND VALUE #( %tky = keys[ 1 ]-%tky ) TO failed-headerbd.
      ELSE.
        result = CORRESPONDING #( lt_header MAPPING MaterialDocument           = mblnr
                                                    DocumentYear               = mjahr
                                                    GoodsMovementCode          = gmcode
                                                    MaterialDocumentHeaderText = bktxt
                                                    ReceivingPlant             = rplant
                                                    ReferenceDocument          = xblnr
                                                    Supplier                   = lifnr ).
      ENDIF.
    ENDIF.
  ENDMETHOD.

  METHOD lock.          "Header Lock

  ENDMETHOD.

  METHOD adjust_numbers.        "Adjust Numbers Saver
    IF mapped IS NOT INITIAL.

    ENDIF.
  ENDMETHOD.

  METHOD save.                  "Save Saver
    DATA :
      mblnr  TYPE ymblnr_de,
      mjahr  TYPE ymjahr_de,
      return TYPE ybapiret2.
    IF gt_header  IS NOT INITIAL.
      CALL FUNCTION 'YGOODS_MVMNT_FM'
        EXPORTING
          header = gt_header
          item   = gt_item
        IMPORTING
          mblnr  = mblnr
          mjahr  = mjahr
          return = return.


      APPEND VALUE #( materialdocument = mblnr
                      documentyear     = mjahr
                      %msg             = lcl_message=>get_instance( )->message( severity = COND #( WHEN return[ 1 ]-type EQ 'E'
                                                                                                   THEN if_abap_behv_message=>severity-error
                                                                                                   ELSE if_abap_behv_message=>severity-success )
                                                                                text     = return[ 1 ]-message )
                      ) TO reported-headerbd.
    ENDIF.

    IF gt_dheader IS NOT INITIAL.
      DELETE yheader_db FROM TABLE @gt_dheader.
      IF sy-subrc IS INITIAL.
        DATA(lv_msg) = lcl_message=>get_instance( )->message( severity = if_abap_behv_message=>severity-success
                                                              text     = 'Record deleted Successfully' ).
        APPEND lv_msg TO reported-%other.
      ENDIF.
    ENDIF.
  ENDMETHOD.



ENDCLASS.
