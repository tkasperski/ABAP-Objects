*&---------------------------------------------------------------------*
*& Report  Z009_INTERFACES
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

REPORT  z009_interfaces.

* INTERFACES

INTERFACE intf_speed.
  METHODS: writespeed.
ENDINTERFACE.                    "intf_speed

*----------------------------------------------------------------------*
*       CLASS train DEFINITION
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
CLASS train DEFINITION.
  PUBLIC SECTION.
    INTERFACES intf_speed.
    ALIASES writespeed FOR intf_speed~writespeed.
    METHODS: gofaster.
  PROTECTED SECTION.
    DATA: speed TYPE i.
ENDCLASS.                    "train DEFINITION

*----------------------------------------------------------------------*
*       CLASS train IMPLEMENTATION
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
CLASS train IMPLEMENTATION.
  METHOD gofaster.
    speed = speed + 5.
  ENDMETHOD.                    "gofaster
  METHOD intf_speed~writespeed.            "Full name here
    WRITE: / 'TRAIN speed: ', speed LEFT-JUSTIFIED.
  ENDMETHOD.                    "intf_speed~writespeed
ENDCLASS.                    "train IMPLEMENTATION

* PROGRAM START

DATA mytrain TYPE REF TO train.

START-OF-SELECTION.

  CREATE OBJECT mytrain.
  mytrain->gofaster( ).
  mytrain->writespeed( ).              "Alias name