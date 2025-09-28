@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Header Projection'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity YHEADER_C
  provider contract transactional_query
  as projection on YHEADER_R
{
      @EndUserText.label: 'Material Document'
  key MaterialDocument,
      @EndUserText.label: 'Document Year'
  key DocumentYear,
      ReferenceDocument,
      Supplier,
      GoodsMovementCode,
      ReceivingPlant,
      MaterialDocumentHeaderText,
      Lastchangedat,
      Totallastchangedat,
      _ITEM_H    : redirected to composition child YITEM_C,
      _SUBITEM_H : redirected to composition child YSUBITEM_C
}
