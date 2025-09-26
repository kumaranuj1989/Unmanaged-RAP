@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Item Composite'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity YITEM_R
  as select from YITEM_I
  association to parent YHEADER_R as _HEAD_I on  $projection.MaterialDocument = _HEAD_I.MaterialDocument
                                             and $projection.DocumentYear     = _HEAD_I.DocumentYear
{
  key MaterialDocument,
  key DocumentYear,
  key DocumentItem,
      Material,
      Plant,
      StorageLocation,
      GoodsMovementType,
      PurchaseOrder,
      PurchaseOrderItem,
      GoodsMovementRefDocType,
      GoodsMovementReasonCode,
      @Semantics.quantity.unitOfMeasure: 'EntryUnit'
      QuantityInEntryUnit,
      EntryUnit,
      IsCompletelyDelivered,
      Lastchangedat,
      Totallastchangedat,
      _HEAD_I
}
