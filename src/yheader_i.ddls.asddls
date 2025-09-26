@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Header Interface'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity YHEADER_I
  as select from yheader_db
{
  key mblnr              as MaterialDocument,
  key mjahr              as DocumentYear,
      xblnr              as ReferenceDocument,
      lifnr              as Supplier,
      gmcode             as GoodsMovementCode,
      rplant             as ReceivingPlant,
      bktxt              as MaterialDocumentHeaderText,
      lastchangedat      as Lastchangedat,
      totallastchangedat as Totallastchangedat
}
