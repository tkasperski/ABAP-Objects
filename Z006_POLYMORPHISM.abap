*&---------------------------------------------------------------------*
*& Report  Z008_POLYMORPHISM
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

REPORT  z008_polymorphism.

*----------------------------------------------------------------------*
*       CLASS account DEFINITION
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
CLASS account DEFINITION ABSTRACT.
  PUBLIC SECTION.
    METHODS:  constructor IMPORTING
                            VALUE(i_account_holder) TYPE string
                            VALUE(i_amount)         TYPE f,

      withdraw ABSTRACT
        IMPORTING i_money                TYPE f
                  i_within_notice_period TYPE string
        EXPORTING e_money                TYPE f,

      deposit ABSTRACT
        IMPORTING i_money TYPE f
        EXPORTING e_money TYPE f,

      get_account_holder
        RETURNING VALUE(r_account_holder) TYPE string.
  PROTECTED SECTION.
    DATA: account_holder TYPE string,
          balance        TYPE f.
ENDCLASS.                    "account DEFINITION


*----------------------------------------------------------------------*
*       CLASS current DEFINITION
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
CLASS current DEFINITION INHERITING FROM account.
  PUBLIC SECTION.
    METHODS:  withdraw REDEFINITION,
      deposit REDEFINITION.
ENDCLASS.                    "current DEFINITION

*----------------------------------------------------------------------*
*       CLASS notice30 DEFINITION
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
CLASS notice30 DEFINITION INHERITING FROM account.
  PUBLIC SECTION.
    METHODS:  withdraw REDEFINITION,
      deposit REDEFINITION.

  PROTECTED SECTION.
    DATA within_notice_period TYPE c.
ENDCLASS.                    "notice30 DEFINITION

*----------------------------------------------------------------------*
*       CLASS account IMPLEMENTATION
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
CLASS account IMPLEMENTATION.
  METHOD constructor.
    account_holder       = i_account_holder.
    balance              = i_amount.
  ENDMETHOD.                    "constructor

  METHOD get_account_holder.
    r_account_holder = account_holder.
  ENDMETHOD.                    "get_account_holder
ENDCLASS.                    "account IMPLEMENTATION


*----------------------------------------------------------------------*
*       CLASS current IMPLEMENTATION
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
CLASS current IMPLEMENTATION.
  METHOD withdraw.
    WRITE: / 'START balance: ', balance EXPONENT 0 DECIMALS 2 LEFT-JUSTIFIED.
    IF i_money <= balance.
      balance = balance - i_money.
      e_money = i_money.
    ELSE.
      WRITE / 'Not enought funds.'.
    ENDIF.
    WRITE: / 'END balance  : ', balance EXPONENT 0 DECIMALS 2 LEFT-JUSTIFIED, /.
  ENDMETHOD.                    "withdraw

  METHOD deposit.
    WRITE: / 'START balance: ', balance EXPONENT 0 DECIMALS 2 LEFT-JUSTIFIED.
    balance = balance + i_money.
    e_money = i_money.
    WRITE: / 'END balance  : ', balance EXPONENT 0 DECIMALS 2 LEFT-JUSTIFIED, /.
  ENDMETHOD.                    "deposit

ENDCLASS.                    "current IMPLEMENTATION


*----------------------------------------------------------------------*
*       CLASS notice30 IMPLEMENTATION
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
CLASS notice30 IMPLEMENTATION.

  METHOD withdraw.
    DATA: zbalance TYPE f.

    IF i_within_notice_period = 'Y'.
      zbalance = balance * '0.95'.
    ELSE.
      zbalance = balance.
    ENDIF.

    WRITE: / 'START balance: ', balance EXPONENT 0 DECIMALS 2 LEFT-JUSTIFIED.
    IF i_money <= zbalance.
      balance = balance - ( i_money + ( balance * '0.05' ) ).
      e_money = i_money.
      IF i_within_notice_period = 'Y'.
        WRITE '   - PENALTY APPLIED'.
      ENDIF.
    ELSE.
      WRITE / 'Not enought funds.'.
    ENDIF.
    WRITE: / 'END balance  : ', balance EXPONENT 0 DECIMALS 2 LEFT-JUSTIFIED, /.
  ENDMETHOD.                    "withdraw

  METHOD deposit.
    WRITE: / 'START balance: ', balance EXPONENT 0 DECIMALS 2 LEFT-JUSTIFIED.
    balance = balance + ( i_money * '1.001' ).
    e_money = i_money * '1.001'.
    WRITE: / 'END balance  : ', balance EXPONENT 0 DECIMALS 2 LEFT-JUSTIFIED, /.
  ENDMETHOD.                    "deposit

ENDCLASS.                    "notice30 IMPLEMENTATION

DATA: o_account   TYPE REF TO account,
      account_tab TYPE TABLE OF REF TO account,
      holder      TYPE string,
      amount      TYPE f.

START-OF-SELECTION.

  CREATE OBJECT o_account
    TYPE
    current
    EXPORTING
      i_account_holder = 'Jan Kowalski'
      i_amount         = 1000.
  APPEND o_account TO account_tab.

  CREATE OBJECT o_account
    TYPE
    notice30
    EXPORTING
      i_account_holder = 'Piotr Nowak'
      i_amount         = 2500.
  APPEND o_account TO account_tab.

  CREATE OBJECT o_account
    TYPE
    current
    EXPORTING
      i_account_holder = 'Anita Kowalska'
      i_amount         = 1000.
  APPEND o_account TO account_tab.

  CREATE OBJECT o_account
    TYPE
    notice30
    EXPORTING
      i_account_holder = 'Jolanta Nowak'
      i_amount         = 2500.
  APPEND o_account TO account_tab.

  LOOP AT account_tab INTO o_account.
    holder = o_account->get_account_holder( ).
    o_account->deposit(  EXPORTING i_money = 225 IMPORTING e_money = amount ).
    WRITE: / 'ACCOUNT HOLDER: ', holder, ' AMOUNT: ', amount EXPONENT 0 DECIMALS 2 LEFT-JUSTIFIED.
    SKIP.

    o_account->withdraw(  EXPORTING i_money = 225
                                    i_within_notice_period = 'N'
                          IMPORTING e_money = amount ).
    WRITE: / 'ACCOUNT HOLDER: ', holder, ' AMOUNT: ', amount EXPONENT 0 DECIMALS 2 LEFT-JUSTIFIED.
    SKIP.

    holder = o_account->get_account_holder( ).
    o_account->deposit(  EXPORTING i_money = 225 IMPORTING e_money = amount ).
    WRITE: / 'ACCOUNT HOLDER: ', holder, ' AMOUNT: ', amount EXPONENT 0 DECIMALS 2 LEFT-JUSTIFIED.
    SKIP.

    o_account->withdraw(  EXPORTING i_money = 225
                                    i_within_notice_period = 'Y'
                          IMPORTING e_money = amount ).
    WRITE: / 'ACCOUNT HOLDER: ', holder, ' AMOUNT: ', amount EXPONENT 0 DECIMALS 2 LEFT-JUSTIFIED.
    ULINE.

  ENDLOOP.