*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations
CLASS lcl_message DEFINITION INHERITING FROM cl_abap_behv.
  PUBLIC SECTION.
    CLASS-METHODS :
      get_instance RETURNING VALUE(o_ref) TYPE REF TO lcl_message.
    METHODS :
      message
        IMPORTING severity   TYPE if_abap_behv_message=>t_severity DEFAULT if_abap_behv_message=>severity-error
                  text       TYPE csequence OPTIONAL
        RETURNING VALUE(msg) TYPE REF TO if_abap_behv_message .
ENDCLASS.

CLASS lcl_message IMPLEMENTATION.

  METHOD get_instance.
    o_ref = NEW lcl_message( ).
  ENDMETHOD.

  METHOD message.
    msg = me->new_message_with_text( EXPORTING severity = severity
                                               text     = text ).
  ENDMETHOD.



ENDCLASS.
