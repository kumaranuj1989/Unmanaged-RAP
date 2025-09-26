@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Item Interface'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity YITEM_I
  as select from yitem_db
{
  key mblnr              as MaterialDocument,
  key mjahr              as DocumentYear,
  key zeile              as DocumentItem,
      matnr              as Material,
      splant             as Plant,
      lgort              as StorageLocation,
      bwart              as GoodsMovementType,
      ebeln              as PurchaseOrder,
      ebelp              as PurchaseOrderItem,
      gmrdt              as GoodsMovementRefDocType,
      grund              as GoodsMovementReasonCode,
      @Semantics.quantity.unitOfMeasure: 'EntryUnit'
      fkimg              as QuantityInEntryUnit,
      meins              as EntryUnit,
      delv_inc           as IsCompletelyDelivered,
      lastchangedat      as Lastchangedat,
      totallastchangedat as Totallastchangedat
}
