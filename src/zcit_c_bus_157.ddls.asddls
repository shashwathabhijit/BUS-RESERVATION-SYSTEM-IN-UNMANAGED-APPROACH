@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Bus Booking Consumption View'
@Search.searchable: true
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity ZCIT_C_BUS_157 
  provider contract transactional_query
  as projection on ZCIT_I_BUS_157
{
  @Search.defaultSearchElement: true
  key BookingId,
  CustomerName,
  JourneyDate,
  SourceLoc,
  DestLoc,
  @Semantics.amount.currencyCode: 'Currency'
  TotalFare,
  Currency,
  LocalLastChangedAt,
  
  /* Associations */
  _Seats : redirected to composition child ZCIT_C_SEAT_157
}
