@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'SubItem Projection'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity YSUBITEM_C
  as projection on YSUBITEM_R
{
  key MaterialDocument,
  key DocumentYear,
  key DocumentItem,
  key Serial,
      SerialDesc,
      Lastchangedat,
      Totallastchangedat,
      _ITEM_S : redirected to YITEM_C,
      _HEAD_S : redirected to parent YHEADER_C
}
