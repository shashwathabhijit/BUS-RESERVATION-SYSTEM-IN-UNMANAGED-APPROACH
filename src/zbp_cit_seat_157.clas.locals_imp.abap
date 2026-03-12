*CLASS lhc_Seat DEFINITION INHERITING FROM cl_abap_behavior_handler.
*  PRIVATE SECTION.
*    METHODS update FOR MODIFY IMPORTING entities FOR UPDATE Seat.
*    METHODS delete FOR MODIFY IMPORTING keys FOR DELETE Seat.
*    METHODS read FOR READ IMPORTING keys FOR READ Seat RESULT result.
*    METHODS rba_Booking FOR READ IMPORTING keys_rba FOR READ Seat\_Booking FULL result_requested RESULT result LINK association_links.
*ENDCLASS.
*
*CLASS lhc_Seat IMPLEMENTATION.
*METHOD update.
*    DATA: ls_bitem TYPE zcit_bitem_157.
*    LOOP AT entities INTO DATA(ls_entities).
*      ls_bitem-booking_id     = ls_entities-BookingId.
*      ls_bitem-seat_number    = ls_entities-SeatNumber.
*      ls_bitem-passenger_name = ls_entities-PassengerName.
*      ls_bitem-seat_type      = ls_entities-SeatCategory.
*
*      " Keep these even if hidden in UI to prevent clearing out old data
*      ls_bitem-attachment     = ls_entities-Attachment.
*      ls_bitem-mimetype       = ls_entities-MimeType.
*      ls_bitem-filename       = ls_entities-FileName.
*
*      IF ls_bitem-booking_id IS NOT INITIAL AND ls_bitem-seat_number IS NOT INITIAL.
*        SELECT SINGLE * FROM zcit_bitem_157 WHERE booking_id = @ls_bitem-booking_id AND seat_number = @ls_bitem-seat_number INTO @DATA(ls_existing).
*        IF sy-subrc EQ 0.
*          " Send to buffer, BUT DO NOT fill the MAPPED structure on success!
*          DATA(lo_util) = zcl_cit_util_157=>get_instance( ).
*          lo_util->set_itm_value( EXPORTING im_bitem = ls_bitem IMPORTING ex_created = DATA(lv_created) ).
*        ELSE.
*          " Only fill FAILED if the record doesn't actually exist
*          APPEND VALUE #( BookingId = ls_entities-BookingId SeatNumber = ls_entities-SeatNumber ) TO failed-seat.
*        ENDIF.
*      ENDIF.
*    ENDLOOP.
*  ENDMETHOD.
*
*  METHOD delete.
*    DATA ls_bitem TYPE zcl_cit_util_157=>ty_bitem.
*    DATA(lo_util) = zcl_cit_util_157=>get_instance( ).
*    LOOP AT keys INTO DATA(ls_key).
*      CLEAR ls_bitem.
*      ls_bitem-booking_id = ls_key-BookingId.
*      ls_bitem-seat_number = ls_key-SeatNumber.
*      lo_util->set_itm_t_deletion( im_room = ls_bitem ).
*      APPEND VALUE #( BookingId = ls_key-BookingId SeatNumber = ls_key-SeatNumber ) TO mapped-seat.
*    ENDLOOP.
*  ENDMETHOD.
*
*  METHOD read.
*    LOOP AT keys INTO DATA(ls_key).
*      SELECT SINGLE * FROM zcit_bitem_157
*        WHERE booking_id = @ls_key-BookingId
*          AND seat_number = @ls_key-SeatNumber
*        INTO @DATA(ls_itm).
*
*      IF sy-subrc = 0.
*        DATA ls_result LIKE LINE OF result.
*        ls_result-BookingId     = ls_itm-booking_id.
*        ls_result-SeatNumber    = ls_itm-seat_number.
*        ls_result-PassengerName = ls_itm-passenger_name.
*        ls_result-SeatCategory  = ls_itm-seat_type.
*        ls_result-LocalLastChangedAt = ls_itm-local_last_changed_at.
*        APPEND ls_result TO result.
*      ENDIF.
*    ENDLOOP.
*  ENDMETHOD.
*  METHOD rba_Booking. ENDMETHOD.
*ENDCLASS.
CLASS lhc_Seat DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS update FOR MODIFY IMPORTING entities FOR UPDATE Seat.
    METHODS delete FOR MODIFY IMPORTING keys FOR DELETE Seat.
    METHODS read FOR READ IMPORTING keys FOR READ Seat RESULT result.
    METHODS rba_Booking FOR READ IMPORTING keys_rba FOR READ Seat\_Booking FULL result_requested RESULT result LINK association_links.
ENDCLASS.

CLASS lhc_Seat IMPLEMENTATION.
  METHOD update.
    DATA: ls_bitem TYPE zcit_bitem_157.
    LOOP AT entities INTO DATA(ls_entities).
      ls_bitem-booking_id     = ls_entities-BookingId.
      ls_bitem-seat_number    = ls_entities-SeatNumber.
      ls_bitem-passenger_name = ls_entities-PassengerName.
      ls_bitem-seat_type      = ls_entities-SeatCategory.

      IF ls_bitem-booking_id IS NOT INITIAL AND ls_bitem-seat_number IS NOT INITIAL.
        SELECT SINGLE * FROM zcit_bitem_157 WHERE booking_id = @ls_bitem-booking_id AND seat_number = @ls_bitem-seat_number INTO @DATA(ls_existing).
        IF sy-subrc EQ 0.
          DATA(lo_util) = zcl_cit_util_157=>get_instance( ).
          lo_util->set_itm_value( EXPORTING im_bitem = ls_bitem IMPORTING ex_created = DATA(lv_created) ).
        ELSE.
          APPEND VALUE #( BookingId = ls_entities-BookingId SeatNumber = ls_entities-SeatNumber ) TO failed-seat.
        ENDIF.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD delete.
    DATA ls_bitem TYPE zcl_cit_util_157=>ty_bitem.
    DATA(lo_util) = zcl_cit_util_157=>get_instance( ).
    LOOP AT keys INTO DATA(ls_key).
      CLEAR ls_bitem.
      ls_bitem-booking_id = ls_key-BookingId.
      ls_bitem-seat_number = ls_key-SeatNumber.
      lo_util->set_itm_t_deletion( im_room = ls_bitem ).
    ENDLOOP.
  ENDMETHOD.

  METHOD read.
    LOOP AT keys INTO DATA(ls_key).
      SELECT SINGLE * FROM zcit_bitem_157
        WHERE booking_id = @ls_key-BookingId
          AND seat_number = @ls_key-SeatNumber
        INTO @DATA(ls_itm).
      IF sy-subrc = 0.
        INSERT CORRESPONDING #( ls_itm MAPPING TO ENTITY ) INTO TABLE result.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD rba_Booking. ENDMETHOD.
ENDCLASS.
