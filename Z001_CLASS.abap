*&---------------------------------------------------------------------*
*& Report  Z001_CLASS
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

REPORT  Z001_CLASS.

CLASS student DEFINITION.

  PUBLIC SECTION.
    DATA: name   TYPE c LENGTH 40,
          age    TYPE i,
          gender TYPE c LENGTH 1 READ-ONLY,
          status TYPE c LENGTH 1.

    METHODS setname
      IMPORTING namein TYPE c.

    METHODS getname
      EXPORTING nameout TYPE c.

    METHODS setstatus
      CHANGING newstatus TYPE c.

*Functional Method
    METHODS getstatustext
      IMPORTING VALUE(statcode) TYPE c
      RETURNING VALUE(stattext) TYPE string.

  PRIVATE SECTION.
    DATA: loginid TYPE c LENGTH 20,
          pwd     TYPE c LENGTH 15.

ENDCLASS.

CLASS student IMPLEMENTATION.

    METHOD setname.
      name = namein.
    ENDMETHOD.

    METHOD getname.
      nameout = name.
    ENDMETHOD.

    METHOD setstatus.
      IF newstatus CO 'MF'.
        status = newstatus.
        newstatus = '1'.
      ELSE.
        newstatus = '2'.
      ENDIF.
    ENDMETHOD.

*Functional Method
    METHOD getstatustext.
      CASE statcode.
        WHEN '1'.
          stattext = 'Male'.
        WHEN '2'.
          stattext = 'Female'.
        WHEN OTHERS.
          stattext = 'Unknown'.
      ENDCASE.
    ENDMETHOD.


ENDCLASS.