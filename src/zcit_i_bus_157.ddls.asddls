@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Root Interface View for Bus'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZCIT_I_BUS_157 
  as select from zcit_bhead_157 as BookingHeader
  composition [0..*] of ZCIT_I_SEAT_157 as _Seats
{
  key booking_id as BookingId,
  customer_name as CustomerName,
  journey_date as JourneyDate,
  source_loc as SourceLoc,
  dest_loc as DestLoc,
  @Semantics.amount.currencyCode: 'Currency'
  total_fare as TotalFare,
  currency as Currency,
  
  @Semantics.user.createdBy: true
  local_created_by as LocalCreatedBy,
  @Semantics.systemDateTime.createdAt: true
  local_created_at as LocalCreatedAt,
  @Semantics.user.lastChangedBy: true
  local_last_changed_by as LocalLastChangedBy,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  local_last_changed_at as LocalLastChangedAt,
  
  _Seats
}
