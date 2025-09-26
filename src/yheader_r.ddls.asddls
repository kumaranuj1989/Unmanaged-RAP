@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Header Composite'
@Metadata.ignorePropagatedAnnotations: true
define root view entity YHEADER_R
  as select from YHEADER_I
  composition [1..*] of YITEM_R    as _ITEM_H
  composition [1..*] of YSUBITEM_R as _SUBITEM_H
{
  key MaterialDocument,
  key DocumentYear,
      ReferenceDocument,
      Supplier,
      GoodsMovementCode,
      ReceivingPlant,
      MaterialDocumentHeaderText,
      Lastchangedat,
      Totallastchangedat,
      _ITEM_H,
      _SUBITEM_H
}
