CLASS ycl_crud_um DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
**********************************************************************
*  Type Declaration
**********************************************************************
    TYPES:
      tt_early_mapped           TYPE RESPONSE FOR MAPPED EARLY   yheader_r,     "Mapped
      tt_early_failed           TYPE RESPONSE FOR FAILED EARLY   yheader_r,     "Failed
      tt_early_reported         TYPE RESPONSE FOR REPORTED EARLY yheader_r,     "Reported
      tt_late_mapped            TYPE RESPONSE FOR MAPPED LATE    yheader_r,
      tt_late_reported          TYPE RESPONSE FOR REPORTED LATE  yheader_r,
      tt_header_create_entities TYPE TABLE FOR CREATE            yheader_r\\headerbd,
      tt_update_create_entities TYPE TABLE FOR UPDATE            yheader_r\\headerbd,
      tt_header_delete_keys     TYPE TABLE FOR DELETE            yheader_r\\headerbd,
      tt_header_read_keys       TYPE TABLE FOR READ IMPORT       yheader_r\\headerbd,
      tt_header_read_result     TYPE TABLE FOR READ RESULT       yheader_r\\headerbd,
      tt_header_lock_keys       TYPE TABLE FOR KEY OF            yheader_r\\headerbd,
      tt_item_create_entities   TYPE TABLE FOR CREATE            yheader_r\\headerbd\_item_h,
      tt_update_item_entities   TYPE TABLE FOR UPDATE            yheader_r\\itembd,
      tt_item_read_keys         TYPE TABLE FOR READ IMPORT       yheader_r\\itembd,
      tt_item_read_result       TYPE TABLE FOR READ RESULT       yheader_r\\itembd,
      tt_delete_item_keys       TYPE TABLE FOR DELETE            yheader_r\\itembd.

**********************************************************************
*   Method Declaration
**********************************************************************
    CLASS-METHODS factory RETURNING VALUE(ro_api) TYPE REF TO ycl_crud_um.

    METHODS:Header_Create
      IMPORTING entities TYPE tt_header_create_entities
      CHANGING  mapped   TYPE tt_early_mapped
                failed   TYPE tt_early_failed
                reported TYPE tt_early_reported.

    METHODS:Header_update
      IMPORTING entities TYPE tt_update_create_entities
      CHANGING  mapped   TYPE tt_early_mapped
                failed   TYPE tt_early_failed
                reported TYPE tt_early_reported.

    METHODS:Header_delete
      IMPORTING keys     TYPE tt_header_delete_keys
      CHANGING  mapped   TYPE tt_early_mapped
                failed   TYPE tt_early_failed
                reported TYPE tt_early_reported.

    METHODS:Header_read
      IMPORTING keys     TYPE tt_header_read_keys
      CHANGING  result   TYPE tt_header_read_result
                failed   TYPE tt_early_failed
                reported TYPE tt_early_reported.

    METHODS:header_lock
      IMPORTING keys     TYPE tt_header_lock_keys
      CHANGING  failed   TYPE tt_early_failed
                reported TYPE tt_early_reported.

    METHODS: item_create
      IMPORTING entities_cba TYPE tt_item_create_entities
      CHANGING  mapped       TYPE tt_early_mapped
                failed       TYPE tt_early_failed
                reported     TYPE tt_early_reported.

    METHODS: item_update
      IMPORTING item_entities TYPE tt_update_item_entities
      CHANGING  mapped        TYPE tt_early_mapped
                failed        TYPE tt_early_failed
                reported      TYPE tt_early_reported.

    METHODS : item_read
      IMPORTING keys     TYPE tt_item_read_keys
      CHANGING  result   TYPE tt_item_read_result
                failed   TYPE tt_early_failed
                reported TYPE tt_early_reported.

    METHODS: item_delete
      IMPORTING item_keys TYPE tt_delete_item_keys
      CHANGING  mapped    TYPE tt_early_mapped
                failed    TYPE tt_early_failed
                reported  TYPE tt_early_reported.

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
**********************************************************************
  METHOD factory.     "Create Instance of the class

    lo_api = ro_api = COND #( WHEN lo_api IS BOUND THEN lo_api
                              ELSE NEW #(  ) ).
  ENDMETHOD.
**********************************************************************
  METHOD header_create.        "Header Create
    gt_header = CORRESPONDING #( entities MAPPING mblnr  = MaterialDocument
                                                  mjahr  = DocumentYear
                                                  gmcode = GoodsMovementCode
                                                  bktxt  = MaterialDocumentHeaderText
                                                  rplant = ReceivingPlant
                                                  xblnr  = ReferenceDocument
                                                  lifnr  = Supplier  ).

    gt_header = CORRESPONDING #( entities MAPPING FROM ENTITY ).
    IF gt_header IS NOT INITIAL.
      GET TIME STAMP FIELD DATA(ts).
      gt_header[ 1 ]-lastchangedat = ts.
      gt_header[ 1 ]-totallastchangedat = ts.
    ENDIF.
  ENDMETHOD.
**********************************************************************
  METHOD header_update.        "Header Update
    READ ENTITIES OF yheader_r
    ENTITY HeaderBD
    ALL FIELDS WITH VALUE #( ( %tky-MaterialDocument = entities[ 1 ]-MaterialDocument
                               %tky-DocumentYear     = entities[ 1 ]-DocumentYear ) )
    RESULT DATA(lt_result1).

    READ ENTITIES OF yheader_r
    ENTITY HeaderBD
    ALL FIELDS WITH VALUE #( ( %tky = entities[ 1 ]-%tky ) )
    RESULT DATA(lt_result2).

    gt_header = CORRESPONDING #( lt_result2 MAPPING FROM ENTITY ).
    IF gt_header IS NOT INITIAL.
      GET TIME STAMP FIELD DATA(ts).

      LOOP AT entities ASSIGNING FIELD-SYMBOL(<lfs_entities>).
        ASSIGN gt_header[ mblnr = <lfs_entities>-MaterialDocument mjahr = <lfs_entities>-DocumentYear ] TO FIELD-SYMBOL(<lfs_header>).
        IF <lfs_header> IS ASSIGNED.
          IF <lfs_entities>-%control-GoodsMovementCode = if_abap_behv=>mk-on.
            <lfs_header>-gmcode = <lfs_entities>-GoodsMovementCode.
          ENDIF.
          IF <lfs_entities>-%control-MaterialDocumentHeaderText = if_abap_behv=>mk-on.
            <lfs_header>-bktxt = <lfs_entities>-MaterialDocumentHeaderText.
          ENDIF.
          IF <lfs_entities>-%control-ReceivingPlant = if_abap_behv=>mk-on.
            <lfs_header>-rplant = <lfs_entities>-ReceivingPlant.
          ENDIF.
          IF <lfs_entities>-%control-ReferenceDocument = if_abap_behv=>mk-on.
            <lfs_header>-xblnr = <lfs_entities>-ReferenceDocument.
          ENDIF.
          IF <lfs_entities>-%control-Supplier = if_abap_behv=>mk-on.
            <lfs_header>-lifnr = <lfs_entities>-Supplier.
          ENDIF.
          <lfs_header>-lastchangedat = ts.
          <lfs_header>-totallastchangedat = ts.
        ENDIF.
      ENDLOOP.
    ENDIF.
  ENDMETHOD.
**********************************************************************
  METHOD header_delete.        "Header Delete
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

    READ ENTITIES OF yheader_r
    ENTITY ItemBD
    ALL FIELDS WITH VALUE #( ( %tky = keys[ 1 ]-%tky ) )
    RESULT DATA(lt_result7).

    gt_ditem = CORRESPONDING #( lt_result7 MAPPING FROM ENTITY ).

    SELECT * FROM yheader_db
    FOR ALL ENTRIES IN @keys
    WHERE mblnr = @keys-MaterialDocument AND
          mjahr = @keys-DocumentYear
    INTO TABLE @gt_dheader.
  ENDMETHOD.
**********************************************************************
  METHOD header_read.          "Header Read
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
**********************************************************************
  METHOD header_lock.          "Header Lock

  ENDMETHOD.
**********************************************************************
  METHOD item_create.       "Item Create By Association w.r.t Header
    READ ENTITIES OF yheader_r
      ENTITY HeaderBD
      ALL FIELDS WITH VALUE #( FOR ls_entities_cba IN entities_cba ( %tky = ls_entities_cba-%tky ) )
      RESULT DATA(lt_result).
    IF lt_result IS NOT INITIAL.
      gt_header = CORRESPONDING #( lt_result MAPPING FROM ENTITY ).
    ENDIF.

    gt_item = CORRESPONDING #( entities_cba[ 1 ]-%target MAPPING mblnr = MaterialDocument
                                                                 mjahr = DocumentYear
                                                                 zeile = DocumentItem
                                                                 grund = GoodsMovementReasonCode
                                                                 gmrdt = GoodsMovementRefDocType
                                                                 bwart = GoodsMovementType
                                                                 matnr = Material
                                                                 splant = Plant
                                                                 ebeln = PurchaseOrder
                                                                 ebelp = PurchaseOrderItem
                                                                 delv_inc = IsCompletelyDelivered
                                                                 fkimg = QuantityInEntryUnit
                                                                 meins = EntryUnit
                                                                 lgort = StorageLocation ).
    IF gt_item IS NOT INITIAL.
      GET TIME STAMP FIELD DATA(ts).
      gt_item[ 1 ]-lastchangedat = ts.
      gt_item[ 1 ]-totallastchangedat = ts.
    ENDIF.
  ENDMETHOD.
**********************************************************************
  METHOD item_update.    "Item Update
    READ ENTITIES OF yheader_r
    ENTITY HeaderBD
    ALL FIELDS WITH VALUE #( ( %tky-MaterialDocument = item_entities[ 1 ]-MaterialDocument
                               %tky-DocumentYear     = item_entities[ 1 ]-DocumentYear ) )
    RESULT DATA(lt_result1).
    IF lt_result1 IS NOT INITIAL.
      gt_header = CORRESPONDING #( lt_result1 MAPPING FROM ENTITY ).
    ENDIF.

    READ ENTITIES OF yheader_r
    ENTITY ItemBD
    ALL FIELDS WITH VALUE #( ( %tky = item_entities[ 1 ]-%tky ) )
    RESULT DATA(lt_result2).

    gt_item = CORRESPONDING #( lt_result2 MAPPING FROM ENTITY ).
    IF gt_item IS NOT INITIAL.
      GET TIME STAMP FIELD DATA(ts).

      LOOP AT item_entities ASSIGNING FIELD-SYMBOL(<lfs_item_entities>).
        ASSIGN gt_item[ mblnr = <lfs_item_entities>-MaterialDocument mjahr = <lfs_item_entities>-DocumentYear zeile = <lfs_item_entities>-DocumentItem ] TO FIELD-SYMBOL(<lfs_item>).
        IF <lfs_item> IS ASSIGNED.
          IF <lfs_item_entities>-%control-GoodsMovementReasonCode = if_abap_behv=>mk-on.
            <lfs_item>-grund = <lfs_item_entities>-GoodsMovementReasonCode.
          ENDIF.
          IF <lfs_item_entities>-%control-GoodsMovementRefDocType = if_abap_behv=>mk-on.
            <lfs_item>-gmrdt = <lfs_item_entities>-GoodsMovementRefDocType.
          ENDIF.
          IF <lfs_item_entities>-%control-GoodsMovementType = if_abap_behv=>mk-on.
            <lfs_item>-bwart = <lfs_item_entities>-GoodsMovementType.
          ENDIF.
          IF <lfs_item_entities>-%control-Material = if_abap_behv=>mk-on.
            <lfs_item>-matnr = <lfs_item_entities>-Material.
          ENDIF.
          IF <lfs_item_entities>-%control-Plant = if_abap_behv=>mk-on.
            <lfs_item>-splant = <lfs_item_entities>-Plant.
          ENDIF.
          IF <lfs_item_entities>-%control-PurchaseOrder = if_abap_behv=>mk-on.
            <lfs_item>-ebeln = <lfs_item_entities>-PurchaseOrder.
          ENDIF.
          IF <lfs_item_entities>-%control-PurchaseOrderItem = if_abap_behv=>mk-on.
            <lfs_item>-ebelp = <lfs_item_entities>-PurchaseOrderItem.
          ENDIF.
          IF <lfs_item_entities>-%control-IsCompletelyDelivered = if_abap_behv=>mk-on.
            <lfs_item>-delv_inc = <lfs_item_entities>-IsCompletelyDelivered.
          ENDIF.
          IF <lfs_item_entities>-%control-QuantityInEntryUnit = if_abap_behv=>mk-on.
            <lfs_item>-fkimg = <lfs_item_entities>-QuantityInEntryUnit.
          ENDIF.
          IF <lfs_item_entities>-%control-EntryUnit = if_abap_behv=>mk-on.
            <lfs_item>-meins = <lfs_item_entities>-EntryUnit.
          ENDIF.
          IF <lfs_item_entities>-%control-StorageLocation = if_abap_behv=>mk-on.
            <lfs_item>-lgort = <lfs_item_entities>-StorageLocation.
          ENDIF.
          <lfs_item>-lastchangedat = ts.
          <lfs_item>-totallastchangedat = ts.
        ENDIF.
      ENDLOOP.
    ENDIF.

  ENDMETHOD.
**********************************************************************
  METHOD item_read.        "Item Read
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
            item   = lt_item
            return = lt_return.
      ENDIF.

      IF line_exists( lt_return[ type = 'E' ] ).
        APPEND VALUE #( %tky = keys[ 1 ]-%tky ) TO failed-itembd.
      ELSE.
        IF keys[ 1 ]-DocumentItem NE space.
          DELETE lt_item WHERE zeile NE keys[ 1 ]-DocumentItem.
        ENDIF.
        result = CORRESPONDING #( lt_item MAPPING MaterialDocument        = mblnr
                                                  DocumentYear            = mjahr
                                                  DocumentItem            = zeile
                                                  GoodsMovementReasonCode = grund
                                                  GoodsMovementRefDocType = gmrdt
                                                  GoodsMovementType       = bwart
                                                  Material                = matnr
                                                  Plant                   = splant
                                                  PurchaseOrder           = ebeln
                                                  PurchaseOrderItem       = ebelp
                                                  IsCompletelyDelivered   = delv_inc
                                                  QuantityInEntryUnit     = fkimg
                                                  EntryUnit               = meins
                                                  StorageLocation         = lgort ).

        result = CORRESPONDING #( lt_item MAPPING TO ENTITY ).

      ENDIF.
    ENDIF.
  ENDMETHOD.
**********************************************************************
  METHOD item_delete.           "Item Delete
    READ ENTITIES OF yheader_r
    ENTITY ItemBD
    ALL FIELDS WITH VALUE #( FOR ls_item_keys IN item_keys ( %tky = ls_item_keys-%tky ) )
    RESULT DATA(lt_result).

    gt_ditem = CORRESPONDING #( lt_result MAPPING FROM ENTITY ).
  ENDMETHOD.

**********************************************************************
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
*      Display Message
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
        DELETE yitem_db FROM TABLE @gt_ditem.
        IF sy-subrc IS INITIAL.
          DATA(lv_msg) = lcl_message=>get_instance( )->message( severity = if_abap_behv_message=>severity-success
                                                                text     = 'Record deleted Successfully' ).
          APPEND lv_msg TO reported-%other.
        ENDIF.
      ENDIF.
    ELSEIF gt_ditem IS NOT INITIAL.
      DELETE yitem_db FROM TABLE @gt_ditem.
      IF sy-subrc IS INITIAL.
        lv_msg = lcl_message=>get_instance( )->message( severity = if_abap_behv_message=>severity-success
                                                              text     = 'Record deleted Successfully' ).
        APPEND lv_msg TO reported-%other.
      ENDIF.
    ENDIF.
  ENDMETHOD.

ENDCLASS.
