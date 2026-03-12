*CLASS zcl_cit_util_157 DEFINITION
*  PUBLIC
*  FINAL
*  CREATE PRIVATE.
*
*  PUBLIC SECTION.
*    TYPES: BEGIN OF ty_bhead,
*             booking_id TYPE n LENGTH 10,
*           END OF ty_bhead,
*           BEGIN OF ty_bitem,
*             booking_id TYPE n LENGTH 10,
*             seat_number TYPE n LENGTH 2,
*           END OF ty_bitem.
*    TYPES: tt_bitem TYPE STANDARD TABLE OF ty_bitem,
*           tt_bhead TYPE STANDARD TABLE OF ty_bhead.
*
*    CLASS-METHODS get_instance RETURNING VALUE(ro_instance) TYPE REF TO zcl_cit_util_157.
*
*    METHODS:
*      set_hdr_value IMPORTING im_bhead TYPE zcit_bhead_157 EXPORTING ex_created TYPE abap_boolean,
*      get_hdr_value EXPORTING ex_bhead TYPE zcit_bhead_157,
*      set_itm_value IMPORTING im_bitem TYPE zcit_bitem_157 EXPORTING ex_created TYPE abap_boolean,
*      get_itm_value EXPORTING ex_bitem TYPE zcit_bitem_157,
*      set_hdr_t_deletion IMPORTING im_booking TYPE ty_bhead,
*      set_itm_t_deletion IMPORTING im_room TYPE ty_bitem,
*      get_hdr_t_deletion EXPORTING ex_bookings TYPE tt_bhead,
*      get_itm_t_deletion EXPORTING ex_rooms TYPE tt_bitem,
*      set_hdr_deletion_flag IMPORTING im_delete TYPE abap_boolean,
*      get_deletion_flags EXPORTING ex_hdr_del TYPE abap_boolean,
*      cleanup_buffer.
*
*  PRIVATE SECTION.
*    CLASS-DATA: gs_bhead_buff TYPE zcit_bhead_157,
*                gs_bitem_buff TYPE zcit_bitem_157,
*                gt_bhead_t_buff TYPE tt_bhead,
*                gt_bitem_t_buff TYPE tt_bitem,
*                gv_delete TYPE abap_boolean,
*                mo_instance TYPE REF TO zcl_cit_util_157.
*ENDCLASS.
*
*CLASS zcl_cit_util_157 IMPLEMENTATION.
*  METHOD get_instance. IF mo_instance IS INITIAL. CREATE OBJECT mo_instance. ENDIF. ro_instance = mo_instance. ENDMETHOD.
*  METHOD set_hdr_value. IF im_bhead-booking_id IS NOT INITIAL. gs_bhead_buff = im_bhead. ex_created = abap_true. ENDIF. ENDMETHOD.
*  METHOD get_hdr_value. ex_bhead = gs_bhead_buff. ENDMETHOD.
*  METHOD set_itm_value. IF im_bitem IS NOT INITIAL. gs_bitem_buff = im_bitem. ex_created = abap_true. ENDIF. ENDMETHOD.
*  METHOD get_itm_value. ex_bitem = gs_bitem_buff. ENDMETHOD.
*  METHOD set_hdr_t_deletion. APPEND im_booking TO gt_bhead_t_buff. ENDMETHOD.
*  METHOD set_itm_t_deletion. APPEND im_room TO gt_bitem_t_buff. ENDMETHOD.
*  METHOD get_hdr_t_deletion. ex_bookings = gt_bhead_t_buff. ENDMETHOD.
*  METHOD get_itm_t_deletion. ex_rooms = gt_bitem_t_buff. ENDMETHOD.
*  METHOD set_hdr_deletion_flag. gv_delete = im_delete. ENDMETHOD.
*  METHOD get_deletion_flags. ex_hdr_del = gv_delete. ENDMETHOD.
*  METHOD cleanup_buffer. CLEAR: gs_bhead_buff, gs_bitem_buff, gt_bhead_t_buff, gt_bitem_t_buff, gv_delete. ENDMETHOD.
*ENDCLASS.
CLASS zcl_cit_util_157 DEFINITION
  PUBLIC
  FINAL
  CREATE PRIVATE.

  PUBLIC SECTION.
    TYPES: BEGIN OF ty_bhead,
             booking_id TYPE n LENGTH 10,
           END OF ty_bhead,
           BEGIN OF ty_bitem,
             booking_id TYPE n LENGTH 10,
             seat_number TYPE n LENGTH 2,
           END OF ty_bitem.

    TYPES: tt_bitem TYPE STANDARD TABLE OF ty_bitem,
           tt_bhead TYPE STANDARD TABLE OF ty_bhead,
           tt_bhead_data TYPE STANDARD TABLE OF zcit_bhead_157,
           tt_bitem_data TYPE STANDARD TABLE OF zcit_bitem_157.

    CLASS-METHODS get_instance RETURNING VALUE(ro_instance) TYPE REF TO zcl_cit_util_157.

    METHODS:
      set_hdr_value IMPORTING im_bhead TYPE zcit_bhead_157 EXPORTING ex_created TYPE abap_boolean,
      get_hdr_value EXPORTING ex_bhead TYPE tt_bhead_data,
      set_itm_value IMPORTING im_bitem TYPE zcit_bitem_157 EXPORTING ex_created TYPE abap_boolean,
      get_itm_value EXPORTING ex_bitem TYPE tt_bitem_data,
      set_hdr_t_deletion IMPORTING im_booking TYPE ty_bhead,
      set_itm_t_deletion IMPORTING im_room TYPE ty_bitem,
      get_hdr_t_deletion EXPORTING ex_bookings TYPE tt_bhead,
      get_itm_t_deletion EXPORTING ex_rooms TYPE tt_bitem,
      set_hdr_deletion_flag IMPORTING im_delete TYPE abap_boolean,
      get_deletion_flags EXPORTING ex_hdr_del TYPE abap_boolean,
      cleanup_buffer.

  PRIVATE SECTION.
    CLASS-DATA: gt_bhead_buff TYPE tt_bhead_data,
                gt_bitem_buff TYPE tt_bitem_data,
                gt_bhead_t_buff TYPE tt_bhead,
                gt_bitem_t_buff TYPE tt_bitem,
                gv_delete TYPE abap_boolean,
                mo_instance TYPE REF TO zcl_cit_util_157.
ENDCLASS.

CLASS zcl_cit_util_157 IMPLEMENTATION.
  METHOD get_instance. IF mo_instance IS INITIAL. CREATE OBJECT mo_instance. ENDIF. ro_instance = mo_instance. ENDMETHOD.
  METHOD set_hdr_value. IF im_bhead-booking_id IS NOT INITIAL. APPEND im_bhead TO gt_bhead_buff. ex_created = abap_true. ENDIF. ENDMETHOD.
  METHOD get_hdr_value. ex_bhead = gt_bhead_buff. ENDMETHOD.
  METHOD set_itm_value. IF im_bitem IS NOT INITIAL. APPEND im_bitem TO gt_bitem_buff. ex_created = abap_true. ENDIF. ENDMETHOD.
  METHOD get_itm_value. ex_bitem = gt_bitem_buff. ENDMETHOD.
  METHOD set_hdr_t_deletion. APPEND im_booking TO gt_bhead_t_buff. ENDMETHOD.
  METHOD set_itm_t_deletion. APPEND im_room TO gt_bitem_t_buff. ENDMETHOD.
  METHOD get_hdr_t_deletion. ex_bookings = gt_bhead_t_buff. ENDMETHOD.
  METHOD get_itm_t_deletion. ex_rooms = gt_bitem_t_buff. ENDMETHOD.
  METHOD set_hdr_deletion_flag. gv_delete = im_delete. ENDMETHOD.
  METHOD get_deletion_flags. ex_hdr_del = gv_delete. ENDMETHOD.
  METHOD cleanup_buffer. CLEAR: gt_bhead_buff, gt_bitem_buff, gt_bhead_t_buff, gt_bitem_t_buff, gv_delete. ENDMETHOD.
ENDCLASS.
