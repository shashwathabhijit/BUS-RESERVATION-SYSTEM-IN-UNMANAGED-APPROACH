*CLASS lhc_Booking DEFINITION INHERITING FROM cl_abap_behavior_handler.
*  PRIVATE SECTION.
*    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION IMPORTING keys REQUEST requested_authorizations FOR Booking RESULT result.
*    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION IMPORTING REQUEST requested_authorizations FOR Booking RESULT result.
*    METHODS create FOR MODIFY IMPORTING entities FOR CREATE Booking.
*    METHODS update FOR MODIFY IMPORTING entities FOR UPDATE Booking.
*    METHODS delete FOR MODIFY IMPORTING keys FOR DELETE Booking.
*    METHODS read FOR READ IMPORTING keys FOR READ Booking RESULT result.
*    METHODS lock FOR LOCK IMPORTING keys FOR LOCK Booking.
*    METHODS rba_Seats FOR READ IMPORTING keys_rba FOR READ Booking\_Seats FULL result_requested RESULT result LINK association_links.
*    METHODS cba_Seats FOR MODIFY IMPORTING entities_cba FOR CREATE Booking\_Seats.
*ENDCLASS.
*
*CLASS lhc_Booking IMPLEMENTATION.
*  METHOD get_instance_authorizations. ENDMETHOD.
*  METHOD get_global_authorizations. ENDMETHOD.
*  METHOD lock. ENDMETHOD.
*
*  METHOD create.
*    DATA: ls_bhead TYPE zcit_bhead_157.
*    LOOP AT entities INTO DATA(ls_entities).
*      ls_bhead-client         = sy-mandt.
*      ls_bhead-booking_id     = ls_entities-BookingId.
*      ls_bhead-customer_name  = ls_entities-CustomerName.
*      ls_bhead-journey_date   = ls_entities-JourneyDate.
*      ls_bhead-source_loc     = ls_entities-SourceLoc.
*      ls_bhead-dest_loc       = ls_entities-DestLoc.
*      ls_bhead-total_fare     = ls_entities-TotalFare.
*      ls_bhead-currency       = ls_entities-Currency.
*
*      IF ls_bhead-booking_id IS NOT INITIAL.
*        SELECT SINGLE * FROM zcit_bhead_157 WHERE booking_id = @ls_bhead-booking_id INTO @DATA(ls_existing).
*        IF sy-subrc NE 0.
*          DATA(lo_util) = zcl_cit_util_157=>get_instance( ).
*          lo_util->set_hdr_value( EXPORTING im_bhead = ls_bhead IMPORTING ex_created = DATA(lv_created) ).
*          IF lv_created EQ abap_true.
*            APPEND VALUE #( %cid = ls_entities-%cid BookingId = ls_entities-BookingId ) TO mapped-booking.
*          ENDIF.
*        ELSE.
*          APPEND VALUE #( %cid = ls_entities-%cid BookingId = ls_entities-BookingId ) TO failed-booking.
*        ENDIF.
*      ENDIF.
*    ENDLOOP.
*  ENDMETHOD.
*
*  METHOD update.
*    DATA: ls_bhead TYPE zcit_bhead_157.
*    LOOP AT entities INTO DATA(ls_entities).
*      ls_bhead-booking_id     = ls_entities-BookingId.
*      ls_bhead-customer_name  = ls_entities-CustomerName.
*      ls_bhead-journey_date   = ls_entities-JourneyDate.
*      ls_bhead-source_loc     = ls_entities-SourceLoc.
*      ls_bhead-dest_loc       = ls_entities-DestLoc.
*      ls_bhead-total_fare     = ls_entities-TotalFare.
*      ls_bhead-currency       = ls_entities-Currency.
*
*      IF ls_bhead-booking_id IS NOT INITIAL.
*        SELECT SINGLE * FROM zcit_bhead_157 WHERE booking_id = @ls_bhead-booking_id INTO @DATA(ls_existing).
*        IF sy-subrc EQ 0.
*          " Send to buffer, BUT DO NOT fill the MAPPED structure on success!
*          DATA(lo_util) = zcl_cit_util_157=>get_instance( ).
*          lo_util->set_hdr_value( EXPORTING im_bhead = ls_bhead IMPORTING ex_created = DATA(lv_created) ).
*        ELSE.
*          " Only fill FAILED if the record doesn't actually exist
*          APPEND VALUE #( BookingId = ls_entities-BookingId ) TO failed-booking.
*        ENDIF.
*      ENDIF.
*    ENDLOOP.
*  ENDMETHOD.
*
*  METHOD delete.
*    DATA ls_bhead TYPE zcl_cit_util_157=>ty_bhead.
*    DATA(lo_util) = zcl_cit_util_157=>get_instance( ).
*    LOOP AT keys INTO DATA(ls_key).
*      CLEAR ls_bhead.
*      ls_bhead-booking_id = ls_key-BookingId.
*      lo_util->set_hdr_t_deletion( EXPORTING im_booking = ls_bhead ).
*      lo_util->set_hdr_deletion_flag( EXPORTING im_delete = abap_true ).
*      APPEND VALUE #( BookingId = ls_key-BookingId ) TO mapped-booking.
*    ENDLOOP.
*  ENDMETHOD.
*
* METHOD read.
*    LOOP AT keys INTO DATA(ls_key).
*      SELECT SINGLE * FROM zcit_bhead_157 WHERE booking_id = @ls_key-BookingId INTO @DATA(ls_hdr).
*      IF sy-subrc = 0.
*        " Explicitly map the database fields to the UI fields
*        DATA ls_result LIKE LINE OF result.
*        ls_result-BookingId     = ls_hdr-booking_id.
*        ls_result-CustomerName  = ls_hdr-customer_name.
*        ls_result-JourneyDate   = ls_hdr-journey_date.
*        ls_result-SourceLoc     = ls_hdr-source_loc.
*        ls_result-DestLoc       = ls_hdr-dest_loc.
*        ls_result-TotalFare     = ls_hdr-total_fare.
*        ls_result-Currency      = ls_hdr-currency.
*        ls_result-LocalLastChangedAt = ls_hdr-local_last_changed_at.
*        APPEND ls_result TO result.
*      ENDIF.
*    ENDLOOP.
*  ENDMETHOD.
*
*  METHOD rba_Seats.
*    LOOP AT keys_rba INTO DATA(ls_key).
*      SELECT * FROM zcit_bitem_157 WHERE booking_id = @ls_key-BookingId INTO TABLE @DATA(lt_items).
*      LOOP AT lt_items INTO DATA(ls_item).
*        " Explicitly map the item fields
*        DATA ls_result LIKE LINE OF result.
*        ls_result-BookingId     = ls_item-booking_id.
*        ls_result-SeatNumber    = ls_item-seat_number.
*        ls_result-PassengerName = ls_item-passenger_name.
*        ls_result-SeatCategory  = ls_item-seat_type.
*        APPEND ls_result TO result.
*
*        APPEND VALUE #( source-BookingId = ls_key-BookingId
*                        target-BookingId = ls_item-booking_id
*                        target-SeatNumber = ls_item-seat_number ) TO association_links.
*      ENDLOOP.
*    ENDLOOP.
*  ENDMETHOD.
*
*  METHOD cba_Seats.
*    DATA ls_bitem TYPE zcit_bitem_157.
*    LOOP AT entities_cba INTO DATA(ls_entities_cba).
*      LOOP AT ls_entities_cba-%target INTO DATA(ls_target).
*        ls_bitem-client         = sy-mandt.
*        ls_bitem-booking_id     = ls_target-BookingId.
*        ls_bitem-seat_number    = ls_target-SeatNumber.
*        ls_bitem-passenger_name = ls_target-PassengerName.
*        ls_bitem-seat_type      = ls_target-SeatCategory.
*        ls_bitem-attachment     = ls_target-Attachment.
*        ls_bitem-mimetype       = ls_target-MimeType.
*        ls_bitem-filename       = ls_target-FileName.
*
*        IF ls_bitem-booking_id IS NOT INITIAL AND ls_bitem-seat_number IS NOT INITIAL.
*          SELECT SINGLE * FROM zcit_bitem_157 WHERE booking_id = @ls_bitem-booking_id AND seat_number = @ls_bitem-seat_number INTO @DATA(ls_existing).
*          IF sy-subrc NE 0.
*            DATA(lo_util) = zcl_cit_util_157=>get_instance( ).
*            lo_util->set_itm_value( EXPORTING im_bitem = ls_bitem IMPORTING ex_created = DATA(lv_created) ).
*            IF lv_created EQ abap_true.
*              APPEND VALUE #( %cid = ls_target-%cid BookingId = ls_target-BookingId SeatNumber = ls_target-SeatNumber ) TO mapped-seat.
*            ENDIF.
*          ELSE.
*            APPEND VALUE #( %cid = ls_target-%cid BookingId = ls_target-BookingId SeatNumber = ls_target-SeatNumber ) TO failed-seat.
*          ENDIF.
*        ENDIF.
*      ENDLOOP.
*    ENDLOOP.
*  ENDMETHOD.
*ENDCLASS.
*
*CLASS lsc_ZCIT_I_BUS_157 DEFINITION INHERITING FROM cl_abap_behavior_saver.
*  PROTECTED SECTION.
*    METHODS finalize REDEFINITION.
*    METHODS check_before_save REDEFINITION.
*    METHODS save REDEFINITION.
*    METHODS cleanup REDEFINITION.
*    METHODS cleanup_finalize REDEFINITION.
*ENDCLASS.
*
*CLASS lsc_ZCIT_I_BUS_157 IMPLEMENTATION.
*  METHOD finalize. ENDMETHOD.
*  METHOD check_before_save. ENDMETHOD.
*  METHOD cleanup_finalize. ENDMETHOD.
*
*  METHOD save.
*    DATA(lo_util) = zcl_cit_util_157=>get_instance( ).
*    lo_util->get_hdr_value( IMPORTING ex_bhead = DATA(ls_bhead) ).
*    lo_util->get_itm_value( IMPORTING ex_bitem = DATA(ls_bitem) ).
*    lo_util->get_hdr_t_deletion( IMPORTING ex_bookings = DATA(lt_del_header) ).
*    lo_util->get_itm_t_deletion( IMPORTING ex_rooms = DATA(lt_del_items) ).
*    lo_util->get_deletion_flags( IMPORTING ex_hdr_del = DATA(lv_hdr_del) ).
*
*    IF ls_bhead IS NOT INITIAL. MODIFY zcit_bhead_157 FROM @ls_bhead. ENDIF.
*    IF ls_bitem IS NOT INITIAL. MODIFY zcit_bitem_157 FROM @ls_bitem. ENDIF.
*
*    IF lv_hdr_del = abap_true.
*      LOOP AT lt_del_header INTO DATA(ls_del_hdr).
*        DELETE FROM zcit_bhead_157 WHERE booking_id = @ls_del_hdr-booking_id.
*        DELETE FROM zcit_bitem_157 WHERE booking_id = @ls_del_hdr-booking_id.
*      ENDLOOP.
*    ELSE.
*      LOOP AT lt_del_header INTO ls_del_hdr. DELETE FROM zcit_bhead_157 WHERE booking_id = @ls_del_hdr-booking_id. ENDLOOP.
*      LOOP AT lt_del_items INTO DATA(ls_del_itm). DELETE FROM zcit_bitem_157 WHERE booking_id = @ls_del_itm-booking_id AND seat_number = @ls_del_itm-seat_number. ENDLOOP.
*    ENDIF.
*  ENDMETHOD.
*
*  METHOD cleanup. zcl_cit_util_157=>get_instance( )->cleanup_buffer( ). ENDMETHOD.
*ENDCLASS.
CLASS lhc_Booking DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION IMPORTING keys REQUEST requested_authorizations FOR Booking RESULT result.
    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION IMPORTING REQUEST requested_authorizations FOR Booking RESULT result.
    METHODS create FOR MODIFY IMPORTING entities FOR CREATE Booking.
    METHODS update FOR MODIFY IMPORTING entities FOR UPDATE Booking.
    METHODS delete FOR MODIFY IMPORTING keys FOR DELETE Booking.
    METHODS read FOR READ IMPORTING keys FOR READ Booking RESULT result.
    METHODS lock FOR LOCK IMPORTING keys FOR LOCK Booking.
    METHODS rba_Seats FOR READ IMPORTING keys_rba FOR READ Booking\_Seats FULL result_requested RESULT result LINK association_links.
    METHODS cba_Seats FOR MODIFY IMPORTING entities_cba FOR CREATE Booking\_Seats.
ENDCLASS.

CLASS lhc_Booking IMPLEMENTATION.
  METHOD get_instance_authorizations. ENDMETHOD.
  METHOD get_global_authorizations. ENDMETHOD.
  METHOD lock. ENDMETHOD.

  METHOD create.
    DATA: ls_bhead TYPE zcit_bhead_157.
    LOOP AT entities INTO DATA(ls_entities).
      ls_bhead-client         = sy-mandt.
      ls_bhead-booking_id     = ls_entities-BookingId.
      ls_bhead-customer_name  = ls_entities-CustomerName.
      ls_bhead-journey_date   = ls_entities-JourneyDate.
      ls_bhead-source_loc     = ls_entities-SourceLoc.
      ls_bhead-dest_loc       = ls_entities-DestLoc.
      ls_bhead-total_fare     = ls_entities-TotalFare.
      ls_bhead-currency       = ls_entities-Currency.

      IF ls_bhead-booking_id IS NOT INITIAL.
        SELECT SINGLE * FROM zcit_bhead_157 WHERE booking_id = @ls_bhead-booking_id INTO @DATA(ls_existing).
        IF sy-subrc NE 0.
          DATA(lo_util) = zcl_cit_util_157=>get_instance( ).
          lo_util->set_hdr_value( EXPORTING im_bhead = ls_bhead IMPORTING ex_created = DATA(lv_created) ).
          IF lv_created EQ abap_true.
            " CRITICAL FIX: Only map if %cid is actually provided
            IF ls_entities-%cid IS NOT INITIAL.
              APPEND VALUE #( %cid = ls_entities-%cid BookingId = ls_entities-BookingId ) TO mapped-booking.
            ENDIF.
          ENDIF.
        ELSE.
          IF ls_entities-%cid IS NOT INITIAL.
            APPEND VALUE #( %cid = ls_entities-%cid BookingId = ls_entities-BookingId ) TO failed-booking.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD update.
    DATA: ls_bhead TYPE zcit_bhead_157.
    LOOP AT entities INTO DATA(ls_entities).
      ls_bhead-booking_id     = ls_entities-BookingId.
      ls_bhead-customer_name  = ls_entities-CustomerName.
      ls_bhead-journey_date   = ls_entities-JourneyDate.
      ls_bhead-source_loc     = ls_entities-SourceLoc.
      ls_bhead-dest_loc       = ls_entities-DestLoc.
      ls_bhead-total_fare     = ls_entities-TotalFare.
      ls_bhead-currency       = ls_entities-Currency.

      IF ls_bhead-booking_id IS NOT INITIAL.
        SELECT SINGLE * FROM zcit_bhead_157 WHERE booking_id = @ls_bhead-booking_id INTO @DATA(ls_existing).
        IF sy-subrc EQ 0.
          DATA(lo_util) = zcl_cit_util_157=>get_instance( ).
          lo_util->set_hdr_value( EXPORTING im_bhead = ls_bhead IMPORTING ex_created = DATA(lv_created) ).
        ELSE.
          APPEND VALUE #( BookingId = ls_entities-BookingId ) TO failed-booking.
        ENDIF.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD delete.
    DATA ls_bhead TYPE zcl_cit_util_157=>ty_bhead.
    DATA(lo_util) = zcl_cit_util_157=>get_instance( ).
    LOOP AT keys INTO DATA(ls_key).
      CLEAR ls_bhead.
      ls_bhead-booking_id = ls_key-BookingId.
      lo_util->set_hdr_t_deletion( EXPORTING im_booking = ls_bhead ).
      lo_util->set_hdr_deletion_flag( EXPORTING im_delete = abap_true ).
    ENDLOOP.
  ENDMETHOD.

  METHOD read.
    LOOP AT keys INTO DATA(ls_key).
      SELECT SINGLE * FROM zcit_bhead_157 WHERE booking_id = @ls_key-BookingId INTO @DATA(ls_hdr).
      IF sy-subrc = 0.
        " MAPPING TO ENTITY safely handles %tky to prevent Fiori crashes
        INSERT CORRESPONDING #( ls_hdr MAPPING TO ENTITY ) INTO TABLE result.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD rba_Seats.
    LOOP AT keys_rba INTO DATA(ls_key).
      SELECT * FROM zcit_bitem_157 WHERE booking_id = @ls_key-BookingId INTO TABLE @DATA(lt_items).
      LOOP AT lt_items INTO DATA(ls_item).
        INSERT CORRESPONDING #( ls_item MAPPING TO ENTITY ) INTO TABLE result.
        APPEND VALUE #( source-BookingId = ls_key-BookingId
                        target-BookingId = ls_item-booking_id
                        target-SeatNumber = ls_item-seat_number ) TO association_links.
      ENDLOOP.
    ENDLOOP.
  ENDMETHOD.

  METHOD cba_Seats.
    DATA ls_bitem TYPE zcit_bitem_157.
    LOOP AT entities_cba INTO DATA(ls_entities_cba).
      LOOP AT ls_entities_cba-%target INTO DATA(ls_target).
        ls_bitem-client         = sy-mandt.
        ls_bitem-booking_id     = ls_target-BookingId.
        ls_bitem-seat_number    = ls_target-SeatNumber.
        ls_bitem-passenger_name = ls_target-PassengerName.
        ls_bitem-seat_type      = ls_target-SeatCategory.

        IF ls_bitem-booking_id IS NOT INITIAL AND ls_bitem-seat_number IS NOT INITIAL.
          SELECT SINGLE * FROM zcit_bitem_157 WHERE booking_id = @ls_bitem-booking_id AND seat_number = @ls_bitem-seat_number INTO @DATA(ls_existing).
          IF sy-subrc NE 0.
            DATA(lo_util) = zcl_cit_util_157=>get_instance( ).
            lo_util->set_itm_value( EXPORTING im_bitem = ls_bitem IMPORTING ex_created = DATA(lv_created) ).
            IF lv_created EQ abap_true.
              IF ls_target-%cid IS NOT INITIAL.
                APPEND VALUE #( %cid = ls_target-%cid BookingId = ls_target-BookingId SeatNumber = ls_target-SeatNumber ) TO mapped-seat.
              ENDIF.
            ENDIF.
          ELSE.
            IF ls_target-%cid IS NOT INITIAL.
              APPEND VALUE #( %cid = ls_target-%cid BookingId = ls_target-BookingId SeatNumber = ls_target-SeatNumber ) TO failed-seat.
            ENDIF.
          ENDIF.
        ENDIF.
      ENDLOOP.
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.

" SAVER CLASS UPGRADED TO HANDLE INTERNAL TABLES
CLASS lsc_ZCIT_I_BUS_157 DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.
    METHODS finalize REDEFINITION.
    METHODS check_before_save REDEFINITION.
    METHODS save REDEFINITION.
    METHODS cleanup REDEFINITION.
    METHODS cleanup_finalize REDEFINITION.
ENDCLASS.

CLASS lsc_ZCIT_I_BUS_157 IMPLEMENTATION.
  METHOD finalize. ENDMETHOD.
  METHOD check_before_save. ENDMETHOD.
  METHOD cleanup_finalize. ENDMETHOD.

  METHOD save.
    DATA(lo_util) = zcl_cit_util_157=>get_instance( ).
    lo_util->get_hdr_value( IMPORTING ex_bhead = DATA(lt_bhead) ).
    lo_util->get_itm_value( IMPORTING ex_bitem = DATA(lt_bitem) ).
    lo_util->get_hdr_t_deletion( IMPORTING ex_bookings = DATA(lt_del_header) ).
    lo_util->get_itm_t_deletion( IMPORTING ex_rooms = DATA(lt_del_items) ).
    lo_util->get_deletion_flags( IMPORTING ex_hdr_del = DATA(lv_hdr_del) ).

    IF lt_bhead IS NOT INITIAL. MODIFY zcit_bhead_157 FROM TABLE @lt_bhead. ENDIF.
    IF lt_bitem IS NOT INITIAL. MODIFY zcit_bitem_157 FROM TABLE @lt_bitem. ENDIF.

    IF lv_hdr_del = abap_true.
      LOOP AT lt_del_header INTO DATA(ls_del_hdr).
        DELETE FROM zcit_bhead_157 WHERE booking_id = @ls_del_hdr-booking_id.
        DELETE FROM zcit_bitem_157 WHERE booking_id = @ls_del_hdr-booking_id.
      ENDLOOP.
    ELSE.
      LOOP AT lt_del_header INTO ls_del_hdr. DELETE FROM zcit_bhead_157 WHERE booking_id = @ls_del_hdr-booking_id. ENDLOOP.
      LOOP AT lt_del_items INTO DATA(ls_del_itm). DELETE FROM zcit_bitem_157 WHERE booking_id = @ls_del_itm-booking_id AND seat_number = @ls_del_itm-seat_number. ENDLOOP.
    ENDIF.
  ENDMETHOD.

  METHOD cleanup. zcl_cit_util_157=>get_instance( )->cleanup_buffer( ). ENDMETHOD.
ENDCLASS.
