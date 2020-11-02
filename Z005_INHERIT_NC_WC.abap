*&---------------------------------------------------------------------*
*& Report  Z007_INHERIT_NC_WC
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

REPORT  z007_inherit_nc_wc.

*----------------------------------------------------------------------*
*       CLASS vehicle DEFINITION
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
CLASS vehicle DEFINITION.
  PUBLIC SECTION.
    METHODS: gofaster.

  PROTECTED SECTION.
    DATA speed TYPE i.
ENDCLASS.                    "vehicle DEFINITION

*----------------------------------------------------------------------*
*       CLASS car DEFINITION
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
CLASS car DEFINITION INHERITING FROM vehicle.
  PUBLIC SECTION.
    METHODS: gofaster REDEFINITION,
      writespeed.
ENDCLASS.                    "car DEFINITION

*----------------------------------------------------------------------*
*       CLASS vehicle IMPLEMENTATION
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
CLASS vehicle IMPLEMENTATION.
  METHOD gofaster.
    speed = speed + 1.
    WRITE: / 'VEHICLE speed: ', speed LEFT-JUSTIFIED.
  ENDMETHOD.                    "gofaster
ENDCLASS.                    "vehicle IMPLEMENTATION

*----------------------------------------------------------------------*
*       CLASS car IMPLEMENTATION
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
CLASS car IMPLEMENTATION.
  METHOD gofaster.
    speed = speed + 10.
    WRITE: / 'CAR speed: ', speed LEFT-JUSTIFIED.
  ENDMETHOD.                    "gofaster

  METHOD writespeed.
    WRITE: / 'CAR writespeed METHOD'.
  ENDMETHOD.                    "writespeed
ENDCLASS.                    "car IMPLEMENTATION

* PROGRAM START

START-OF-SELECTION.

  DATA vehicle1 TYPE REF TO vehicle.
  DATA car1     TYPE REF TO car.

* VEHICLE object without any NARROWING CAST
  WRITE: / 'VEHICLE object without any NARROWING CAST'.
  CREATE OBJECT vehicle1.
  vehicle1->gofaster( ).
  CLEAR vehicle1.

* VEHICLE object with NARROWING CAST
  ULINE.
  WRITE: / 'VEHICLE - NARROWING CAST from CAR'.
  CREATE OBJECT car1.
  vehicle1 = car1.
  vehicle1->gofaster( ).

* WIDENING CAST
* Create an obj ref to catch the error.

  DATA: my_cast_error TYPE REF TO cx_sy_move_cast_error,
        car2          TYPE REF TO car.
* Object for car2 haven't created. Car2 is an empty variable.

  TRY.
* WIDENING CAST move the ref from VEHICLE to CAR (more specific)
      car2 ?= vehicle1.
    CATCH cx_sy_move_cast_error INTO my_cast_error.
      WRITE: / 'WIDENING CAST error'.
  ENDTRY.
  IF car2 IS NOT INITIAL.
    car2->gofaster( ).
    car2->writespeed( ).
  ENDIF.

* ERROR generate

  CLEAR: car1, car2, vehicle1, my_cast_error.
  CREATE OBJECT vehicle1.
  TRY.
      car1 ?= vehicle1.
    CATCH cx_sy_move_cast_error INTO my_cast_error.
      WRITE: / 'The WIDENING CAST failed'.
  ENDTRY.
  IF car1 IS NOT INITIAL.
    car1->gofaster( ).
    car1->writespeed( ).
  ENDIF.