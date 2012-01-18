/**
 * Oracle(c) PL/SQL 11g Parser  
 *
 * Copyright (c) 2009-2011 Alexandre Porcelli <alexandre.porcelli@gmail.com>
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

parser grammar PLSQLCommons;

options {
    output=AST;
}

tokens {
    ALIAS;
    EXPR;
    ARGUMENTS;
    ARGUMENT;
    PARAMETER_NAME;
    ATTRIBUTE_NAME;
    SAVEPOINT_NAME;
    ROLLBACK_SEGMENT_NAME;
    TABLE_VAR_NAME;
    SCHEMA_NAME;
    ROUTINE_NAME;
    PACKAGE_NAME;
    IMPLEMENTATION_TYPE_NAME;
    REFERENCE_MODEL_NAME;
    MAIN_MODEL_NAME;
    QUERY_NAME;
    CONSTRAINT_NAME;
    LABEL_NAME;
    TYPE_NAME;
    SEQUENCE_NAME;
    EXCEPTION_NAME;
    FUNCTION_NAME;
    PROCEDURE_NAME;
    TRIGGER_NAME;
    INDEX_NAME;
    CURSOR_NAME;
    RECORD_NAME;
    COLLECTION_NAME;
    LINK_NAME;
    COLUMN_NAME;
    TABLEVIEW_NAME;
    CHAR_SET_NAME;
    ID;
    VARIABLE_NAME;
    HOSTED_VARIABLE_NAME;
    CUSTOM_TYPE;
    NATIVE_DATATYPE;
    INTERVAL_DATATYPE;
    PRECISION;
    CASCATED_ELEMENT;
    HOSTED_VARIABLE_ROUTINE_CALL;
    HOSTED_VARIABLE;
    ROUTINE_CALL;
    ANY_ELEMENT;
    COST_CLASS_NAME;
    XML_COLUMN_NAME;
    TABLE_NAME;
    OBJECT_NAME;
    CLUSTER_NAME;
    TABLESPACE_NAME;
}

// $<Common SQL PL/SQL Clauses/Parts

partition_extension_clause
    :    ( subpartition_key^ | partition_key^ ) 
        for_key!? expression_list
    ;

alias
    :    as_key? (id|alias_quoted_string)
    ->    ^(ALIAS id? alias_quoted_string?)
    ;

alias_quoted_string
    :    quoted_string
        -> ID[$quoted_string.start]
    ;

where_clause
    :    where_key^ (current_of_clause|condition_wrapper)
    ;

current_of_clause
    :    current_key^ of_key! cursor_name
    ;

into_clause
    :    into_key^ variable_name (COMMA! variable_name)* 
    |    bulk_key^ collect_key! into_key! variable_name (COMMA! variable_name)* 
    ;

// $>

// $<Common PL/SQL Named Elements

xml_column_name
    :    id -> ^(XML_COLUMN_NAME id)
    |    quoted_string -> ^(XML_COLUMN_NAME ID[$quoted_string.start])
    ;

cost_class_name
    :    id
        -> ^(COST_CLASS_NAME id)
    ;

attribute_name
    :    id
        -> ^(ATTRIBUTE_NAME id)
    ;

savepoint_name
    :    id
        -> ^(SAVEPOINT_NAME id)
    ;

rollback_segment_name
    :    id
        -> ^(ROLLBACK_SEGMENT_NAME id)
    ;


table_var_name
    :    id
        -> ^(TABLE_VAR_NAME id)
    ;

schema_name
    :    id
        -> ^(SCHEMA_NAME id)
    ;

routine_name
    :    id ((PERIOD id_expression)=> PERIOD id_expression)* (AT_SIGN link_name)?
        -> ^(ROUTINE_NAME id id_expression* link_name?)
    ;

package_name
    :    id
        -> ^(PACKAGE_NAME id)
    ;

tablespace_name
    :    id
        -> ^(TABLESPACE_NAME id)
    ;

implementation_type_name
    :    id ((PERIOD id_expression)=> PERIOD id_expression)?
        -> ^(IMPLEMENTATION_TYPE_NAME id id_expression?)
    ;

parameter_name
    :    id
        -> ^(PARAMETER_NAME id)
    ;

reference_model_name
    :    id
        -> ^(REFERENCE_MODEL_NAME id)
    ;

main_model_name
    :    id
        -> ^(MAIN_MODEL_NAME id)
    ;

aggregate_function_name
    :    id ((PERIOD id_expression)=> PERIOD id_expression)*
        -> ^(ROUTINE_NAME id id_expression*)
    ;

query_name
    :    id
        -> ^(QUERY_NAME id)
    ;

constraint_name
    :    id ((PERIOD id_expression)=> PERIOD id_expression)* (AT_SIGN link_name)?
        -> ^(CONSTRAINT_NAME id id_expression* link_name?)
    ;

label_name
    :    id_expression
        -> ^(LABEL_NAME id_expression)
    ;

type_name
    :    id_expression ((PERIOD id_expression)=> PERIOD id_expression)*
        -> ^(TYPE_NAME id_expression+)
    ;

sequence_name
    :    id_expression ((PERIOD id_expression)=> PERIOD id_expression)*
        -> ^(SEQUENCE_NAME id_expression+)
    ;

exception_name
    :    id ((PERIOD id_expression)=> PERIOD id_expression)* 
        ->^(EXCEPTION_NAME id id_expression*)
    ;

function_name
    :    id ((PERIOD id_expression)=> PERIOD id_expression)?
        -> ^(FUNCTION_NAME id id_expression*)
    ;

procedure_name
    :    id ((PERIOD id_expression)=> PERIOD id_expression)?
        -> ^(PROCEDURE_NAME id id_expression*)
    ;

trigger_name
    :    id ((PERIOD id_expression)=> PERIOD id_expression)?
        ->^(TRIGGER_NAME id id_expression*)
    ;

table_name
    :    id ((PERIOD id_expression)=> PERIOD id_expression)?
        -> ^(TABLE_NAME id id_expression*)
    ;

object_name
    :    id ((PERIOD id_expression)=> PERIOD id_expression)?
        -> ^(OBJECT_NAME id id_expression*)
    ;

variable_name
@init    {    boolean isHosted = false;    }
    :    (COLON {isHosted = true;})? (INTRODUCER char_set_name)?
            id_expression (((PERIOD|COLON) id_expression)=> (PERIOD|COLON) id_expression)?
        ->{isHosted}? ^(HOSTED_VARIABLE_NAME char_set_name? id_expression*)
        -> ^(VARIABLE_NAME char_set_name? id_expression*)
    ;

index_name
    :    id ((PERIOD id_expression)=> PERIOD id_expression)?
        -> ^(INDEX_NAME id id_expression*)
    ;

cluster_name
    :    id
        -> ^(CLUSTER_NAME id)
    ;

cursor_name
    :    id
        -> ^(CURSOR_NAME id)
    ;

record_name
    :    id
        ->^(RECORD_NAME id)
    ;

collection_name
    :    id ((PERIOD id_expression)=> PERIOD id_expression)?
        ->^(COLLECTION_NAME id id_expression?)
    ;

link_name
    :    id
        -> ^(LINK_NAME id)
    ;

column_name
    :    id ((PERIOD id_expression)=> PERIOD id_expression)*
        -> ^(COLUMN_NAME id id_expression*)
    ;

tableview_name
    :    id ((PERIOD id_expression)=> PERIOD id_expression)? 
    (    AT_SIGN link_name
    |    {!(input.LA(2) == SQL92_RESERVED_BY)}?=> partition_extension_clause
    )?
        -> ^(TABLEVIEW_NAME id id_expression? link_name? partition_extension_clause?)
    ;

char_set_name
    :    id_expression ((PERIOD id_expression)=> PERIOD id_expression)*
        ->^(CHAR_SET_NAME id_expression+)
    ;

// $>

// $<Common PL/SQL Specs

function_argument
    :    LEFT_PAREN 
            argument? (COMMA argument )* 
        RIGHT_PAREN
        -> ^(ARGUMENTS argument*)
    ;

argument
@init    {    int mode = 0;    }
    :    ((id EQUALS_OP GREATER_THAN_OP)=> id EQUALS_OP GREATER_THAN_OP {mode = 1;})? expression_wrapper
        ->{mode == 1}? ^(ARGUMENT expression_wrapper ^(PARAMETER_NAME[$EQUALS_OP] id))
        -> ^(ARGUMENT expression_wrapper)
    ;

type_spec
    :     datatype
    |    ref_key? type_name (percent_rowtype_key|percent_type_key)? -> ^(CUSTOM_TYPE type_name ref_key? percent_rowtype_key? percent_type_key?)
    ;

datatype
    :    native_datatype_element
        precision_part?
        (with_key local_key? time_key zone_key)?
        -> ^(NATIVE_DATATYPE native_datatype_element precision_part? time_key? local_key?)
    |    interval_key (year_key|day_key)
                (LEFT_PAREN expression_wrapper RIGHT_PAREN)? 
            to_key (month_key|second_key) 
                (LEFT_PAREN expression_wrapper RIGHT_PAREN)?
        -> ^(INTERVAL_DATATYPE[$interval_key.start] year_key? day_key? month_key? second_key? expression_wrapper*)
    ;

precision_part
    :    LEFT_PAREN numeric (COMMA numeric)? (char_key | byte_key)? RIGHT_PAREN
        -> ^(PRECISION numeric+ char_key? byte_key?)
    ;

native_datatype_element
    :    binary_integer_key
    |    pls_integer_key
    |    natural_key
    |    binary_float_key
    |    binary_double_key
    |    naturaln_key
    |    positive_key
    |    positiven_key
    |    signtype_key
    |    simple_integer_key
    |    nvarchar2_key
    |    dec_key
    |    integer_key
    |    int_key
    |    numeric_key
    |    smallint_key
    |    number_key
    |    decimal_key 
    |    double_key precision_key?
    |    float_key
    |    real_key
    |    nchar_key
    |    long_key raw_key?
    |    char_key  
    |    character_key 
    |    varchar2_key
    |    varchar_key
    |    string_key
    |    raw_key
    |    boolean_key
    |    date_key
    |    rowid_key
    |    urowid_key
    |    year_key
    |    month_key
    |    day_key
    |    hour_key
    |    minute_key
    |    second_key
    |    timezone_hour_key
    |    timezone_minute_key
    |    timezone_region_key
    |    timezone_abbr_key
    |    timestamp_key
    |    timestamp_unconstrained_key
    |    timestamp_tz_unconstrained_key
    |    timestamp_ltz_unconstrained_key
    |    yminterval_unconstrained_key
    |    dsinterval_unconstrained_key
    |    bfile_key
    |    blob_key
    |    clob_key
    |    nclob_key
    |    mlslabel_key
    ;

general_element
@init    {    boolean isCascated = true;    }
    :    general_element_part (((PERIOD|COLON) general_element_part)=> (PERIOD|COLON) general_element_part {isCascated = true;})*
        ->{isCascated}? ^(CASCATED_ELEMENT general_element_part+)
        -> general_element_part
    ;

general_element_part
@init    {    boolean isHosted = false; boolean isRoutineCall = false;    }
    :    (INTRODUCER char_set_name)? (COLON {isHosted = true;})? id_expression 
            (((PERIOD|COLON) id_expression)=> (PERIOD|COLON) id_expression)* (function_argument {isRoutineCall = true;})?
        ->{isHosted && isRoutineCall}? ^(HOSTED_VARIABLE_ROUTINE_CALL ^(ROUTINE_NAME char_set_name? id_expression+) function_argument)
        ->{isHosted && !isRoutineCall}? ^(HOSTED_VARIABLE char_set_name? id_expression+)
        ->{!isHosted && isRoutineCall}? ^(ROUTINE_CALL ^(ROUTINE_NAME char_set_name? id_expression+) function_argument)
        -> ^(ANY_ELEMENT char_set_name? id_expression+)
    ;

// $>

// $<Lexer Mappings

constant
    :    numeric
    |    quoted_string
    |    null_key
    |    true_key
    |    false_key
    |    dbtimezone_key 
    |    sessiontimezone_key
    |    minvalue_key
    |    maxvalue_key
    |    default_key
    ;

numeric
    :    UNSIGNED_INTEGER
    |    EXACT_NUM_LIT
    |    APPROXIMATE_NUM_LIT;

quoted_string
    :    CHAR_STRING
    ;

id
    :    (INTRODUCER char_set_name)?
        id_expression
        -> char_set_name? id_expression
    ;

id_expression
    :    REGULAR_ID ->    ID[$REGULAR_ID]
    |    DELIMITED_ID ->    ID[$DELIMITED_ID] 
    ;
// $>
