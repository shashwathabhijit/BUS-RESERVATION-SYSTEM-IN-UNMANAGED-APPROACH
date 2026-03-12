//@AccessControl.authorizationCheck: #NOT_REQUIRED
//@EndUserText.label: 'Child Interface View for Seats'
//@Metadata.ignorePropagatedAnnotations: true
//define view entity ZCIT_I_SEAT_157 
//  as select from zcit_bitem_157
//  association to parent ZCIT_I_BUS_157 as _Booking 
//    on $projection.BookingId = _Booking.BookingId
//{
//  key booking_id as BookingId,
//  key seat_number as SeatNumber,
//  passenger_name as PassengerName,
//  seat_type as SeatCategory,  /* Preemptive Alias fix to avoid EDM clash */
//  
//  @Semantics.largeObject: { mimeType: 'MimeType', fileName: 'FileName', contentDispositionPreference: #INLINE }
//  attachment as Attachment,
//  @Semantics.mimeType: true
//  mimetype as MimeType,
//  filename as FileName,
//
//  @Semantics.systemDateTime.localInstanceLastChangedAt: true
//  local_last_changed_at as LocalLastChangedAt,
//  
//  _Booking
//}
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Child Interface View for Seats'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZCIT_I_SEAT_157 
  as select from zcit_bitem_157
  association to parent ZCIT_I_BUS_157 as _Booking 
    on $projection.BookingId = _Booking.BookingId
{
  key booking_id as BookingId,
  key seat_number as SeatNumber,
  passenger_name as PassengerName,
  seat_type as SeatCategory,
  
  /* FILE UPLOAD SEMANTICS REMOVED */
  attachment as Attachment,
  mimetype as MimeType,
  filename as FileName,

  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  local_last_changed_at as LocalLastChangedAt,
  
  _Booking
}
