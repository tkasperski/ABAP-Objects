*&---------------------------------------------------------------------*
*& Report  z002_car_class
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

REPORT  Z002_CAR_CLASS.

*----------------------------------------------------------------------*
*       CLASS car DEFINITION
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
CLASS car DEFINITION.
  PUBLIC SECTION.
    CLASS-DATA: numofcars TYPE i.           "Static Arrtibute

    CLASS-METHODS class_constructor.        "Static-Constructor

    METHODS constructor                     "Instance Constructor
      IMPORTING
        make TYPE c
        model TYPE c
        numseats TYPE i
        maxspeed TYPE i.

    METHODS viewcar.

    METHODS setnumseats
      IMPORTING
        newseatnum TYPE i.

    METHODS gofaster
      IMPORTING
        increment TYPE i
      EXPORTING
        result TYPE i.

    METHODS goslower                        
      IMPORTING                            
        increment TYPE i
      RETURNING
        value(result) TYPE i.



  PRIVATE SECTION.
    DATA: make TYPE c LENGTH 20,                                                                                                 
          model TYPE c LENGTH 20,
          numseats TYPE i,
          speed TYPE i,
          maxspeed TYPE i.

    CLASS-DATA: carlog TYPE c LENGTH 40.    "Used by the Class_Constructor

ENDCLASS.                    "car DEFINITION


*----------------------------------------------------------------------*
*       CLASS car IMPLEMENTATION
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
CLASS car IMPLEMENTATION.

  METHOD class_constructor.
    carlog = 'Car class used'.
    WRITE: / carlog.

  ENDMETHOD.                    "class_constructor

  METHOD constructor.                       "Instance Constructor
    me->make = make.                        
    me->model = model.
    me->numseats = numseats.
    me->maxspeed = maxspeed.
    numofcars = numofcars + 1.              
  ENDMETHOD.                    "constructor

  METHOD viewcar.                           
    WRITE: / 'Make = ', 19 make.
    WRITE: / 'Model = ', 19 model .
    WRITE: / 'Number of Seats = ', 19 numseats LEFT-JUSTIFIED.
    WRITE: / 'Max Speed = ', 19 maxspeed LEFT-JUSTIFIED.
    WRITE: / 'Speed = ', 19 speed LEFT-JUSTIFIED.
  ENDMETHOD.                    "viewcar

  METHOD setnumseats.                      
    numseats = newseatnum.
  ENDMETHOD.                    "setnumseats

  METHOD gofaster.
    DATA  tmpspeed TYPE i.
    tmpspeed = speed + increment.
    IF tmpspeed <= maxspeed.
      speed = speed + increment.
    ENDIF.
    result = speed.
  ENDMETHOD.                    "gofaster

  METHOD goslower.
    DATA  tmpspeed TYPE i.
    tmpspeed = speed - increment.
    IF tmpspeed >= 0.
      speed = speed - increment.
    ENDIF.
    result = speed.
  ENDMETHOD.                    "goslower

ENDCLASS.                    "car IMPLEMENTATION

START-OF-SELECTION.             "Program start.

  DATA theresult TYPE i.        

  DATA car1 TYPE REF TO car.    
  CREATE OBJECT car1
    EXPORTING
      make     = 'MERCEDES'
      model    = 'S'
      numseats = 5
      maxspeed = 250.

  car1->viewcar( ).                     "Call the instance method
  uline.

  car1->setnumseats( 4 ).               
  car1->viewcar( ).
  uline.

  car1->setnumseats( newseatnum = 3 ).  
  car1->viewcar( ).                     
  uline.

  car1->gofaster( EXPORTING increment = 25 IMPORTING result = theresult ).
  car1->viewcar( ).                     
  WRITE: / 'gofaster result: ', theresult LEFT-JUSTIFIED.
  uline.

  car1->goslower( EXPORTING increment = 15 RECEIVING result = theresult ).
  car1->viewcar( ).                     
  WRITE: / 'goslower result: ', theresult LEFT-JUSTIFIED.
  uline.

  WRITE: / 'Cars created number: ', car=>numofcars LEFT-JUSTIFIED. "Reference the static-data

* Calling a functional method second way.
  theresult = car1->goslower( 5 ).
  car1->viewcar( ).                     
  WRITE: / 'goslower result (functional Method): ', theresult LEFT-JUSTIFIED.
  uline.