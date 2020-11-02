*&---------------------------------------------------------------------*
*& Report  Z006_INHERIT
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

REPORT  z006_inherit.

*----------------------------------------------------------------------*
*       CLASS ford DEFINITION
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
CLASS ford DEFINITION.
  PUBLIC SECTION.
***** Define the CLASS CONSTRUCTOR
    CLASS-METHODS class_constructor.        "Static Constructor

    METHODS constructor
      IMPORTING
        p_model TYPE string.

  PROTECTED SECTION.
    DATA: model TYPE string.
    CLASS-DATA: carlog TYPE c LENGTH 40.

ENDCLASS.                    "ford DEFINITION

*----------------------------------------------------------------------*
*       CLASS mercedes DEFINITION
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
CLASS mercedes DEFINITION INHERITING FROM ford.
***** Redefine the CLASS CONSTRUCTOR
  PUBLIC SECTION.
    CLASS-METHODS class_constructor.        "Static Constructor
ENDCLASS.                    "mercedes DEFINITION

*----------------------------------------------------------------------*
*       CLASS audi DEFINITION
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
CLASS audi DEFINITION INHERITING FROM mercedes.
  PUBLIC SECTION.
***** Redefine the CLASS CONSTRUCTOR
    CLASS-METHODS class_constructor.        "Static Constructor

    METHODS constructor
      IMPORTING
        p_model  TYPE string
        p_wheels TYPE i.

  PROTECTED SECTION.
    DATA: wheels TYPE i.

ENDCLASS.                    "audi DEFINITION

*----------------------------------------------------------------------*
*       CLASS ford IMPLEMENTATION
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
CLASS ford IMPLEMENTATION.
  METHOD class_constructor.
    carlog = 'FORD class constructor has been used'.
    WRITE: / carlog.
  ENDMETHOD.

  METHOD constructor.
    model = p_model.
  ENDMETHOD.                    "constructor
ENDCLASS.                    "ford IMPLEMENTATION

*----------------------------------------------------------------------*
*       CLASS mercedes IMPLEMENTATION
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
CLASS mercedes IMPLEMENTATION.
  METHOD class_constructor.         " Redefine the Ford Class Constructor
    carlog = 'MERCEDES class constructor has been used'.
    WRITE: / carlog.
  ENDMETHOD.          "constructor
ENDCLASS.                    "ford IMPLEMENTATION

*----------------------------------------------------------------------*
*       CLASS audi IMPLEMENTATION
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
CLASS audi IMPLEMENTATION.
  METHOD class_constructor.         " Redefine the Mercedes Class Constructor
    carlog = 'AUDI class constructor has been used'.
    WRITE: / carlog.
  ENDMETHOD.          "constructor

  METHOD constructor.
    CALL METHOD super->constructor
      EXPORTING
        p_model = p_model.
    wheels = p_wheels.
  ENDMETHOD.                    "constructor
ENDCLASS.                    "audi IMPLEMENTATION

*Program start

DATA: my_ford     TYPE REF TO ford,
      my_mercedes TYPE REF TO mercedes,
      my_audi     TYPE REF TO audi.

START-OF-SELECTION.

  CREATE OBJECT: my_audi      EXPORTING p_model = 'A8'        " SUBCLASS - INTERFACE REDIFINED
                                        p_wheels = 4,
                 my_ford      EXPORTING p_model = 'GT',    " SUPERCLASS
                 my_mercedes  EXPORTING p_model = 'S-CLASS'.  " SUBCLASS - NO REDEFINITION

  ULINE.