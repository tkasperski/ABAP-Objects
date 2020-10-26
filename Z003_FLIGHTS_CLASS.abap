*&---------------------------------------------------------------------*
*& Report  Z003_FLIGHTS_CLASS
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

REPORT  Z003_FLIGHTS_CLASS.

*----------------------------------------------------------------------*
*       CLASS flights DEFINITION
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
CLASS flights DEFINITION.
  PUBLIC SECTION.

    METHODS constructor.        " Load the records from SPFLI into the internal table attribute.

    METHODS showAllData.

    METHODS showConnidData
      IMPORTING cid TYPE S_CONN_ID.

    METHODS numFlightsTo
      IMPORTING city TYPE S_TO_CITY
      RETURNING VALUE(numflights) TYPE i.

    METHODS: getConnid
      IMPORTING cityfrom TYPE S_FROM_CIT
                cityto TYPE S_TO_CITY
      RETURNING VALUE(connid) TYPE S_CONN_ID.

    METHODS: getFlightTime
      IMPORTING cid TYPE S_CONN_ID
      RETURNING VALUE(minutes) TYPE i.

    METHODS: getAllConnectionFacts
      IMPORTING cid TYPE S_CONN_ID
      RETURNING VALUE(conn) TYPE SPFLI.


  PRIVATE SECTION.
    TYPES: fl_tab_type type STANDARD TABLE OF SPFLI.
    DATA: flight_table TYPE fl_tab_type.

ENDCLASS.                    "flights DEFINITION


*----------------------------------------------------------------------*
*       CLASS flights IMPLEMENTATION
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
CLASS flights IMPLEMENTATION.

  METHOD constructor.
    SELECT * FROM spfli INTO TABLE flight_table.
    if sy-subrc <> 0.
      WRITE: 'Problem with reading SPFLI Table'.
    ENDIF.
  ENDMETHOD.                    "constructor

  METHOD showAllData.
    DATA: wa TYPE SPFLI.

    LOOP AT flight_table into wa.
      WRITE: /   wa-carrid,
             5   wa-connid,
             10  wa-countryfr,
             14  wa-cityfrom,
             36  wa-airpfrom,
             40  wa-countryto,
             44  wa-cityto,
             66  wa-airpto,
             69  wa-fltime,
             77  wa-deptime,
             87  wa-arrtime,
             97  wa-distance,
             107 wa-distid,
             110 wa-fltype,
             115 wa-period.
    ENDLOOP.
    uline.

  ENDMETHOD.                    "showAllData

  METHOD showConnidData.
    DATA: wa type spfli.

    READ TABLE flight_table INTO wa with key connid = cid.
    IF sy-subrc = 0.
      WRITE: / wa-cityfrom,
            22 wa-airpfrom,
            27 wa-countryto,
            49 wa-fltime,
            54 wa-distance.
    ELSE.
      WRITE: 'connid: ', cid, 'no record found.'.
    ENDIF.

  ENDMETHOD.                    "showConnidData

  METHOD numFlightsTo.
    LOOP at flight_table TRANSPORTING NO FIELDS WHERE AIRPTO = city.
      numflights = numflights + 1.
    ENDLOOP.

  ENDMETHOD.                    "numFlightsTo

  METHOD getConnid.
    DATA: wa TYPE spfli.

    connid = 0.
    READ TABLE flight_table INTO wa WITH KEY AIRPFROM = cityfrom
                                             AIRPTO   = cityto.
    connid = wa-connid.

  ENDMETHOD.                    "getConnid

  METHOD getFlightTime.
    DATA: wa TYPE SPFLI.

    minutes = 0.
    READ TABLE flight_table INTO wa WITH KEY connid = cid.
    minutes = wa-FLTIME.

  ENDMETHOD.                    "getFlightTime

  METHOD getAllConnectionFacts.

    CLEAR conn.
    READ TABLE flight_table INTO conn WITH KEY connid = cid.

  ENDMETHOD.                    "getAllConnectionFacts

ENDCLASS.                    "flights IMPLEMENTATION

START-OF-SELECTION.          "Program

  DATA: temp TYPE i,
        wa TYPE spfli.

  DATA my_flight_class TYPE REF TO FLIGHTS.
  CREATE OBJECT my_flight_class.

  my_flight_class->showAllData( ).

  my_flight_class->showConnidData( 1984 ).
  ULINE.

  temp = my_flight_class->numFlightsTo( 'JFK' ).
  WRITE temp.
  ULINE.

  temp = my_flight_class->getConnid( cityfrom = 'JFK' cityto = 'FRA' ).
  WRITE temp.
  ULINE.

  temp = my_flight_class->getFlightTime( 3504 ).
  WRITE temp.
  ULINE.

  wa = my_flight_class->getAllConnectionFacts( 3504 ).
  WRITE: /   wa-carrid,
         5   wa-connid,
         10  wa-countryfr,
         14  wa-cityfrom,
         36  wa-airpfrom,
         40  wa-countryto,
         44  wa-cityto,
         66  wa-airpto,
         69  wa-fltime,
         77  wa-deptime,
         87  wa-arrtime,
         97  wa-distance,
         107 wa-distid,
         110 wa-fltype,
         115 wa-period.