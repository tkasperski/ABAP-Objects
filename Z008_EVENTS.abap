*&---------------------------------------------------------------------*
*& Report  Z010_EVENTS
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

REPORT  z010_events.

*----------------------------------------------------------------------*
*       CLASS chef DEFINITION
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
CLASS chef DEFINITION.
  PUBLIC SECTION.
    METHODS: call_service.
    EVENTS: call_for_waiter.
ENDCLASS.                    "chef DEFINITION


*----------------------------------------------------------------------*
*       CLASS customer DEFINITION
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
CLASS customer DEFINITION.
  PUBLIC SECTION.
    METHODS: constructor IMPORTING VALUE(i_tablenumber) TYPE i,
      call_for_assistance.
    EVENTS: call_for_waiter EXPORTING VALUE(e_tablenumber) TYPE i.

  PROTECTED SECTION.
    DATA tablenumber TYPE i.
ENDCLASS.                    "customer DEFINITION

CLASS waiter DEFINITION.
  PUBLIC SECTION.
    METHODS: constructor IMPORTING i_who TYPE string,
      go_see_the_chef FOR EVENT call_for_waiter OF chef,
      go_see_the_customer FOR EVENT call_for_waiter OF customer IMPORTING e_tablenumber.
  PROTECTED SECTION.
    DATA who TYPE string.
ENDCLASS.

*----------------------------------------------------------------------*
*       CLASS chef IMPLEMENTATION
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
CLASS chef IMPLEMENTATION.
  METHOD call_service.
    WRITE: / 'Chef calling WAITER EVENT'.
    RAISE EVENT call_for_waiter.
    WRITE: / 'Chef calling WAITER EVENT complete'.
    ULINE.
  ENDMETHOD.                    "call_service
ENDCLASS.                    "chef IMPLEMENTATION


*----------------------------------------------------------------------*
*       CLASS customer IMPLEMENTATION
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
CLASS customer IMPLEMENTATION.
  METHOD: constructor.
    tablenumber = i_tablenumber.
  ENDMETHOD.                    "constructor
  METHOD call_for_assistance.
    WRITE: / 'Customer calling WAITER EVENT'.
    RAISE EVENT call_for_waiter EXPORTING e_tablenumber = tablenumber.
    WRITE: / 'Customer calling WAITER EVENT complete'.
    ULINE.
  ENDMETHOD.                    "call_for_assistance
ENDCLASS.                    "customer IMPLEMENTATION

CLASS waiter IMPLEMENTATION.
  METHOD: constructor.
    who = i_who.
  ENDMETHOD.
  METHOD: go_see_the_chef.
    WRITE: / who, 'goes to see the Chef'.
  ENDMETHOD.
  METHOD: go_see_the_customer.
    WRITE: / who, 'goes to see the Customer at table:', e_tablenumber LEFT-JUSTIFIED.
  ENDMETHOD.
ENDCLASS.

*Global Data

DATA: o_chef       TYPE REF TO chef,
      o_customer_1 TYPE REF TO customer,
      o_customer_2 TYPE REF TO customer.

DATA: o_head_waiter TYPE REF TO waiter,
      o_waiter      TYPE REF TO waiter.

* Program start

START-OF-SELECTION.
  CREATE OBJECT o_chef.
  CREATE OBJECT o_customer_1 EXPORTING i_tablenumber = 2.
  CREATE OBJECT o_customer_2 EXPORTING i_tablenumber = 5.

  CREATE OBJECT o_head_waiter EXPORTING i_who = 'Sarah the head waiter'.
  CREATE OBJECT o_waiter      EXPORTING i_who = 'Bob the waiter'.

  SET HANDLER: o_head_waiter->go_see_the_chef FOR o_chef,
               o_waiter->go_see_the_customer  FOR ALL INSTANCES.

  CALL METHOD: o_chef->call_service,
               o_customer_1->call_for_assistance,
               o_customer_2->call_for_assistance.