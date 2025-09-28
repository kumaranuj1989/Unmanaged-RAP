@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'SubItem Composite'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity YSUBITEM_R
  as select from YSUBITEM_I
  association        to parent YHEADER_R as _HEAD_S on  $projection.MaterialDocument = _HEAD_S.MaterialDocument
                                                    and $projection.DocumentYear     = _HEAD_S.DocumentYear
  association [0..1] to YITEM_R          as _ITEM_S on  $projection.MaterialDocument = _ITEM_S.MaterialDocument
                                                    and $projection.DocumentYear     = _ITEM_S.DocumentYear
                                                    and $projection.DocumentItem     = _ITEM_S.DocumentItem
{
  key MaterialDocument,
  key DocumentYear,
  key DocumentItem,
  key Serial,
      SerialDesc,
      Lastchangedat,
      Totallastchangedat,
      _HEAD_S,
      _ITEM_S
}
