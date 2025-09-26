@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Item Projection'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity YITEM_C
  as projection on YITEM_R
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
      _HEAD_I : redirected to parent YHEADER_C
}
