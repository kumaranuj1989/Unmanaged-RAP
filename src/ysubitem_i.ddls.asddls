@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'SubItem Interface'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity YSUBITEM_I
  as select from ysubitem_db
{
  key mblnr              as MaterialDocument,
  key mjahr              as DocumentYear,
  key zeile              as DocumentItem,
  key serial             as Serial,
      serial_desc        as SerialDesc,
      lastchangedat      as Lastchangedat,
      totallastchangedat as Totallastchangedat
}
