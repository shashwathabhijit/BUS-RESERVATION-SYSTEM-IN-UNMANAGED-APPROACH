@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Seat Item Consumption View'
@Search.searchable: true
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity ZCIT_C_SEAT_157 
  as projection on ZCIT_I_SEAT_157
{
  key BookingId,
  key SeatNumber,
  @Search.defaultSearchElement: true
  PassengerName,
  SeatCategory,
  Attachment,
  MimeType,
  FileName,
  LocalLastChangedAt,
  
  /* Associations */
  _Booking : redirected to parent ZCIT_C_BUS_157
}
