#ifndef LIB_DBG_DEBUG_MQH_INCLUDED
#define LIB_DBG_DEBUG_MQH_INCLUDED
/**********************************************************************************
 * Copyright (C) 2010-2022 Dominik Egert <info@freie-netze.de>
 *
 * This file is the debugger library include file.
 *
 * This file may be copied and/or distributed at free will.
 *
 * Author Dominik Egert / Freie Netze UG.
 **********************************************************************************
 *
 *  Version: 4.9995
 *  State: public
 *
 *  File information
 *  ================
 *
 *
 *
 *  Usage:
 *
 *      Initial setup of library to enable its functionality
 *
 *      It is required to set these macro definitions before including the library file.
 *
 *          [... main .mq5-file ...]
 *
 *          #define LIB_DEBUG                                               // This enables the librarys fuinctionality
 *          #define LIB_DEBUG_LOGFILE                                       // This enables the librarys fuinctionality and will copy all output to a logfile.
 *                                                                          // The logfile is located in the common-folder and follows naming: common/debug_log/[PROGRAM_NAME]/{timestamp of starting the program}.txt
 *                                                                          // Timestamp is bound to the local computer clock, unix timestamp.
 *          #define LIB_DEBUG_NO_JOURNAL_OUTPUT                             // Surpress printing to the terminals journal
 *          #include <../Shared Projects/MQLplus/lib_debug.mqh>             // Depending on where you place the file, this include path will take it directly from the shared storage.
 *
 *          [... your code follows here ...]
 *
 *
 *      Defines macros for supporting debugging code.
 *
 *      Macros beginning with DBG_STR_* will represent a string.
 *      Macros beginning with DBG_MSG_* will printf information.
 *
 *      Following output and string macros are defined:
 *
 *          DBG_STR(x)                                                      // Trace info prefix.
 *          DBG_STR_PERSIST(x)                                              // Trace info prefix, message string will persist into release build.
 *          DBG_STR_VAR(x)                                                  // Convert variable value to string
 *
 *          DBG_MSG(var)                                                    // Will print out a text prefixed with trace information
 *          DBG_MSG_VAR(var)                                                // Print a variable
 *          DBG_MSG_EVAL(bool_expr)                                         // Print boolean evaluation within an if statement
 *          DBG_MSG_EVAL_IF(condition, bool_expr)                           // Print boolean evaluation within an if statement, if condition is true
 *          DBG_MSG_EVAL_CMNT(cmnt, bool_expr)                              // Print boolean evaluation within an if statement, add a value as comment
 *          DBG_MSG_EVAL_IF_CMNT(condition, cmnt, bool_expr)                // Print boolean evaluation within an if statement, add a value as comment, if condition is met
 *          DBG_MSG_VAR_IF(cond, var)                                       // Print a variable on condition (condition, variable)
 *
 *          DBG_MSG_TRACE_BEGIN                                             // Output >Trace begin<
 *          DBG_MSG_TRACE_END                                               // Output >Trace end<
 *          DBG_MSG_TRACE_RETURN                                            // Replace return(void);
 *          DBG_MSG_TRACE_RETURN_VAR(x)                                     // Replace return(x);
 *          DBG_MSG_TRACE_RETURN_OBJ(x)                                     // Replace return(x) for struct, class and interface types;
 *
 *          DBG_STR_COMMENT(str)                                            // A comment string only valid in debug, removed in release
 *
 *          DBG_MSG_TRACE_FILE_LOADER                                       // Traces the loading order of source code files, place the macro at the top of a file.
 *                                                                          // As the file gets loaded, it will print out the filename in the experts journal.
 *
 *          DBG_STR_OBJ_RTTI(obj_name)                                      // Resolve object name to string, works only inside of classes and structures
 *          DBG_MSG_OBJ_RTTI(obj_name)                                      // Print object name, works only inside of classes and structures
 *
 *
 *      Vardump for arrays:
 *
 *          DBG_MSG_VARDUMP(array)                                          // Dump variables or arrays content
 *
 *
 *      To support assert debugging code, following macros are defined:
 *
 *          DBG_ASSERT(condition, message)                                  // Default assert macro. Will end execution by crash code.
 *          DBG_ASSERT_LOG(condition, message)                              // Logging only assert macro. Execution will continue normally.
 *          DBG_ASSERT_RETURN_VOID(condition, message)                      // Return assert macro. Will execute a function return if condition is met.
 *          DBG_ASSERT_RETURN(condition, message, return_value)             // Return assert macro. Will execute a function return if condition is met and return a given value/variable.
 *
 *
 *      Software Break points:
 *
 *          DBG_SLEEP_SECONDS(seconds)                                      // Will insert a realtime sleep into execution
 *          DBG_SOFT_BREAKPOINT                                             // Will halt execution for given timeout
 *          DBG_SOFT_BREAKPOINT_TS(timestamp)                               // Will halt for timeout seconds at (TimeCurrent() - (TimeCurrent() % PeriodSeconds()) == timestamp)
 *          DBG_SOFT_BREAKPOINT_CONDITION(x)                                // Will halt execution if condition is met
 *          DBG_SOFT_BREAKPOINT_EXEC_TIME(x)                                // Will halt execution after given execution time runtime
 *
 *
 *      Condtional Break points and groups:
 *
 *          Initially you create a break ID on the global scope of the program, using the macro
 *          DBG_BREAK_CONDITION_CREATE. The first parameter is any alphanumeric ID you make up
 *          to identify the break point group. The second parameter allows you to disable the group
 *          and therefore should be set to true by default.
 *          Within the code, you use the other macros. The macro DBG_BREAK_CONDITION_ACTIVATE is used to
 *          activate a break point group. if the y parameter is true, it will activate the brakepoints
 *          with the identifier given in the parameter x.
 *          The macro DBG_BREAK_CONDITION_DEACTIVATE allows you to disable a breakpoint group by code. If
 *          its parameter y is true, it will disable the group.
 *          The macro DBG_BREAK_CONDITION_ON_ID is used to have breakpoints spread out in your code,
 *          wherever this macro is placed and when the group condition has been evaluated to true, the break
 *          point will be enabled and halt execution on this macro.
 *
 *          The parameter x is the group id, set by you, alphanumeric. No quotations!!
 *          The parameter y is the conditional parameter and must evaluate to true or false. It can be
 *          a function call, a variable or an evaluation. Following the boolean evaluation of the compiler.
 *
 *          DBG_BREAK_CONDITION_CREATE(x, y)                                // Create a conditional break ID group
 *          DBG_BREAK_CONDITION_ACTIVATE(x, y)                              // Enable the groups break points
 *          DBG_BREAK_CONDITION_DEACTIVATE(x, y)                            // Disable a groups break points
 *          DBG_BREAK_CONDITION_ON_ID(x)                                    // Check for break on this group
 *
 *
 *      Call counter break point:
 *
 *          Function calling is being counted by the macro DBG_MSG_TRACE_BEGIN and provides a counter variable
 *          specific to this function. A break point for debugging can be set with the following macro, enabling you
 *          to interrupt the program at a specific call counter. Specify the count as parameter to this macro.
 *
 *          DBG_BREAK_CALL_COUNTER(x)                                       // Break point after x calls to this function
 *
 *
 *      Loop tracing:
 *
 *          DBG_TRACE_LOOP_BEGIN                                            // A new loop will be defined
 *          DBG_TRACE_LOOP_START                                            // At the beginning of a loop, inside the loop
 *          DBG_TRACE_LOOP_FINISH                                           // At the end of a loop, inside the loop
 *          DBG_TRACE_LOOP_END                                              // After a loop is done, will print out stats
 *
 *
 *      Complex loop tracing:
 *
 *          To have multiple execution paths withina loop being seperately traced, you may
 *          want to specify the trace id. This way you can define different paths throughout the loop
 *          and get an understanding of the execution costs each path implies.
 *
 *          DBG_TRACE_LOOP_BEGIN_ID(id)                                     // A new loop counter with id will be defined
 *          DBG_TRACE_LOOP_START_ID(id)                                     // Start loop counter with ID at the beginning of a loop, inside the loop
 *          DBG_TRACE_LOOP_FINISH_ID(id)                                    // Finish loop counter with ID at the end of a loop, inside the loop
 *          DBG_TRACE_LOOP_END_ID(id)                                       // After a loop is done, will print out stats for this ID
 *
 *
 *  Hint:
 *
 *      All debug macros will be removed in runtime builds.
 *
 *
 *  Example:
 *
 *      Function definition for call tracing:
 *
 *          Define two macros for replacement to be able to turn on/off tracing
 *          for a specific function.
 *          To enable tracing a define will switch trace code on.
 *
 *          #define DBG_TRACE_SOME_FUNCTION
 *
 *          Later in the function body, the macro xxx_RETURN will be used instead
 *          of the usual "return" command...
 *
 *          /////////////////////////////////////
 *          // Function debug trace code
 *
 *          #ifdef DBG_TRACE_SOME_FUNCTION
 *              #undef DBG_TRACE_SOME_FUNCTION
 *              #define DBG_TRACE_SOME_FUNCTION(x) x
 *              #define DBG_TRACE_SOME_FUNCTION_RETURN(x) DBG_MSG_TRACE_RETURN_VAR(x)
 *          #else
 *              #define DBG_TRACE_SOME_FUNCTION(x)
 *              #define DBG_TRACE_SOME_FUNCTION_RETURN(x) DBG_MSG_NOTRACE_RETURN_VAR(x)
 *          #endif
 *
 *          /////////////////////////////////////
 *
 *          Return value example:
 *
 *              #define xxx_RETURN(x) DBG_MSG_TRACE_RETURN_VAR(x)
 *
 *              Here the return value will be for example an integer.
 *
 *              When using Performance Counters, the Return Macro gets extended
 *              with the macro PERF_COUNTER_END in RELEASE. This will print out
 *              the statistics of the functions performance counter value.
 *
 *
 *          double some_function(const int index = NULL)
 *          {
 *              DBG_TRACE_SOME_FUNCTION(
 *                  DBG_MSG_TRACE_BEGIN;
 *                  DBG_MSG_VAR(index)
 *                  );
 *              PERF_COUNTER_BEGIN;
 *
 *              DBG_TRACE_SOME_FUNCTION(DBG_TRACE_LOOP_BEGIN);
 *              for(int cnt = (int)some_periods; ((cnt > NULL) && (!_StopFlag)); cnt--)
 *              {
 *                  DBG_TRACE_SOME_FUNCTION(DBG_TRACE_LOOP_START);
 *
 *                  // Basic calculations
 *                  a += a * cnt;
 *
 *                  // Some check
 *                  if(a)
 *                  { continue; }
 *
 *                  DBG_TRACE_SOME_FUNCTION(DBG_TRACE_LOOP_FINISH);
 *              }
 *              DBG_TRACE_SOME_FUNCTION(DBG_TRACE_LOOP_END);
 *
 *              // Assert value is greater than NULL
 *              DBG_ASSERT((some_testing_value > NULL), DBG_MSG_VAR(some_testing_value));
 *
 *              // Return
 *              DBG_TRACE_SOME_FUNCTION_RETURN(some_double_value);
 *          }
 *
 *
 *      Notice:
 *
 *          This line of code is the function return command.
 *          When passing a NULL value to a macro, you need to
 *          cast the NULL-Macro according to the return value type
 *          like this:
 *
 *              // Return
 *              DBG_TRACE_SOME_FUNCTION_RETURN((double)NULL);
 *
 *          Else you will receive a complie error.
 *
 *
 *      VOID-Function signatures
 *
 *          Return type "void" uses a different type of macro, replace DBG_MSG_TRACE_RETURN_VAR
 *          with DBG_MSG_TRACE_RETURN
 *
 *          /////////////////////////////////////
 *          // Function debug trace code
 *
 *          #ifdef DBG_TRACE_SOME_FUNCTION
 *              #undef DBG_TRACE_SOME_FUNCTION
 *              #define DBG_TRACE_SOME_FUNCTION(x) x
 *              #define DBG_TRACE_SOME_FUNCTION_RETURN DBG_MSG_TRACE_RETURN
 *          #else
 *              #define DBG_TRACE_SOME_FUNCTION(x)
 *              #define DBG_TRACE_SOME_FUNCTION_RETURN DBG_MSG_NOTRACE_RETURN
 *          #endif
 *
 *          /////////////////////////////////////
 *
 *
 *  Performance tracing
 *
 *      These macros are used to have performance indications on
 *      the execution speed of a function or block of code.
 *
 *      The macros without parameter are specificated on the function
 *      itself, if more than one counter within the same function or
 *      execution block is needed, they can be created by using the
 *      macros with the parameter. Pass any type of ID to it and use
 *      it later to close this counter again.
 *
 *      Performance macros will only be available in RELEASE versions.
 *      They are stripped of in debugging as well from release, if disabled.
 *
 *      Defined performance macros
 *
 *          PERF_COUNTER_BEGIN                  // Begin measurement of execution time
 *          PERF_COUNTER_END                    // End performance measurement and show stats
 *
 *          PERF_COUNTER_DEFINE_ID(x)           // Create function global performance counter
 *          PERF_COUNTER_BEGIN_ID(x)            // Begin measurement of execution time
 *          PERF_COUNTER_END_ID(x)              // End performance measurement and show stats
 *
 *          PERF_COUNTER_TIMEIT_V(x)            // Macro for measuring functions with "void" return values
 *          PERF_COUNTER_TIMEIT_R(x)            // Macro for measuring functions having valid return values
 *          PERF_COUNTER_TIMEIT_O(x)            // Macro for measuring functions returning objects as result.
 *                                              //  NOTE: Copy-Constructor of the returned object will be called twice!
 *                                                        First call will be part of measurement.
 *
 *
 *  EX5 Program info
 *
 *      A special macro is defined to deliver program information and can be
 *      displyed ie at program start. (Very helpful to determin if the program is
 *      running in debug or release mode)
 *
 *              DBG_STR_EX45_FILEINFO           // EX4/EX5 program information
 *
 *
 *  Available configuration options:
 *
 *      Basic settings are exposed below. Here is a full list of options:
 *
 *          Functional options:
 *
 *              LIB_DEBUG                       // Force enable debugging support
 *              LIB_DEBUG_LOGFILE               // Enable logging all output to file
 *              LIB_DEBUG_NO_JOURNAL_OUTPUT     // Quiet mode, will surpress all messages to the terminals expert-journal
 *              LIB_PERF_PROFILING              // Enable performance counters (Only in release mode)
 *              DBG_VARDUMP_PAUSE               // Vardump pause before continuing execution
 *              DBG_SOFT_BKP_TIMEOUT            // Breakpoint timeout before continuing execution, for soft break-points (a type of sleep-command)
 *              DBG_TRACE_EXEC_DELAY_MS         // When tracing function calls, this will insert a delay in execution after each function with enabled tracing.
 *              DBG_CRASH_CODE                  // Code used to crash the program if an assert() fails
 *
 *          Output format options:
 *
 *              DBG_ASSERT_MSG_TXT              // Prefix to assert messages
 *              DBG_TRACE_BEGIN_MSG_TXT         // Trace function call begin prefix
 *              DBG_TRACE_END_MSG_TXT           // Trace function call end prefix
 *              DBG_OUTPUT_PREFIX               // General debug output prefix
 *              DBG_OUTPUT_FORMAT               // Format string applied to debug output
 *              DBG_DOUBLE_OUTPUT_DIGITS        // Digits debugger will output on double values
 *
 *      If not defined, the default applies automatically.
 *
 *          Following list of defaults is configured as preset:
 *
 *              DBG_SOFT_BKP_TIMEOUT            120                                                     // Wait 2 minutes
 *              DBG_TRACE_EXEC_DELAY_MS         0x00                                                    // Disabled by default
 *              DBG_CRASH_CODE                  { int arr[1]; int i = 1; i = (arr[1] / (i - i)); }      // Zero divide abnormal program termination
 *
 *              DBG_ASSERT_MSG_TXT              "### --- Assertion failed!"
 *              DBG_TRACE_BEGIN_MSG_TXT         ">>>Function begin<<<"
 *              DBG_TRACE_END_MSG_TXT           ">>>Function end<<<"
 *              DBG_OUTPUT_PREFIX               "   "                                                   // Four white spaces
 *              DBG_OUTPUT_STRING               "%s%s, %s, line: %i%s"
 *              DBG_OUTPUT_FORMAT               DBG_OUTPUT_STRING, ((prefix == NULL) ? NULL : prefix + ", "), __FILE__, __FUNCSIG__, __LINE__, ((message == NULL) ? NULL : ", " + message)
 *              DBG_FLOAT_OUTPUT_DIGITS         _Digits
 *              DBG_DOUBLE_OUTPUT_DIGITS        _Digits
 *
*/


//////////////////////////////////////////
//
//  Remove this for full support of
//  the calendar structure.
//
//  The validation-process is not capable
//  of compiling this file correctly.
//  Reason seems to be because some values
//  of this structure are retrieved by
//  function call.
//
//  Structure in concern:
//      MqlCalendarValue
//
//#define __MQLPUBLISHING__



//////////////////////////////////////////
//
// Debugger switches and definitions
//

// Force enable debugger
//#define LIB_DEBUG

// Enable logging to file
// #define LIB_DEBUG_LOGFILE

// Disable logging to terminals journal
//#define LIB_DEBUG_NO_JOURNAL_OUTPUT

// Enable performance tracer
//#define LIB_PERF_PROFILING

// Force enable MQL API function call tracing (experimental feature!!! - No docs provided jet, functionality broken)
//#define LIB_MQLAPI_CALL_TRACING_ENABLED

// Force disable MQL API function call tracing
//#define LIB_MQLAPI_CALL_TRACING_DISABLE

// Pause execution after a vardump call
#define DBG_VARDUMP_PAUSE 0

// Soft breakpoint timeout in seconds
//#define DBG_SOFT_BKP_TIMEOUT 120

// Execution delay inserted into trace runs in milliseconds
//#define DBG_TRACE_EXEC_DELAY_MS 25

// Crash code definition
//#define DBG_CRASH_CODE { int arr[1]; int i = 1; i = (arr[1] / (i - i)); }

//
//////////////////////////////////////////



//////////////////////////////////////////
//
// Debugger output format setup
//

// Set default assert message
//#define DBG_ASSERT_MSG_TXT                    "### --- Assertion failed!"

// Set default trace begin messages
//#define DBG_TRACE_BEGIN_MSG_TXT               ">>>Function begin<<<"

// Set default trace end messages
//#define DBG_TRACE_END_MSG_TXT                 ">>>Function end<<<"

// Define maximum length of variable names
#define DBG_PRINT_VARNAME_MAX_LENGTH            55

// Default output prefix
//#define DBG_OUTPUT_PREFIX                     "   "

// Default file location string
//#define DBG_CODE_LOCATION_STRING              __FILE__, __FUNCTION__, __LINE__

// Output format definition
//#define DBG_OUTPUT_STRING                     "%s>%s< %s(){ @%i: %s }"
//#define DBG_OUTPUT_FORMAT(prefix, message)    DBG_OUTPUT_STRING, ((prefix == "") ? "" : prefix + " "), DBG_CODE_LOCATION_STRING, message

// Float and double output precision
//#define DBG_FLOAT_OUTPUT_DIGITS               _Digits
//#define DBG_DOUBLE_OUTPUT_DIGITS              _Digits

// Vardump array element list limit
#define DBG_VARDUMP_ARRAY_LIMIT(x)              ((ArraySize(x) > 25) ? 5 : NULL)

//
//////////////////////////////////////////









//*********************************************************************************************************************************************************/
// Debugging support
//


/////////////////////////////////////////////////////////////////////////////////////////////////////
//
// Auto enable/disable by environment
//

// Enable debugging support by file debug
#ifdef LIB_DEBUG_LOGFILE
    #ifndef LIB_DEBUG
        #define LIB_DEBUG

    #endif
    #define LIB_DBG_LOG_TO_FILE

#endif


// Autoenable
#ifndef _DEBUG
    #ifdef LIB_DEBUG
        #define _DEBUG true

    #endif

#endif


#ifdef _DEBUG
    #ifndef LIB_DEBUG
        #define LIB_DEBUG

    #endif
    #define DBG_DEBUGGER_FLAG ((LIB_DBG_NAMESPACE(dbg_lib, dbg_MQLInfoInteger)(MQL_DEBUG)) ? "MQL_DEBUG set" : "_DEBUG defined")

#endif


// Environment check
#ifndef __MQL5__
    #ifndef __MQL4_COMPATIBILITY_CODE__
        #define __MQL4_COMPATIBILITY_CODE__

    #endif
    #ifndef LIB_DBG_NAMESPACE
        #define LIB_DBG_NAMESPACE(x, y) x##_##y

    #endif
    #ifndef LIB_DBG_NAMESPACE_DEF
        #define LIB_DBG_NAMESPACE_DEF(x, y) LIB_DBG_NAMESPACE(x, y)

    #endif
#else
    #ifndef LIB_DBG_NAMESPACE
        #define LIB_DBG_NAMESPACE(x, y) x::y

    #endif
    #ifndef LIB_DBG_NAMESPACE_DEF
        #define LIB_DBG_NAMESPACE_DEF(x, y) y

    #endif
#endif

// Custom MQLplus expert remove reasons
#ifndef REASON_MQLPLUS_EXPERT_KILL
    #define REASON_MQLPLUS_EXPERT_KILL      0xFF01

#endif

//
/////////////////////////////////////////////////////////////////////////////////////////////////////





#ifdef LIB_DEBUG
/////////////////////////////////////////////////////////////////////////////////////////////////////
//
// Debugger mode
//

// By default disable mql api tracing
#ifndef LIB_DEBUG_MQLAPI
    #define LIB_MQLAPI_CALL_TRACING_DISABLE

#endif

// Set debugging mode
#define LIB_DBG_DEBUG_MQH_DEBUG_MODE

// Set _DEBUG flag if not set
#ifndef _DEBUG
    #define _DEBUG false

#endif

// Clear any existing definitions
#ifdef DBG_CODE_LOCATION
#undef DBG_CODE_LOCATION
#endif
#ifdef DBG_DEBUGGER_FLAG_STATE
#undef DBG_DEBUGGER_FLAG_STATE
#endif
#ifdef DBG_STR_EX45_FILEINFO
#undef DBG_STR_EX45_FILEINFO
#endif
#ifdef DBG_STR
#undef DBG_STR
#endif
#ifdef DBG_STR_PERSIST
#undef DBG_STR_PERSIST
#endif
#ifdef DBG_STR_VAR
#undef DBG_STR_VAR
#endif
#ifdef DBG_STR_VAR_PREFIX
#undef DBG_STR_VAR_PREFIX
#endif
#ifdef DBG_STR_BOOL
#undef DBG_STR_BOOL
#endif
#ifdef DBG_MSG
#undef DBG_MSG
#endif
#ifdef DBG_MSG_FUNC_RETVAL
#undef DBG_MSG_FUNC_RETVAL
#endif
#ifdef DBG_MSG_IF
#undef DBG_MSG_IF
#endif
#ifdef DBG_MSG_SHIFT
#undef DBG_MSG_SHIFT
#endif
#ifdef DBG_MSG_PERSIST
#undef DBG_MSG_PERSIST
#endif
#ifdef DBG_MSG_EVAL
#undef DBG_MSG_EVAL
#endif
#ifdef DBG_MSG_EVAL_CMNT
#undef DBG_MSG_EVAL_CMNT
#endif
#ifdef DBG_MSG_EVAL_IF
#undef DBG_MSG_EVAL_IF
#endif
#ifdef DBG_MSG_EVAL_IF_CMNT
#undef DBG_MSG_EVAL_IF_CMNT
#endif
#ifdef DBG_MSG_VAR
#undef DBG_MSG_VAR
#endif
#ifdef DBG_MSG_VAR_IF
#undef DBG_MSG_VAR_IF
#endif
#ifdef DBG_MSG_ARRAY_OUT_OF_RANGE
#undef DBG_MSG_ARRAY_OUT_OF_RANGE
#endif
#ifdef DBG_MSG_ARRAY_INDEX_CHECK
#undef DBG_MSG_ARRAY_INDEX_CHECK
#endif
#ifdef DBG_MSG_VARDUMP
#undef DBG_MSG_VARDUMP
#endif
#ifdef DBG_MSG_LISTDUMP
#undef DBG_MSG_LISTDUMP
#endif
#ifdef DBG_MSG_TRACE_BEGIN
#undef DBG_MSG_TRACE_BEGIN
#endif
#ifdef DBG_MSG_TRACE_END
#undef DBG_MSG_TRACE_END
#endif
#ifdef DBG_MSG_TRACE_RETURN
#undef DBG_MSG_TRACE_RETURN
#endif
#ifdef DBG_MSG_TRACE_RETURN_VAR
#undef DBG_MSG_TRACE_RETURN_VAR
#endif
#ifdef DBG_MSG_TRACE_RETURN_OBJ
#undef DBG_MSG_TRACE_RETURN_OBJ
#endif
#ifdef DBG_MSG_NOTRACE_RETURN
#undef DBG_MSG_NOTRACE_RETURN
#endif
#ifdef DBG_MSG_NOTRACE_RETURN_VAR
#undef DBG_MSG_NOTRACE_RETURN_VAR
#endif
#ifdef DBG_MSG_NOTRACE_RETURN_OBJ
#undef DBG_MSG_NOTRACE_RETURN_OBJ
#endif
#ifdef DBG_SET_UNINIT_REASON
#undef DBG_SET_UNINIT_REASON
#endif
#ifdef DBG_MSG_UNINIT_RESOLVER
#undef DBG_MSG_UNINIT_RESOLVER
#endif
#ifdef DBG_UNINIT_REASON
#undef DBG_UNINIT_REASON
#endif
#ifdef DBG_STR_COMMENT
#undef DBG_STR_COMMENT
#endif
#ifdef DBG_FILELOADER_VARNAME
#undef DBG_FILELOADER_VARNAME
#endif
#ifdef DBG_MSG_TRACE_FILE_LOADER
#undef DBG_MSG_TRACE_FILE_LOADER
#endif
#ifdef DBG_ASSERT
#undef DBG_ASSERT
#endif
#ifdef DBG_ASSERT_LOG
#undef DBG_ASSERT_LOG
#endif
#ifdef DBG_ASSERT_RETURN
#undef DBG_ASSERT_RETURN
#endif
#ifdef DBG_ASSERT_RETURN_VAR
#undef DBG_ASSERT_RETURN_VAR
#endif
#ifdef DBG_BREAK_ARRAY_OUT_OF_RANGE
#undef DBG_BREAK_ARRAY_OUT_OF_RANGE
#endif
#ifdef DBG_SLEEP_SECONDS
#undef DBG_SLEEP_SECONDS
#endif
#ifdef DBG_SOFT_BREAKPOINT
#undef DBG_SOFT_BREAKPOINT
#endif
#ifdef DBG_SOFT_BREAKPOINT_TS
#undef DBG_SOFT_BREAKPOINT_TS
#endif
#ifdef DBG_SOFT_BREAKPOINT_CONDITION
#undef DBG_SOFT_BREAKPOINT_CONDITION
#endif
#ifdef DBG_SOFT_BREAKPOINT_EXEC_TIME
#undef DBG_SOFT_BREAKPOINT_EXEC_TIME
#endif
#ifdef DBG_BREAK_CONDITION_CREATE
#undef DBG_BREAK_CONDITION_CREATE
#endif
#ifdef DBG_BREAK_CONDITION_ACTIVATE
#undef DBG_BREAK_CONDITION_ACTIVATE
#endif
#ifdef DBG_BREAK_CONDITION_DEACTIVATE
#undef DBG_BREAK_CONDITION_DEACTIVATE
#endif
#ifdef DBG_BREAK_CONDITION_ON_ID
#undef DBG_BREAK_CONDITION_ON_ID
#endif
#ifdef DBG_TRACE_LOOP_BEGIN
#undef DBG_TRACE_LOOP_BEGIN
#endif
#ifdef DBG_TRACE_LOOP_START
#undef DBG_TRACE_LOOP_START
#endif
#ifdef DBG_TRACE_LOOP_FINISH
#undef DBG_TRACE_LOOP_FINISH
#endif
#ifdef DBG_TRACE_LOOP_END
#undef DBG_TRACE_LOOP_END
#endif
#ifdef DBG_TRACE_LOOP_BEGIN_ID
#undef DBG_TRACE_LOOP_BEGIN_ID
#endif
#ifdef DBG_TRACE_LOOP_START_ID
#undef DBG_TRACE_LOOP_START_ID
#endif
#ifdef DBG_TRACE_LOOP_FINISH_ID
#undef DBG_TRACE_LOOP_FINISH_ID
#endif
#ifdef DBG_TRACE_LOOP_END_ID
#undef DBG_TRACE_LOOP_END_ID
#endif

//
/////////////////////////////////////////////////////////////////////////////////////////////////////





/////////////////////////////////////////////////////////////////////////////////////////////////////
//
// Debugger default configuration
//

// Code location string
#ifndef DBG_CODE_LOCATION_STRING
    #define DBG_CODE_LOCATION_STRING __FILE__, __FUNCTION__, __LINE__

#endif
#define DBG_CODE_LOCATION(x) LIB_DBG_NAMESPACE(dbg_lib, dbg_StringFormat)("%s %s %s %i", x, DBG_CODE_LOCATION_STRING)

// Output message format definition
#ifndef DBG_OUTPUT_FORMAT
    #define DBG_OUTPUT_STRING "%s>%s< %s(){ @%i: %s }"
    #define DBG_OUTPUT_FORMAT(prefix, message)  DBG_OUTPUT_STRING, ((prefix == "") ? "" : prefix + " "), DBG_CODE_LOCATION_STRING, message

#endif

// Output trace begin format definition
#ifndef DBG_OUTPUT_TRACE_BEGIN_FORMAT
    #define DBG_OUTPUT_TRACE_BEGIN_FORMAT "  V-V-V-V-V [ Chart-ID: %i :: Call depth: %-3i] V-V-V-V-V [ %s()  BEGIN - Call counter: %-3i ] V-V-V-V-V-V-V-V-V-V-V-V-V-V-V-V-V"

#endif

// Output trace end format definition
#ifndef DBG_OUTPUT_TRACE_END_FORMAT
    #define DBG_OUTPUT_TRACE_END_FORMAT "    A-A-A-A-A [ Call depth: %-3i] A-A-A-A-A [ %s()  END ] A-A-A-A-A-A-A-A-A-A-A-A-A-A-A-A-A-A-A-A-A-A-A-A-A-A-A-A-A-A-A-A-A-A-A-A-A-A"

#endif

// Set default api tracing behaviour
#ifdef LIB_MQLAPI_CALL_TRACING_ENABLED
    #define LIB_DBG_API_CALL_TRACE_DEFAULT true

#else
    #define LIB_DBG_API_CALL_TRACE_DEFAULT false

#endif

// Force disable mql api tracing
#ifdef LIB_MQLAPI_CALL_TRACING_DISABLE
    #undef LIB_MQLAPI_CALL_TRACING_ENABLED
    #undef LIB_DBG_API_CALL_TRACE_DEFAULT
    #define LIB_DBG_API_CALL_TRACE_DEFAULT false

#endif
#undef LIB_DBG_API_CALL_TRACE_DEFAULT
#define LIB_DBG_API_CALL_TRACE_DEFAULT true

// Float output precision
#ifndef DBG_FLOAT_OUTPUT_DIGITS
    #define DBG_FLOAT_OUTPUT_DIGITS 9

#endif

// Double output precision
#ifndef DBG_DOUBLE_OUTPUT_DIGITS
    #define DBG_DOUBLE_OUTPUT_DIGITS 16

#endif

// Crash code definition
#ifndef DBG_CRASH_CODE
    #define DBG_CRASH_CODE { int arr[1]; int i = 1; i = (arr[1] / (i - i)); }

#endif

// Maximum variable name length
#ifndef DBG_PRINT_VARNAME_MAX_LENGTH
    #define DBG_PRINT_VARNAME_MAX_LENGTH 45

#endif

// Vardump array element limiter
#ifndef DBG_VARDUMP_ARRAY_LIMIT
    #define DBG_VARDUMP_ARRAY_LIMIT(x) ((ArraySize(x) > 10) ? 5 : NULL)

#endif

// Set default assert message
#ifndef DBG_ASSERT_MSG_TXT
    #define DBG_ASSERT_MSG_TXT "### --- Assertion failed!"

#endif

// Set default trace begin messages
#ifndef DBG_TRACE_BEGIN_MSG_TXT
    #define DBG_TRACE_BEGIN_MSG_TXT ">>>Function begin<<<"

#endif

// Set default trace end messages
#ifndef DBG_TRACE_END_MSG_TXT
    #define DBG_TRACE_END_MSG_TXT ">>>Function end<<<"

#endif

// Default output prefix
#ifndef DBG_OUTPUT_PREFIX
    #define DBG_OUTPUT_PREFIX "  "

#endif

// Overwrite mode
#ifndef DBG_DEBUGGER_FLAG
    #define DBG_DEBUGGER_FLAG "LIB_DEBUG overwrite mode"
    #define DBG_DEBUGGER_OVERWRITE

#endif

// Soft breakpoint timeout in seconds
#ifndef DBG_SOFT_BKP_TIMEOUT
    #define DBG_SOFT_BKP_TIMEOUT 120

#endif

// Turn off execution profiler
#ifdef LIB_PERF_PROFILING
    #undef LIB_PERF_PROFILING

#endif

// Define log filename for file logging
#ifdef LIB_DBG_LOG_TO_FILE
    #ifndef DBG_LOG_FILENAME
        #define DBG_LOG_FILENAME StringFormat("debug_log/%s/%llu%s", LIB_DBG_NAMESPACE(dbg_lib, dbg_MQLInfoString)(MQL_PROGRAM_NAME), LIB_DBG_NAMESPACE(dbg_lib, dbg_true_system_time)(), ".txt")

    #endif

#endif

#ifdef LIB_DEBUG_NO_JOURNAL_OUTPUT
    #define LIB_DBG_NO_JOURNAL

#endif
//
/////////////////////////////////////////////////////////////////////////////////////////////////////





/////////////////////////////////////////////////////////////////////////////////////////////////////
//
// Internal helper definitions
//
// Select availabel GetTickCount function
#ifndef __MQL4_COMPATIBILITY_CODE__
    #define LIB_DBG_GETTICKCOUNT GetTickCount64

#else
    #define LIB_DBG_GETTICKCOUNT GetTickCount

#endif

// Original typename functionality
#ifndef typename_raw
    #ifdef __MQL4_COMPATIBILITY_CODE__
        #define typename_raw(x)     typename(x)

    #else
        #define typename_raw(x)     (__MQL5BUILD__ < 3510) ? typename(x) : LIB_DBG_NAMESPACE(dbg_lib, dbg_typename_to_string)(typename(x))

    #endif

#endif

// Include complex type
#ifdef __MQL4__
    #ifdef complex
        #define LIB_DBG_INCLUDE_COMPLEX_TYPE

    #endif
#else
    #define LIB_DBG_INCLUDE_COMPLEX_TYPE

#endif

// Soft breakpoint timeout command
#define DBG_SLEEP_MILLISECONDS(x) { ulong dbg_sleep_seconds_delay = (LIB_DBG_NAMESPACE(dbg_lib, dbg_GetTickCount)() + (x)); while((!_DEBUG) && (!_StopFlag) && (dbg_sleep_seconds_delay > LIB_DBG_NAMESPACE(dbg_lib, dbg_GetTickCount)())); }
#define DBG_SLEEP_SECONDS(x) DBG_SLEEP_MILLISECONDS((x * 1000))

// Execution delay
#ifdef DBG_TRACE_EXEC_DELAY_MS
    #define DBG_TRACE_EXEC_DELAY DBG_SLEEP_MILLISECONDS(DBG_TRACE_EXEC_DELAY_MS)
    #define DBG_STR_TRACE_EXEC_DELAY_INFO LIB_DBG_NAMESPACE(dbg_lib, dbg_StringFormat)("Debug trace execution delay: %i ms", DBG_TRACE_EXEC_DELAY_MS)

#else
    #define DBG_TRACE_EXEC_DELAY
    #define DBG_STR_TRACE_EXEC_DELAY_INFO ""

#endif

// Debugger state string
#define DBG_DEBUGGER_FLAG_STATE "[DEBUG]"

// Debugger runtime flag state
#define DBG_DEBUGGER_RUNTIME_STATE LIB_DBG_NAMESPACE(dbg_lib, dbg_StringFormat)("IS_DEBUG_MODE = %s\r\n     %s", (IS_DEBUG_MODE) ? "true" : "false", DBG_STR_TRACE_EXEC_DELAY_INFO)

// EX5 and terminal info string
#ifndef __MQL4_COMPATIBILITY_CODE__
    #define DBG_STR_EX45_FILEINFO LIB_DBG_NAMESPACE(dbg_lib, dbg_StringFormat)("MQL5 compiler build: %i %s\r\n  compiled@%s\r\n  => %s\r\n     %s\r\n     %s", __MQL5BUILD__, DBG_DEBUGGER_FLAG_STATE, LIB_DBG_NAMESPACE(dbg_lib, dbg_TimeToString)(__DATETIME__), DBG_DEBUGGER_FLAG_STATE, DBG_DEBUGGER_FLAG, DBG_DEBUGGER_RUNTIME_STATE)

#else
    #define DBG_STR_EX45_FILEINFO LIB_DBG_NAMESPACE(dbg_lib, dbg_StringFormat)("MQL4 Terminal build: %i\n  compiler build: %i %s\n  compiled@%s\n  => %s\n     %s\n     %s", LIB_DBG_NAMESPACE(dbg_lib, dbg_TerminalInfoInteger)(TERMINAL_BUILD), __MQL4BUILD__, DBG_DEBUGGER_FLAG_STATE, LIB_DBG_NAMESPACE(dbg_lib, dbg_TimeToString)(__DATETIME__), DBG_DEBUGGER_FLAG_STATE, DBG_DEBUGGER_FLAG, DBG_DEBUGGER_RUNTIME_STATE)

#endif

//
/////////////////////////////////////////////////////////////////////////////////////////////////////





/////////////////////////////////////////////////////////////////////////////////////////////////////
//
// Debugger helpers
//

    // Debug to string functions
    #define DBG_STR(x)                                  LIB_DBG_NAMESPACE(dbg_lib, dbg_StringFormat)(DBG_OUTPUT_FORMAT("", x))
    #define DBG_STR_PERSIST(x)                          DBG_STR(x)
    #define DBG_STR_VAR(x)                              (LIB_DBG_NAMESPACE(dbg_lib, var_out)(#x, x, DBG_MSG_SHIFT))
    #define DBG_STR_VAR_PREFIX(x, pfx)                  (LIB_DBG_NAMESPACE(dbg_lib, var_out)(#x, x, DBG_MSG_SHIFT, pfx))
    #define DBG_STR_BITS(x)                             DBG_STR(LIB_DBG_NAMESPACE(dbg_lib, bits_out)(x))


    // Debug std out
    #ifndef __MQL4_COMPATIBILITY_CODE__
        #define DBG_MSG(x)                              LIB_DBG_NAMESPACE(dbg_lib, dbg_printf)("%*s%s", LIB_DBG_NAMESPACE(dbg_lib, trace_call_depth) * 2, "", LIB_DBG_NAMESPACE(dbg_lib, dbg_StringFormat)(DBG_OUTPUT_PREFIX + DBG_OUTPUT_PREFIX + DBG_OUTPUT_FORMAT("", (x))))
        #define DBG_MSG_MQLAPI(x)                       LIB_DBG_NAMESPACE(dbg_lib, dbg_printf)((LIB_DBG_NAMESPACE(dbg_lib, trace_api_calls)) ? "%*s%s" : "", LIB_DBG_NAMESPACE(dbg_lib, trace_call_depth) * 2, "", LIB_DBG_NAMESPACE(dbg_lib, dbg_StringFormat)(DBG_OUTPUT_PREFIX + DBG_OUTPUT_PREFIX + DBG_OUTPUT_FORMAT("", (x))))
        #define DBG_MSG_SHIFT                           (LIB_DBG_NAMESPACE(dbg_lib, dbg_StringLen)(LIB_DBG_NAMESPACE(dbg_lib, dbg_StringFormat)("%*s%s", LIB_DBG_NAMESPACE(dbg_lib, trace_call_depth) * 2, "", LIB_DBG_NAMESPACE(dbg_lib, dbg_StringFormat)(DBG_OUTPUT_PREFIX + DBG_OUTPUT_PREFIX + DBG_OUTPUT_FORMAT("", (""))))) - 2)

    #else
        #define DBG_MSG(x)                              LIB_DBG_NAMESPACE(dbg_lib, dbg_printf)("%"+ LIB_DBG_NAMESPACE(dbg_lib, dbg_IntegerToString)(LIB_DBG_NAMESPACE(dbg_lib, trace_call_depth) * 2) +"s%s", "", LIB_DBG_NAMESPACE(dbg_lib, dbg_StringFormat)(DBG_OUTPUT_PREFIX + DBG_OUTPUT_PREFIX + DBG_OUTPUT_FORMAT("", (x))))
        #define DBG_MSG_MQLAPI(x)                       LIB_DBG_NAMESPACE(dbg_lib, dbg_printf)((LIB_DBG_NAMESPACE(dbg_lib, trace_api_calls)) ? "%"+ LIB_DBG_NAMESPACE(dbg_lib, dbg_IntegerToString)(LIB_DBG_NAMESPACE(dbg_lib, trace_call_depth) * 2) +"s%s" : "", "", LIB_DBG_NAMESPACE(dbg_lib, dbg_StringFormat)(DBG_OUTPUT_PREFIX + DBG_OUTPUT_PREFIX + DBG_OUTPUT_FORMAT("", (x))))
        #define DBG_MSG_SHIFT                           (LIB_DBG_NAMESPACE(dbg_lib, dbg_StringLen)(LIB_DBG_NAMESPACE(dbg_lib, dbg_StringFormat)("%"+ LIB_DBG_NAMESPACE(dbg_lib, dbg_IntegerToString)(LIB_DBG_NAMESPACE(dbg_lib, trace_call_depth) * 2) +"s%s", "", LIB_DBG_NAMESPACE(dbg_lib, dbg_StringFormat)(DBG_OUTPUT_PREFIX + DBG_OUTPUT_PREFIX + DBG_OUTPUT_FORMAT("", (""))))) - 2)

    #endif
    #define DBG_MSG_IF(c, x)                            { if(c) { DBG_MSG(StringFormat("$$DBG_IF(%s)$$ :--> %s", #c, x)); } }
    #define DBG_MSG_PERSIST(x)                          DBG_MSG(x)
    #define DBG_MSG_VAR(x)                              DBG_MSG(DBG_STR_VAR((x)))
    #define DBG_MSG_FUNC_RETVAL(x)                      (LIB_DBG_NAMESPACE(dbg_lib, dbg_return_val)(#x, x))
    #define DBG_MSG_VAR_IF(c, x)                        DBG_MSG_IF(c, DBG_STR_VAR((x)))
    #define DBG_MSG_EVAL(x)                             (LIB_DBG_NAMESPACE(dbg_lib, dbg_eval_return)(LIB_DBG_NAMESPACE(dbg_lib, dbg_StringFormat)("%*s%s", LIB_DBG_NAMESPACE(dbg_lib, trace_call_depth) * 2, "", LIB_DBG_NAMESPACE(dbg_lib, dbg_StringFormat)(DBG_OUTPUT_PREFIX + DBG_OUTPUT_PREFIX + DBG_OUTPUT_FORMAT("", (DBG_STR_VAR((x)))))), x))
    #define DBG_MSG_EVAL_IF(c, x)                       (LIB_DBG_NAMESPACE(dbg_lib, dbg_eval_return)(LIB_DBG_NAMESPACE(dbg_lib, dbg_StringFormat)("%*s%s", LIB_DBG_NAMESPACE(dbg_lib, trace_call_depth) * 2, "", LIB_DBG_NAMESPACE(dbg_lib, dbg_StringFormat)(DBG_OUTPUT_PREFIX + DBG_OUTPUT_PREFIX + DBG_OUTPUT_FORMAT("", (DBG_STR_VAR((x)))))), x, c))
    #define DBG_MSG_EVAL_CMNT(m, x)                     (LIB_DBG_NAMESPACE(dbg_lib, dbg_eval_return)(LIB_DBG_NAMESPACE(dbg_lib, dbg_StringFormat)("%*s%s (%s)", LIB_DBG_NAMESPACE(dbg_lib, trace_call_depth) * 2, "", LIB_DBG_NAMESPACE(dbg_lib, dbg_StringFormat)(DBG_OUTPUT_PREFIX + DBG_OUTPUT_PREFIX + DBG_OUTPUT_FORMAT("", (DBG_STR_VAR((x))))), LIB_DBG_NAMESPACE(dbg_lib, dbg_to_string)(m)), x))
    #define DBG_MSG_EVAL_IF_CMNT(c, m, x)               (LIB_DBG_NAMESPACE(dbg_lib, dbg_eval_return)(LIB_DBG_NAMESPACE(dbg_lib, dbg_StringFormat)("%*s%s (%s)", LIB_DBG_NAMESPACE(dbg_lib, trace_call_depth) * 2, "", LIB_DBG_NAMESPACE(dbg_lib, dbg_StringFormat)(DBG_OUTPUT_PREFIX + DBG_OUTPUT_PREFIX + DBG_OUTPUT_FORMAT("", (DBG_STR_VAR((x))))), LIB_DBG_NAMESPACE(dbg_lib, dbg_to_string)(m)), x, c))
    #define DBG_MSG_ARRAY_OUT_OF_RANGE(x, y)            { if((y < NULL) || (y >= ArraySize(x))) { DBG_MSG(StringFormat("$$DBG_MSG_ARRAY OUT OF RANGE(%s)$$ :--> %s", #x, y)); } }
    #define DBG_MSG_ARRAY_INDEX_CHECK(x, y)             LIB_DBG_NAMESPACE(dbg_lib, dbg_eval_array_index)(x, LIB_DBG_NAMESPACE(dbg_lib, dbg_eval_array_index)(ArraySize(x), y, LIB_DBG_NAMESPACE(dbg_lib, dbg_StringFormat)("%*s%s Index: [%i]", LIB_DBG_NAMESPACE(dbg_lib, trace_call_depth) * 2, "", LIB_DBG_NAMESPACE(dbg_lib, dbg_StringFormat)(DBG_OUTPUT_PREFIX + DBG_OUTPUT_PREFIX + DBG_OUTPUT_FORMAT("", (DBG_STR_VAR((x))))), y)))
    #define DBG_MSG_BITS(x)                             DBG_MSG(DBG_STR_BITS(x))
    #ifndef __MQL4_COMPATIBILITY_CODE__
        #define DBG_MSG_MQLFUNC(x)                      DBG_MSG_MQLAPI(LIB_DBG_NAMESPACE(dbg_lib, dbg_StringFormat)((LIB_DBG_NAMESPACE(dbg_lib, trace_api_calls)) ? "MQL5-API Function => %s() [void]" : "", #x)); x
        #define DBG_MSG_MQLFUNC_RETURN(x, y)            LIB_DBG_NAMESPACE(dbg_lib, dbg_mql_api_retval).msg(LIB_DBG_NAMESPACE(dbg_lib, dbg_StringFormat)("%*s%s", LIB_DBG_NAMESPACE(dbg_lib, trace_call_depth) * 2, "", LIB_DBG_NAMESPACE(dbg_lib, dbg_StringFormat)(DBG_OUTPUT_PREFIX + DBG_OUTPUT_PREFIX + DBG_OUTPUT_FORMAT("", (LIB_DBG_NAMESPACE(dbg_lib, dbg_StringFormat)("%s => %s() %35s", "MQL5-API Function", #x, "%s"))))), y) = x
        #define DBG_MSG_MQLFUNC_PTR(x)                  LIB_DBG_NAMESPACE(dbg_lib, dbg_mql_api_retval_ptr).msg(LIB_DBG_NAMESPACE(dbg_lib, dbg_StringFormat)("%*s%s", LIB_DBG_NAMESPACE(dbg_lib, trace_call_depth) * 2, "", LIB_DBG_NAMESPACE(dbg_lib, dbg_StringFormat)(DBG_OUTPUT_PREFIX + DBG_OUTPUT_PREFIX + DBG_OUTPUT_FORMAT("", (LIB_DBG_NAMESPACE(dbg_lib, dbg_StringFormat)("%s => %s() %s", "MQL5-API Function", #x, "%s")))))) = x

    #else
        #define DBG_MSG_MQLFUNC(x)                      DBG_MSG_MQLAPI(LIB_DBG_NAMESPACE(dbg_lib, dbg_StringFormat)((LIB_DBG_NAMESPACE(dbg_lib, trace_api_calls)) ? "MQL4-API Function => %s() [void]" : "", #x)); } x
        #define DBG_MSG_MQLFUNC_RETURN(x)               LIB_DBG_NAMESPACE(dbg_lib, dbg_mql_api_retval).msg(LIB_DBG_NAMESPACE(dbg_lib, dbg_StringFormat)("%*s%s", LIB_DBG_NAMESPACE(dbg_lib, trace_call_depth) * 2, "", LIB_DBG_NAMESPACE(dbg_lib, dbg_StringFormat)(DBG_OUTPUT_PREFIX + DBG_OUTPUT_PREFIX + DBG_OUTPUT_FORMAT("", (LIB_DBG_NAMESPACE(dbg_lib, dbg_StringFormat)("%s => %s() %s", "MQL4-API Function", #x, "%s")))))) = x
        #define DBG_MSG_MQLFUNC_PTR(x)                  LIB_DBG_NAMESPACE(dbg_lib, dbg_mql_api_retval_ptr).msg(LIB_DBG_NAMESPACE(dbg_lib, dbg_StringFormat)("%*s%s", LIB_DBG_NAMESPACE(dbg_lib, trace_call_depth) * 2, "", LIB_DBG_NAMESPACE(dbg_lib, dbg_StringFormat)(DBG_OUTPUT_PREFIX + DBG_OUTPUT_PREFIX + DBG_OUTPUT_FORMAT("", (LIB_DBG_NAMESPACE(dbg_lib, dbg_StringFormat)("%s => %s() %s", "MQL4-API Function", #x, "%s")))))) = x

    #endif

    // Code tracing helpers
    #ifndef __MQL4_COMPATIBILITY_CODE__
        #define DBG_MSG_TRACE_BEGIN                     static ulong dbg_lib_func_call_count = NULL; { LIB_DBG_NAMESPACE(dbg_lib, trace_api_calls) = true; LIB_DBG_NAMESPACE(dbg_lib, trace_call_depth)++; printf("\r\n%*s%s", LIB_DBG_NAMESPACE(dbg_lib, trace_call_depth )* 2, "", LIB_DBG_NAMESPACE(dbg_lib, dbg_StringFormat)(DBG_OUTPUT_PREFIX + DBG_OUTPUT_FORMAT(DBG_TRACE_BEGIN_MSG_TXT, LIB_DBG_NAMESPACE(dbg_lib, dbg_StringFormat)(DBG_OUTPUT_TRACE_BEGIN_FORMAT, LIB_DBG_NAMESPACE(dbg_lib, dbg_ChartID)(), dbg_lib::trace_call_depth, __FUNCTION__, ++dbg_lib_func_call_count)))); }
        #define DBG_MSG_TRACE_END                       { LIB_DBG_NAMESPACE(dbg_lib, dbg_printf)("%*s%s", LIB_DBG_NAMESPACE(dbg_lib, trace_call_depth) * 2, "", LIB_DBG_NAMESPACE(dbg_lib, dbg_StringFormat)(DBG_OUTPUT_PREFIX + DBG_OUTPUT_FORMAT(DBG_TRACE_END_MSG_TXT, LIB_DBG_NAMESPACE(dbg_lib, dbg_StringFormat)(DBG_OUTPUT_TRACE_END_FORMAT, dbg_lib::trace_call_depth, __FUNCTION__)))); printf("%s", " "); dbg_lib::trace_call_depth--; DBG_TRACE_EXEC_DELAY; LIB_DBG_NAMESPACE(dbg_lib, trace_api_calls) = LIB_DBG_API_CALL_TRACE_DEFAULT; }

    #else
        #define DBG_MSG_TRACE_BEGIN                     static ulong dbg_lib_func_call_count = NULL; { LIB_DBG_NAMESPACE(dbg_lib, trace_api_calls) = true; LIB_DBG_NAMESPACE(dbg_lib, trace_call_depth)++; printf("\r\n%"+ LIB_DBG_NAMESPACE(dbg_lib, dbg_IntegerToString)(LIB_DBG_NAMESPACE(dbg_lib, trace_call_depth )* 2) +"s%s", "", LIB_DBG_NAMESPACE(dbg_lib, dbg_StringFormat)(DBG_OUTPUT_PREFIX + DBG_OUTPUT_FORMAT(DBG_TRACE_BEGIN_MSG_TXT, LIB_DBG_NAMESPACE(dbg_lib, dbg_StringFormat)(DBG_OUTPUT_TRACE_BEGIN_FORMAT, LIB_DBG_NAMESPACE(dbg_lib, dbg_ChartID)(), LIB_DBG_NAMESPACE(dbg_lib, trace_call_depth), __FUNCTION__, ++dbg_lib_func_call_count)))); }
        #define DBG_MSG_TRACE_END                       { LIB_DBG_NAMESPACE(dbg_lib, dbg_printf)("%"+ LIB_DBG_NAMESPACE(dbg_lib, dbg_IntegerToString)(LIB_DBG_NAMESPACE(dbg_lib, trace_call_depth) * 2) +"s%s", "", LIB_DBG_NAMESPACE(dbg_lib, dbg_StringFormat)(DBG_OUTPUT_PREFIX + DBG_OUTPUT_FORMAT(DBG_TRACE_END_MSG_TXT, LIB_DBG_NAMESPACE(dbg_lib, dbg_StringFormat)(DBG_OUTPUT_TRACE_END_FORMAT, dbg_lib::trace_call_depth, __FUNCTION__)))); printf("%s", " "); dbg_lib::trace_call_depth--; DBG_TRACE_EXEC_DELAY; LIB_DBG_NAMESPACE(dbg_lib, trace_api_calls) = LIB_DBG_API_CALL_TRACE_DEFAULT; }

    #endif
    #define DBG_MSG_TRACE_RETURN                        LIB_DBG_NAMESPACE(dbg_lib, trace_api_calls) = LIB_DBG_API_CALL_TRACE_DEFAULT; DBG_MSG("=> return(void)"); DBG_MSG_UNINIT_RESOLVER DBG_MSG_TRACE_END return
    #define DBG_MSG_TRACE_RETURN_VAR(x)                 LIB_DBG_NAMESPACE(dbg_lib, trace_api_calls) = LIB_DBG_API_CALL_TRACE_DEFAULT; DBG_MSG_UNINIT_RESOLVER return(LIB_DBG_NAMESPACE(dbg_lib, return_function_result)(#x, x, LIB_DBG_NAMESPACE(dbg_lib, dbg_StringFormat)(DBG_OUTPUT_PREFIX + DBG_OUTPUT_STRING, "%s", DBG_CODE_LOCATION_STRING, "%s"), __FUNCTION__))
    #define DBG_MSG_TRACE_RETURN_OBJ(x)                 LIB_DBG_NAMESPACE(dbg_lib, trace_api_calls) = LIB_DBG_API_CALL_TRACE_DEFAULT; DBG_MSG_UNINIT_RESOLVER LIB_DBG_NAMESPACE(dbg_lib, return_function_object)(#x, x, LIB_DBG_NAMESPACE(dbg_lib, dbg_StringFormat)(DBG_OUTPUT_PREFIX + DBG_OUTPUT_STRING, "%s", DBG_CODE_LOCATION_STRING, "%s"), __FUNCTION__); return(x)

    #define DBG_MSG_NOTRACE_RETURN                      return
    #define DBG_MSG_NOTRACE_RETURN_VAR(x)               return(x)
    #define DBG_MSG_NOTRACE_RETURN_OBJ(x)               return(x)

    // Debug comments
    #define DBG_SET_UNINIT_REASON(x)                    LIB_DBG_NAMESPACE(dbg_lib, dbg_uninit_reason) = x;
    #define DBG_UNINIT_REASON(x)                        LIB_DBG_NAMESPACE(dbg_lib, uninit_text)(__FUNCTION__, x);
    #define DBG_MSG_UNINIT_RESOLVER                     if(_StopFlag) { DBG_MSG_VAR(_StopFlag); } LIB_DBG_NAMESPACE(dbg_lib, uninit_text)(__FUNCTION__, -1);
    #define DBG_STR_COMMENT(cmnt)                       cmnt

    // File loading tracer
    #ifndef __MQL4_COMPATIBILITY_CODE__
        #define DBG_FILE_VARNAME(x)                     dbg_file_loader_##x
        #define DBG_MSG_TRACE_FILE_LOADER               static bool DBG_FILE_VARNAME(__COUNTER__) = LIB_DBG_NAMESPACE(dbg_lib, dbg_print_file_trace)(__FILE__);

    #else
        #define DBG_MSG_TRACE_FILE_LOADER

    #endif

    // Class and object polymorphism
    #define DBG_STR_OBJ_RTTI                            DBG_STR(LIB_DBG_NAMESPACE(dbg_lib, dbg_StringFormat)("%s %llu", typename_raw(this), &this))
    #define DBG_MSG_OBJ_RTTI                            DBG_MSG(LIB_DBG_NAMESPACE(dbg_lib, dbg_StringFormat)("%s %llu", typename_raw(this), &this))


    // Overloaded functions
    #ifndef LIB_DEBUG_NAMESPACE
        #ifndef __MQL4_COMPATIBILITY_CODE__
        namespace dbg_lib
        {
        #endif

            // MQL macro function replacement protection
            void                    LIB_DBG_NAMESPACE_DEF(dbg_lib, dbg_Alert)(const string p_in)                                                                                { Alert(p_in); }
            template <typename T>
            const int               LIB_DBG_NAMESPACE_DEF(dbg_lib, dbg_ArraySize)(const T& p_in[])                                                                              { return(ArraySize(p_in)); }
            template <typename T>
            void                    LIB_DBG_NAMESPACE_DEF(dbg_lib, dbg_ArrayPrint)(const T& p_in[], const int digits, const int start)                                          { ArrayPrint(p_in, digits, "", start); }
            const long              LIB_DBG_NAMESPACE_DEF(dbg_lib, dbg_ChartID)()                                                                                               { return(ChartID()); }
            const ulong             LIB_DBG_NAMESPACE_DEF(dbg_lib, dbg_GetMicrosecondCount)()                                                                                   { return(GetMicrosecondCount()); }
            const ulong             LIB_DBG_NAMESPACE_DEF(dbg_lib, dbg_GetTickCount)()                                                                                          { return(LIB_DBG_GETTICKCOUNT()); }
            const string            LIB_DBG_NAMESPACE_DEF(dbg_lib, dbg_ColorToString)(const color p_in, const bool color_name = false)                                          { return(ColorToString(p_in, color_name)); }
            const string            LIB_DBG_NAMESPACE_DEF(dbg_lib, dbg_IntegerToString)(const long p_in)                                                                        { return(IntegerToString(p_in)); }
            const long              LIB_DBG_NAMESPACE_DEF(dbg_lib, dbg_MQLInfoInteger)(const ENUM_MQL_INFO_INTEGER p_in)                                                        { return(MQLInfoInteger(p_in)); }
            const string            LIB_DBG_NAMESPACE_DEF(dbg_lib, dbg_MQLInfoString)(const ENUM_MQL_INFO_STRING p_in)                                                          { return(MQLInfoString(p_in)); }
            const int               LIB_DBG_NAMESPACE_DEF(dbg_lib, dbg_StringLen)(const string p_in)                                                                            { return(StringLen(p_in)); }
            const datetime          LIB_DBG_NAMESPACE_DEF(dbg_lib, dbg_StringToTime)(const string p_in)                                                                         { return(StringToTime(p_in)); }
            const long              LIB_DBG_NAMESPACE_DEF(dbg_lib, dbg_TerminalInfoInteger)(const ENUM_TERMINAL_INFO_INTEGER p_in)                                              { return(TerminalInfoInteger(p_in)); }
            const string            LIB_DBG_NAMESPACE_DEF(dbg_lib, dbg_TerminalInfoString)(const ENUM_TERMINAL_INFO_STRING p_in)                                                { return(TerminalInfoString(p_in)); }
            const datetime          LIB_DBG_NAMESPACE_DEF(dbg_lib, dbg_TimeCurrent)()                                                                                           { return(TimeCurrent()); }
            const string            LIB_DBG_NAMESPACE_DEF(dbg_lib, dbg_TimeToString)(const datetime val)                                                                        { const bool ms = ((val / TimeLocal()) > 100); datetime _val = val / ((ms) ? 1000 : 1); return(StringFormat("%s%s", TimeToString(_val, TIME_DATE | TIME_SECONDS), (ms) ? StringFormat(".%03i", val%1000) : "")); }
            const bool              LIB_DBG_NAMESPACE_DEF(dbg_lib, dbg_TimeToStruct)(const datetime dtm, MqlDateTime& tm)                                                       { return(TimeToStruct(dtm, tm)); }
            template <typename T>
            const string            LIB_DBG_NAMESPACE_DEF(dbg_lib, dbg_StringFormat)(const string p1, const T p2)                                                               { return(StringFormat(p1, p2)); }
            template <typename T, typename U>
            const string            LIB_DBG_NAMESPACE_DEF(dbg_lib, dbg_StringFormat)(const string p1, const T p2, const U p3)                                                   { return(StringFormat(p1, p2, p3)); }
            template <typename T, typename U, typename V>
            const string            LIB_DBG_NAMESPACE_DEF(dbg_lib, dbg_StringFormat)(const string p1, const T p2, const U p3, const V p4)                                       { return(StringFormat(p1, p2, p3, p4)); }
            template <typename T, typename U, typename V, typename W>
            const string            LIB_DBG_NAMESPACE_DEF(dbg_lib, dbg_StringFormat)(const string p1, const T p2, const U p3, const V p4, const W p5)                           { return(StringFormat(p1, p2, p3, p4, p5)); }
            template <typename T, typename U, typename V, typename W, typename X>
            const string            LIB_DBG_NAMESPACE_DEF(dbg_lib, dbg_StringFormat)(const string p1, const T p2, const U p3, const V p4, const W p5, const X p6)               { return(StringFormat(p1, p2, p3, p4, p5, p6)); }
            template <typename T, typename U, typename V, typename W, typename X, typename Y>
            const string            LIB_DBG_NAMESPACE_DEF(dbg_lib, dbg_StringFormat)(const string p1, const T p2, const U p3, const V p4, const W p5, const X p6, const Y p7)   { return(StringFormat(p1, p2, p3, p4, p5, p6, p7)); }
            const string            LIB_DBG_NAMESPACE_DEF(dbg_lib, dbg_typename_to_string)(const string p_in, const bool enum_no_resolve = false)                               { static string last_call = NULL; static string tmp = NULL; if(last_call == p_in) { return(tmp); } else if((enum_no_resolve) && ((StringFind(p_in, " enum ") != -1) || (StringFind(p_in, " ENUM ") != -1))) { return("enum"); } last_call = p_in; tmp = " " + p_in + " "; StringReplace(tmp, " const ", " "); StringReplace(tmp, " class ", " "); StringReplace(tmp, " struct ", " "); StringReplace(tmp, " interface ", " "); StringReplace(tmp, " static ", " "); StringReplace(tmp, " ENUM ", " "); StringReplace(tmp, " enum ", " "); tmp = StringSubstr(tmp, NULL, StringFind(tmp, "[")); StringReplace(tmp, " *", "*"); StringTrimLeft(tmp); StringTrimRight(tmp); return(tmp); }

            // Boolean return value print statement
            const bool              LIB_DBG_NAMESPACE_DEF(dbg_lib, dbg_eval_return)(const string msg, const bool retval, const bool _printf = true)                             { if(_printf) { LIB_DBG_NAMESPACE(dbg_lib, dbg_printf)(msg); } return(retval); }

            // Array index checking
            template <typename T>
            const T                 LIB_DBG_NAMESPACE_DEF(dbg_lib, dbg_eval_array_index)(const T& arr[], const int idx)                                                         { if(idx != -1) { return(arr[idx]); } return(NULL); }
            const int               LIB_DBG_NAMESPACE_DEF(dbg_lib, dbg_eval_array_index)(const int arr_size, const int idx, const string msg)                                   { if((idx >= arr_size) || (idx < NULL)) { LIB_DBG_NAMESPACE(dbg_lib, dbg_printf)(msg); return(-1); } return(idx); }

            // MQL Function return value message injection object
            static class pass_through
            { public:
                string _type;
                string _msg;
                pass_through() : _msg (NULL)                            { };
                pass_through(const pass_through& s)                     { _msg = s._msg; _type = s._type; }
                pass_through* msg(const string in, const string t_in)   { _type = t_in; _msg = in; ResetLastError(); return(GetPointer(this)); }
                template <typename T>
                const T operator=(T in)                                 {
                                                                            if(LIB_DBG_NAMESPACE(dbg_lib, trace_api_calls))
                                                                            {
                                                                                const int err_no = GetLastError();
                                                                                const string _typename = LIB_DBG_NAMESPACE(dbg_lib, dbg_typename_to_string)(typename(T), true);
                                                                                LIB_DBG_NAMESPACE(dbg_lib, dbg_printf)("%s", StringFormat(_msg, (err_no != ERR_SUCCESS) ? StringFormat("Error: %i", err_no) : ((StringFind(_type, _typename) == -1) ? StringFormat("Type mismatch. Expected: %s, Got: %s", _type, _typename) : LIB_DBG_NAMESPACE(dbg_lib, var_out)("returns", in, NULL, "", 45))));
                                                                                _msg = NULL;
                                                                            }
                                                                            return(in);
                                                                        }
            } LIB_DBG_NAMESPACE_DEF(dbg_lib, dbg_mql_api_retval);

            static class pass_through_ptr
            { public:
                string _msg;
                pass_through_ptr() : _msg (NULL)            { };
                pass_through_ptr(const pass_through_ptr& s) { _msg = s._msg; }
                pass_through_ptr msg(const string in)       { _msg = in; ResetLastError(); return(this); }
                template <typename T> T* operator=(T in)    {
                                                                if(LIB_DBG_NAMESPACE(dbg_lib, trace_api_calls))
                                                                {
                                                                    const int err_no = GetLastError();
                                                                    LIB_DBG_NAMESPACE(dbg_lib, dbg_printf)("%s", StringFormat(_msg, (err_no != ERR_SUCCESS) ? StringFormat("error: %i", err_no) : LIB_DBG_NAMESPACE(dbg_lib, var_out)("returns", in, NULL, "", 45)));
                                                                    _msg = NULL;
                                                                }
                                                                return(in);
                                                            }
            } LIB_DBG_NAMESPACE_DEF(dbg_lib, dbg_mql_api_retval_ptr);

            // Auto en/disable api call tracing
            static bool LIB_DBG_NAMESPACE_DEF(dbg_lib, trace_api_calls) = LIB_DBG_API_CALL_TRACE_DEFAULT;

            // Debug printf function
            void LIB_DBG_NAMESPACE_DEF(dbg_lib, dbg_printf)(const string p1)
            #ifndef __MQL4_COMPATIBILITY_CODE__
                {
                    #ifdef LIB_DBG_LOG_TO_FILE
                        LIB_DBG_NAMESPACE(dbg_lib, dbg_print_to_file)(p1);

                    #endif
                    #ifndef LIB_DBG_NO_JOURNAL
                        if((p1 != NULL) && (p1 != ""))
                        { printf(p1); }

                    #endif
                }

            #else
                {
                    static int ptr = NULL;
                    static string out_arr[];
                    if(LIB_DBG_NAMESPACE(dbg_lib, trace_api_calls))
                    {
                        ArrayResize(out_arr, ptr + 1);
                        out_arr[ptr] = p1;
                        ptr++;
                        return;
                    }

                    if(ptr != NULL)
                    {
                        #ifndef LIB_DBG_NO_JOURNAL
                            for(; (ptr > NULL) && !_StopFlag; ptr--) { printf(out_arr[ptr]); }
                        #endif
                        #ifdef LIB_DBG_LOG_TO_FILE
                            for(int cnt = NULL; (cnt <= ptr) && !_StopFlag; cnt++) { LIB_DBG_NAMESPACE(dbg_lib, dbg_print_to_file)(out_arr[cnt]); }

                        #endif
                        ptr = NULL;
                        ArrayFree(out_arr);
                        return;
                    }
                    #ifdef LIB_DBG_LOG_TO_FILE
                        LIB_DBG_NAMESPACE(dbg_lib, dbg_print_to_file)(p1);

                    #endif
                    #ifndef LIB_DBG_NO_JOURNAL
                        printf(p1);

                    #endif
                }

            #endif

            template <typename T>
            void LIB_DBG_NAMESPACE_DEF(dbg_lib, dbg_printf)(const string p1, const T p2)
            #ifndef __MQL4_COMPATIBILITY_CODE__
                {
                    #ifdef LIB_DBG_LOG_TO_FILE
                        LIB_DBG_NAMESPACE(dbg_lib, dbg_print_to_file)(StringFormat(p1, p2));

                    #endif
                    #ifndef LIB_DBG_NO_JOURNAL
                        if((p1 != NULL) && (p1 != ""))
                        { printf(p1, p2); }

                    #endif
                }

            #else
                {
                    static int ptr = NULL;
                    static string out_arr[];
                    if(LIB_DBG_NAMESPACE(dbg_lib, trace_api_calls))
                    {
                        ArrayResize(out_arr, ptr + 1);
                        out_arr[ptr] = StringFormat(p1, p2);
                        ptr++;
                        return;
                    }

                    if(ptr != NULL)
                    {
                        #ifndef LIB_DBG_NO_JOURNAL
                            for(; (ptr > NULL) && !_StopFlag; ptr--) { printf(out_arr[ptr]); }
                        #endif
                        #ifdef LIB_DBG_LOG_TO_FILE
                            for(int cnt = NULL; (cnt <= ptr) && !_StopFlag; cnt++) { LIB_DBG_NAMESPACE(dbg_lib, dbg_print_to_file)(out_arr[cnt]); }

                        #endif
                        ptr = NULL;
                        ArrayFree(out_arr);
                        return;
                    }
                    #ifdef LIB_DBG_LOG_TO_FILE
                        LIB_DBG_NAMESPACE(dbg_lib, dbg_print_to_file)(StringFormat(p1, p2));

                    #endif
                    #ifndef LIB_DBG_NO_JOURNAL
                        printf(p1, p2);

                    #endif
                }

            #endif

            template <typename T, typename U>
            void LIB_DBG_NAMESPACE_DEF(dbg_lib, dbg_printf)(const string p1, const T p2, const U p3)
            #ifndef __MQL4_COMPATIBILITY_CODE__
                {
                    #ifdef LIB_DBG_LOG_TO_FILE
                        LIB_DBG_NAMESPACE(dbg_lib, dbg_print_to_file)(StringFormat(p1, p2, p3));

                    #endif
                    #ifndef LIB_DBG_NO_JOURNAL
                        if((p1 != NULL) && (p1 != ""))
                        { printf(p1, p2, p3); }

                    #endif
                }

            #else
                {
                    static int ptr = NULL;
                    static string out_arr[];
                    if(LIB_DBG_NAMESPACE(dbg_lib, trace_api_calls))
                    {
                        ArrayResize(out_arr, ptr + 1);
                        out_arr[ptr] = StringFormat(p1, p2, p3);
                        ptr++;
                        return;
                    }

                    if(ptr != NULL)
                    {
                        #ifndef LIB_DBG_NO_JOURNAL
                            for(; (ptr > NULL) && !_StopFlag; ptr--) { printf(out_arr[ptr]); }

                        #endif
                        #ifdef LIB_DBG_LOG_TO_FILE
                            for(int cnt = NULL; (cnt <= ptr) && !_StopFlag; cnt++) { LIB_DBG_NAMESPACE(dbg_lib, dbg_print_to_file)(out_arr[cnt]); }

                        #endif
                        ptr = NULL;
                        ArrayFree(out_arr);
                        return;
                    }
                    #ifdef LIB_DBG_LOG_TO_FILE
                        LIB_DBG_NAMESPACE(dbg_lib, dbg_print_to_file)(StringFormat(p1, p2, p3));

                    #endif
                    #ifndef LIB_DBG_NO_JOURNAL
                        printf(p1, p2, p3);

                    #endif
                }

            #endif

            template <typename T, typename U, typename V>
            void LIB_DBG_NAMESPACE_DEF(dbg_lib, dbg_printf)(const string p1, const T p2, const U p3, const V p4)
            #ifndef __MQL4_COMPATIBILITY_CODE__
                {
                    #ifdef LIB_DBG_LOG_TO_FILE
                        LIB_DBG_NAMESPACE(dbg_lib, dbg_print_to_file)(StringFormat(p1, p2, p3, p4));

                    #endif
                    #ifndef DBG_NO_JOURNAL_OUTPUT
                        if((p1 != NULL) && (p1 != ""))
                        { printf(p1, p2, p3, p4); }

                    #endif
                }

            #else
                {
                    static int ptr = NULL;
                    static string out_arr[];
                    if(LIB_DBG_NAMESPACE(dbg_lib, trace_api_calls))
                    {
                        ArrayResize(out_arr, ptr + 1);
                        out_arr[ptr] = StringFormat(p1, p2, p3, p4);
                        ptr++;
                        return;
                    }

                    if(ptr != NULL)
                    {
                        #ifndef LIB_DBG_NO_JOURNAL
                            for(; (ptr > NULL) && !_StopFlag; ptr--) { printf(out_arr[ptr]); }

                        #endif
                        #ifdef LIB_DBG_LOG_TO_FILE
                            for(int cnt = NULL; (cnt <= ptr) && !_StopFlag; cnt++) { LIB_DBG_NAMESPACE(dbg_lib, dbg_print_to_file)(out_arr[cnt]); }

                        #endif
                        ptr = NULL;
                        ArrayFree(out_arr);
                        return;
                    }
                    #ifdef LIB_DBG_LOG_TO_FILE
                        LIB_DBG_NAMESPACE(dbg_lib, dbg_print_to_file)(StringFormat(p1, p2, p3, p4));

                    #endif
                    #ifndef LIB_DBG_NO_JOURNAL
                        printf(p1, p2, p3, p4);

                    #endif
                }

            #endif

            template <typename T, typename U, typename V, typename W>
            void LIB_DBG_NAMESPACE_DEF(dbg_lib, dbg_printf)(const string p1, const T p2, const U p3, const V p4, const W p5)
            #ifndef __MQL4_COMPATIBILITY_CODE__
                {
                    #ifdef LIB_DBG_LOG_TO_FILE
                        LIB_DBG_NAMESPACE(dbg_lib, dbg_print_to_file)(StringFormat(p1, p2, p3, p4, p5));

                    #endif
                    #ifndef DBG_NO_JOURNAL_OUTPUT
                        if((p1 != NULL) && (p1 != ""))
                        { printf(p1, p2, p3, p4, p5); }

                    #endif
                }

            #else
                {
                    static int ptr = NULL;
                    static string out_arr[];
                    if(LIB_DBG_NAMESPACE(dbg_lib, trace_api_calls))
                    {
                        ArrayResize(out_arr, ptr + 1);
                        out_arr[ptr] = StringFormat(p1, p2, p3, p4, p5);
                        ptr++;
                        return;
                    }

                    if(ptr != NULL)
                    {
                        #ifndef LIB_DBG_NO_JOURNAL
                            for(; (ptr > NULL) && !_StopFlag; ptr--) { printf(out_arr[ptr]); }

                        #endif
                        #ifdef LIB_DBG_LOG_TO_FILE
                            for(int cnt = NULL; (cnt <= ptr) && !_StopFlag; cnt++) { LIB_DBG_NAMESPACE(dbg_lib, dbg_print_to_file)(out_arr[cnt]); }

                        #endif
                        ptr = NULL;
                        ArrayFree(out_arr);
                        return;
                    }
                    #ifdef LIB_DBG_LOG_TO_FILE
                        LIB_DBG_NAMESPACE(dbg_lib, dbg_print_to_file)(StringFormat(p1, p2, p3, p4, p5));

                    #endif
                    #ifndef LIB_DBG_NO_JOURNAL
                        printf(p1, p2, p3, p4, p5);

                    #endif
                }

            #endif
            template <typename T, typename U, typename V, typename W, typename X>
            void LIB_DBG_NAMESPACE_DEF(dbg_lib, dbg_printf)(const string p1, const T p2, const U p3, const V p4, const W p5, const X p6)
            #ifndef __MQL4_COMPATIBILITY_CODE__
                {
                    #ifdef LIB_DBG_LOG_TO_FILE
                        LIB_DBG_NAMESPACE(dbg_lib, dbg_print_to_file)(StringFormat(p1, p2, p3, p4, p5, p6));

                    #endif
                    #ifndef DBG_NO_JOURNAL_OUTPUT
                        if((p1 != NULL) && (p1 != ""))
                        { printf(p1, p2, p3, p4, p5, p6); }

                    #endif
                }

            #else
                {
                    static int ptr = NULL;
                    static string out_arr[];
                    if(LIB_DBG_NAMESPACE(dbg_lib, trace_api_calls))
                    {
                        ArrayResize(out_arr, ptr + 1);
                        out_arr[ptr] = StringFormat(p1, p2, p3, p4, p5, p6);
                        ptr++;
                        return;
                    }

                    if(ptr != NULL)
                    {
                        #ifndef LIB_DBG_NO_JOURNAL
                            for(; (ptr > NULL) && !_StopFlag; ptr--) { printf(out_arr[ptr]); }

                        #endif
                        #ifdef LIB_DBG_LOG_TO_FILE
                            for(int cnt = NULL; (cnt <= ptr) && !_StopFlag; cnt++) { LIB_DBG_NAMESPACE(dbg_lib, dbg_print_to_file)(out_arr[cnt]); }

                        #endif
                        ptr = NULL;
                        ArrayFree(out_arr);
                        return;
                    }
                    #ifdef LIB_DBG_LOG_TO_FILE
                        LIB_DBG_NAMESPACE(dbg_lib, dbg_print_to_file)(StringFormat(p1, p2, p3, p4, p5, p6));

                    #endif
                    #ifndef LIB_DBG_NO_JOURNAL
                        printf(p1, p2, p3, p4, p5, p6);

                    #endif
                }

            #endif
            template <typename T, typename U, typename V, typename W, typename X, typename Y>
            void LIB_DBG_NAMESPACE_DEF(dbg_lib, dbg_printf)(const string p1, const T p2, const U p3, const V p4, const W p5, const X p6, const Y p7)
            #ifndef __MQL4_COMPATIBILITY_CODE__
                {
                    #ifdef LIB_DBG_LOG_TO_FILE
                        LIB_DBG_NAMESPACE(dbg_lib, dbg_print_to_file)(StringFormat(p1, p2, p3, p4, p5, p6, p7));

                    #endif
                    #ifndef DBG_NO_JOURNAL_OUTPUT
                        if((p1 != NULL) && (p1 != ""))
                        { printf(p1, p2, p3, p4, p5, p6, p7); }

                    #endif
                }

            #else
                {
                    static int ptr = NULL;
                    static string out_arr[];
                    if(LIB_DBG_NAMESPACE(dbg_lib, trace_api_calls))
                    {
                        ArrayResize(out_arr, ptr + 1);
                        out_arr[ptr] = StringFormat(p1, p2, p3, p4, p5, p6, p7);
                        ptr++;
                        return;
                    }

                    if(ptr != NULL)
                    {
                        #ifndef LIB_DBG_NO_JOURNAL
                            for(; (ptr > NULL) && !_StopFlag; ptr--) { printf(out_arr[ptr]); }

                        #endif
                        #ifdef LIB_DBG_LOG_TO_FILE
                            for(int cnt = NULL; (cnt <= ptr) && !_StopFlag; cnt++) { LIB_DBG_NAMESPACE(dbg_lib, dbg_print_to_file)(out_arr[cnt]); }

                        #endif
                        ptr = NULL;
                        ArrayFree(out_arr);
                        return;
                    }
                    #ifdef LIB_DBG_LOG_TO_FILE
                        LIB_DBG_NAMESPACE(dbg_lib, dbg_print_to_file)(StringFormat(p1, p2, p3, p4, p5, p6, p7));

                    #endif
                    #ifndef LIB_DBG_NO_JOURNAL
                        printf(p1, p2, p3, p4, p5, p6, p7);

                    #endif
                }

            #endif
            template <typename T, typename U, typename V, typename W, typename X, typename Y, typename Z>
            void LIB_DBG_NAMESPACE_DEF(dbg_lib, dbg_printf)(const string p1, const T p2, const U p3, const V p4, const W p5, const X p6, const Y p7, const Z p8)
            #ifndef __MQL4_COMPATIBILITY_CODE__
                {
                    #ifdef LIB_DBG_LOG_TO_FILE
                        LIB_DBG_NAMESPACE(dbg_lib, dbg_print_to_file)(StringFormat(p1, p2, p3, p4, p5, p6, p7, p8));

                    #endif
                    #ifndef DBG_NO_JOURNAL_OUTPUT
                        if((p1 != NULL) && (p1 != ""))
                        { printf(p1, p2, p3, p4, p5, p6, p7, p8); }

                    #endif
                }

            #else
                {
                    static int ptr = NULL;
                    static string out_arr[];
                    if(LIB_DBG_NAMESPACE(dbg_lib, trace_api_calls))
                    {
                        ArrayResize(out_arr, ptr + 1);
                        out_arr[ptr] = StringFormat(p1, p2, p3, p4, p5, p6, p7, p8);
                        ptr++;
                        return;
                    }

                    if(ptr != NULL)
                    {
                        #ifndef LIB_DBG_NO_JOURNAL
                            for(; (ptr > NULL) && !_StopFlag; ptr--) { printf(out_arr[ptr]); }

                        #endif
                        #ifdef LIB_DBG_LOG_TO_FILE
                            for(int cnt = NULL; (cnt <= ptr) && !_StopFlag; cnt++) { LIB_DBG_NAMESPACE(dbg_lib, dbg_print_to_file)(out_arr[cnt]); }

                        #endif
                        ptr = NULL;
                        ArrayFree(out_arr);
                        return;
                    }
                    #ifdef LIB_DBG_LOG_TO_FILE
                        LIB_DBG_NAMESPACE(dbg_lib, dbg_print_to_file)(StringFormat(p1, p2, p3, p4, p5, p6, p7, p8));

                    #endif
                    #ifndef LIB_DBG_NO_JOURNAL
                        printf(p1, p2, p3, p4, p5, p6, p7, p8);

                    #endif
                }

            #endif

            // Self destructing file handle
            #ifdef LIB_DBG_LOG_TO_FILE
                struct __dbg_file_handle { int obj; __dbg_file_handle() : obj(INVALID_HANDLE) { obj = FileOpen(DBG_LOG_FILENAME, FILE_COMMON | FILE_TXT | FILE_ANSI | FILE_WRITE | FILE_SHARE_READ, CP_ACP); }; ~__dbg_file_handle() { if(obj != INVALID_HANDLE) { FileClose(obj); } } } __dbg_f_h;
                void LIB_DBG_NAMESPACE_DEF(dbg_lib, dbg_print_to_file)(const string out)
                { FileWriteString(__dbg_f_h.obj, out + "\r\n", StringLen(out)); FileFlush(__dbg_f_h.obj); }

            #endif

            // Debug get true system time
            const datetime  LIB_DBG_NAMESPACE_DEF(dbg_lib, dbg_true_system_time)()
            {
                if(FileIsExist("time.tmp", FILE_COMMON))
                { FileDelete("time.tmp", FILE_COMMON); }
                const int f_h = FileOpen("time.tmp", FILE_COMMON | FILE_WRITE, CP_ACP);
                const datetime tm = (f_h != INVALID_HANDLE) ? (datetime)FileGetInteger(f_h, FILE_CREATE_DATE) : LIB_DBG_NAMESPACE(dbg_lib, dbg_TimeCurrent)();
                FileClose(f_h);
                FileDelete("time.tmp", FILE_COMMON);
                return(tm);
            }

            // Debug file loader trace function
            const bool      LIB_DBG_NAMESPACE_DEF(dbg_lib, dbg_print_file_trace)(const string _file)            { static int cnt = NULL; LIB_DBG_NAMESPACE(dbg_lib, dbg_printf)("Loaded file: %s, count: %i", _file, cnt + 1); cnt++; return(true); }

            // Debug code variables
            static ulong    LIB_DBG_NAMESPACE_DEF(dbg_lib, dbg_session_id)      = LIB_DBG_GETTICKCOUNT();
            static int      LIB_DBG_NAMESPACE_DEF(dbg_lib, dbg_uninit_reason)   = -1;
            static int      LIB_DBG_NAMESPACE_DEF(dbg_lib, trace_call_depth)    = NULL;

            // Helpers
            const string    LIB_DBG_NAMESPACE_DEF(dbg_lib, flt_raw)(const float in)                             { union conv { float f;  uint u; }  c; c.f = in; return(StringFormat("0x%08X", c.u)); }
            const string    LIB_DBG_NAMESPACE_DEF(dbg_lib, dbl_raw)(const double in)                            { union conv { double d; ulong u; } c; c.d = in; return(StringFormat("0x%016llX", c.u)); }
            const string    LIB_DBG_NAMESPACE_DEF(dbg_lib, dbg_remove_leading_namespace)(const string in)       { const int shift = (StringFind(in, "::", 0) == 0) ? 2 : 0; return((StringLen(in) > DBG_PRINT_VARNAME_MAX_LENGTH + shift) ? StringSubstr(in, shift, DBG_PRINT_VARNAME_MAX_LENGTH - 10 + shift) + "..." : StringSubstr(in, shift)); }

            // Return value of function call
            template <typename T>
            const T         LIB_DBG_NAMESPACE_DEF(dbg_lib, dbg_return_val)(const string name, const T value)    { LIB_DBG_NAMESPACE(dbg_lib, dbg_printf)("%*s%s", LIB_DBG_NAMESPACE(dbg_lib, trace_call_depth) * 2, "", LIB_DBG_NAMESPACE(dbg_lib, dbg_StringFormat)(DBG_OUTPUT_PREFIX + DBG_OUTPUT_PREFIX + DBG_OUTPUT_FORMAT("", (LIB_DBG_NAMESPACE(dbg_lib, var_out)(name, value, DBG_MSG_SHIFT))))); return(value); }

            // Value to string helpers
            const string    LIB_DBG_NAMESPACE_DEF(dbg_lib, dbg_to_string)(const char        val)                { return(StringFormat("%hd",            val)); }
            const string    LIB_DBG_NAMESPACE_DEF(dbg_lib, dbg_to_string)(const short       val)                { return(StringFormat("%hi",            val)); }
            const string    LIB_DBG_NAMESPACE_DEF(dbg_lib, dbg_to_string)(const int         val)                { return(StringFormat("%i",             val)); }
            const string    LIB_DBG_NAMESPACE_DEF(dbg_lib, dbg_to_string)(const long        val)                { return(StringFormat("%lli",           val)); }
            const string    LIB_DBG_NAMESPACE_DEF(dbg_lib, dbg_to_string)(const uchar       val)                { return(StringFormat("%hu",            val)); }
            const string    LIB_DBG_NAMESPACE_DEF(dbg_lib, dbg_to_string)(const ushort      val)                { return(StringFormat("%hu",            val)); }
            const string    LIB_DBG_NAMESPACE_DEF(dbg_lib, dbg_to_string)(const uint        val)                { return(StringFormat("%u",             val)); }
            const string    LIB_DBG_NAMESPACE_DEF(dbg_lib, dbg_to_string)(const ulong       val)                { return(StringFormat("%llu",           val)); }
            const string    LIB_DBG_NAMESPACE_DEF(dbg_lib, dbg_to_string)(const string      val)                { return(StringFormat("%s",             val)); }
            const string    LIB_DBG_NAMESPACE_DEF(dbg_lib, dbg_to_string)(const float       val)                { return(StringFormat("%." + IntegerToString(DBG_FLOAT_OUTPUT_DIGITS)   + ((val > (1.0 / MathPow(10, DBG_FLOAT_OUTPUT_DIGITS)) && (val < MathPow(10, DBG_FLOAT_OUTPUT_DIGITS))) ? "f" : "g"),   val)); }
            const string    LIB_DBG_NAMESPACE_DEF(dbg_lib, dbg_to_string)(const double      val)                { return(StringFormat("%." + IntegerToString(DBG_DOUBLE_OUTPUT_DIGITS)  + ((val > (1.0 / MathPow(10, DBG_DOUBLE_OUTPUT_DIGITS)) && (val < MathPow(10, DBG_DOUBLE_OUTPUT_DIGITS))) ? "f" : "g"), val)); }
            const string    LIB_DBG_NAMESPACE_DEF(dbg_lib, dbg_to_string)(const datetime    val)                { return(StringFormat("%s",             TimeToString(val))); }
            const string    LIB_DBG_NAMESPACE_DEF(dbg_lib, dbg_to_string)(const color       val)                { return(StringFormat("%s",             ColorToString(val, true))); }
            const string    LIB_DBG_NAMESPACE_DEF(dbg_lib, dbg_to_string)(const bool        val)                { return(StringFormat("%s",             val ? "true" : "false")); }

        #ifdef LIB_DBG_INCLUDE_COMPLEX_TYPE
            const string    LIB_DBG_NAMESPACE_DEF(dbg_lib, dbg_to_string)(const complex     val)                { return(StringFormat("r:%g;i:%g",      val.real, val.imag)); }
            const string    LIB_DBG_NAMESPACE_DEF(dbg_lib, dbg_to_string)(const matrix&     val)                { return(StringFormat("%s, line: %i",   "Not implemented: lib_debug.mqh", __LINE__)); }
            const string    LIB_DBG_NAMESPACE_DEF(dbg_lib, dbg_to_string)(const vector&     val)                { return(StringFormat("%s, line: %i",   "Not implemented: lib_debug.mqh", __LINE__)); }

        #endif
            const string    LIB_DBG_NAMESPACE_DEF(dbg_lib, dbg_day_of_week)(const datetime  val)                { MqlDateTime tm; LIB_DBG_NAMESPACE(dbg_lib, dbg_TimeToStruct)(val / (((val / TimeLocal()) > 100) ? 1000 : 1), tm); switch(tm.day_of_week) { case 0: return("Sunday"); case 1: return("Monday"); case 2: return("Tuesday"); case 3: return("Wednesday"); case 4: return("Thursday"); case 5: return("Friday"); case 6: return("Saturday"); } return(NULL); }

            // Basic types
            const string    LIB_DBG_NAMESPACE_DEF(dbg_lib, var_out)(const string name, const char                   val,    const int shift = 0, const string   prefix = "",    const int offset = 0, const bool hex = true)      { return(StringFormat("%s[chr]  %-" + IntegerToString(60 - ((offset < 60) ? offset : NULL)) + "s = %-25hd '%s' (%s)",     prefix, LIB_DBG_NAMESPACE(dbg_lib, dbg_remove_leading_namespace)(name), val, ShortToString(val),    (hex) ? StringFormat("0x%02hX", (uchar)val)    : LIB_DBG_NAMESPACE(dbg_lib, bits_out)((uchar)val))); }
            const string    LIB_DBG_NAMESPACE_DEF(dbg_lib, var_out)(const string name, const short                  val,    const int shift = 0, const string   prefix = "",    const int offset = 0, const bool hex = true)      { return(StringFormat("%s[shrt] %-" + IntegerToString(60 - ((offset < 60) ? offset : NULL)) + "s = %-25hi '%s' (%s)",     prefix, LIB_DBG_NAMESPACE(dbg_lib, dbg_remove_leading_namespace)(name), val, ShortToString(val),    (hex) ? StringFormat("0x%04hX", val)           : LIB_DBG_NAMESPACE(dbg_lib, bits_out)((ushort)val))); }
            const string    LIB_DBG_NAMESPACE_DEF(dbg_lib, var_out)(const string name, const int                    val,    const int shift = 0, const string   prefix = "",    const int offset = 0, const bool hex = true)      { return(StringFormat("%s[int]  %-" + IntegerToString(60 - ((offset < 60) ? offset : NULL)) + "s = %-25i (%s)",           prefix, LIB_DBG_NAMESPACE(dbg_lib, dbg_remove_leading_namespace)(name), val,                        (hex) ? StringFormat("0x%08X", val)            : LIB_DBG_NAMESPACE(dbg_lib, bits_out)((uint)val))); }
            const string    LIB_DBG_NAMESPACE_DEF(dbg_lib, var_out)(const string name, const long                   val,    const int shift = 0, const string   prefix = "",    const int offset = 0, const bool hex = true)      { return(StringFormat("%s[long] %-" + IntegerToString(60 - ((offset < 60) ? offset : NULL)) + "s = %-25lli (%s)",         prefix, LIB_DBG_NAMESPACE(dbg_lib, dbg_remove_leading_namespace)(name), val,                        (hex) ? StringFormat("0x%016llX", val)         : LIB_DBG_NAMESPACE(dbg_lib, bits_out)((ulong)val))); }
            const string    LIB_DBG_NAMESPACE_DEF(dbg_lib, var_out)(const string name, const uchar                  val,    const int shift = 0, const string   prefix = "",    const int offset = 0, const bool hex = true)      { return(StringFormat("%s[uchr] %-" + IntegerToString(60 - ((offset < 60) ? offset : NULL)) + "s = %-25hu '%s' (%s)",     prefix, LIB_DBG_NAMESPACE(dbg_lib, dbg_remove_leading_namespace)(name), val, ShortToString(val),    (hex) ? StringFormat("0x%02hX", val)           : LIB_DBG_NAMESPACE(dbg_lib, bits_out)(val))); }
            const string    LIB_DBG_NAMESPACE_DEF(dbg_lib, var_out)(const string name, const ushort                 val,    const int shift = 0, const string   prefix = "",    const int offset = 0, const bool hex = true)      { return(StringFormat("%s[usht] %-" + IntegerToString(60 - ((offset < 60) ? offset : NULL)) + "s = %-25hu '%s' (%s)",     prefix, LIB_DBG_NAMESPACE(dbg_lib, dbg_remove_leading_namespace)(name), val, ShortToString(val),    (hex) ? StringFormat("0x%04hX", val)           : LIB_DBG_NAMESPACE(dbg_lib, bits_out)(val))); }
            const string    LIB_DBG_NAMESPACE_DEF(dbg_lib, var_out)(const string name, const uint                   val,    const int shift = 0, const string   prefix = "",    const int offset = 0, const bool hex = true)      { return(StringFormat("%s[uint] %-" + IntegerToString(60 - ((offset < 60) ? offset : NULL)) + "s = %-25u (%s)",           prefix, LIB_DBG_NAMESPACE(dbg_lib, dbg_remove_leading_namespace)(name), val,                        (hex) ? StringFormat("0x%08X", val)            : LIB_DBG_NAMESPACE(dbg_lib, bits_out)(val))); }
            const string    LIB_DBG_NAMESPACE_DEF(dbg_lib, var_out)(const string name, const ulong                  val,    const int shift = 0, const string   prefix = "",    const int offset = 0, const bool hex = true)      { return(StringFormat("%s[ul]   %-" + IntegerToString(60 - ((offset < 60) ? offset : NULL)) + "s = %-25llu (%s)",         prefix, LIB_DBG_NAMESPACE(dbg_lib, dbg_remove_leading_namespace)(name), val,                        (hex) ? StringFormat("0x%016llX", val)         : LIB_DBG_NAMESPACE(dbg_lib, bits_out)(val))); }
            const string    LIB_DBG_NAMESPACE_DEF(dbg_lib, var_out)(const string name, const string                 val,    const int shift = 0, const string   prefix = "",    const int offset = 0)                             { const string dbg_len = StringFormat("length: %i", StringLen(val));
                                                                                                                                                                                                                                    return(StringFormat("%s[str]  %-" + IntegerToString(60 - ((offset < 60) ? offset : NULL)) + "s = '%s' (%s)",            prefix, LIB_DBG_NAMESPACE(dbg_lib, dbg_remove_leading_namespace)(name), (val == NULL) ? "NULL" : ((val == "") ? "" : val), dbg_len)); }
            const string    LIB_DBG_NAMESPACE_DEF(dbg_lib, var_out)(const string name, const float                  val,    const int shift = 0, const string   prefix = "",    const int offset = 0)                             { return(StringFormat("%s[flt]  %-" + IntegerToString(60 - ((offset < 60) ? offset : NULL)) + "s = %-25s (%s)",           prefix, LIB_DBG_NAMESPACE(dbg_lib, dbg_remove_leading_namespace)(name), StringFormat("%." + IntegerToString(DBG_FLOAT_OUTPUT_DIGITS)  + ((val > (1.0 / MathPow(10, DBG_FLOAT_OUTPUT_DIGITS))) ? "f" : "g"), val), LIB_DBG_NAMESPACE_DEF(dbg_lib, flt_raw)(val))); }
            const string    LIB_DBG_NAMESPACE_DEF(dbg_lib, var_out)(const string name, const double                 val,    const int shift = 0, const string   prefix = "",    const int offset = 0)                             { return(StringFormat("%s[dbl]  %-" + IntegerToString(60 - ((offset < 60) ? offset : NULL)) + "s = %-25s (%s)",           prefix, LIB_DBG_NAMESPACE(dbg_lib, dbg_remove_leading_namespace)(name), StringFormat("%." + IntegerToString(DBG_DOUBLE_OUTPUT_DIGITS) + ((val > (1.0 / MathPow(10, DBG_DOUBLE_OUTPUT_DIGITS))) ? "f" : "g"), val), LIB_DBG_NAMESPACE_DEF(dbg_lib, dbl_raw)(val))); }
            const string    LIB_DBG_NAMESPACE_DEF(dbg_lib, var_out)(const string name, const bool                   val,    const int shift = 0, const string   prefix = "",    const int offset = 0)                             { return(StringFormat("%s[bool] %-" + IntegerToString(60 - ((offset < 60) ? offset : NULL)) + "s = %s",                   prefix, LIB_DBG_NAMESPACE(dbg_lib, dbg_remove_leading_namespace)(name), (val) ? "true" : "false")); }
            const string    LIB_DBG_NAMESPACE_DEF(dbg_lib, var_out)(const string name, const datetime               val,    const int shift = 0, const string   prefix = "",    const int offset = 0)                             { return(StringFormat("%s[dtm]  %-" + IntegerToString(60 - ((offset < 60) ? offset : NULL)) + "s = %s %s %s",             prefix, LIB_DBG_NAMESPACE(dbg_lib, dbg_remove_leading_namespace)(name), (val == NULL) ? "NULL" : ((val < NULL) ? StringFormat("[NEGATIVE VALUE] %lli", val) : ((StringLen(LIB_DBG_NAMESPACE(dbg_lib, dbg_TimeToString)(val)) <= NULL) ? StringFormat("[NON DATE VALUE] %llu", val) : LIB_DBG_NAMESPACE(dbg_lib, dbg_TimeToString)(val))), (val <= NULL) ? "" : LIB_DBG_NAMESPACE(dbg_lib, dbg_day_of_week)(val), (val > NULL) && (val < 31536000) ? StringFormat("(long: %lli)", (long)val) : "")); }
            const string    LIB_DBG_NAMESPACE_DEF(dbg_lib, var_out)(const string name, const color                  val,    const int shift = 0, const string   prefix = "",    const int offset = 0, const bool hex = true)      { return(StringFormat("%s[clr]  %-" + IntegerToString(60 - ((offset < 60) ? offset : NULL)) + "s = %-25s (%s)",           prefix, LIB_DBG_NAMESPACE(dbg_lib, dbg_remove_leading_namespace)(name), ColorToString(val, true),   (hex) ? StringFormat("0x%08X", val)            : LIB_DBG_NAMESPACE(dbg_lib, bits_out)((uint)val))); }

            // Pointers
            template <typename T>
            const string    LIB_DBG_NAMESPACE_DEF(dbg_lib, var_out)(const string name, const T*                     val,    const int shift = 0, const string   prefix = "",    const int offset = 0)                             { return(StringFormat("%s[ptr]  %-" + IntegerToString(60 - ((offset < 60) ? offset : NULL)) + "s = '%s'",                 prefix, LIB_DBG_NAMESPACE(dbg_lib, dbg_remove_leading_namespace)(name), (val == NULL) ? StringFormat("ptr: NULL (%s)", typename_raw(val)) : ((CheckPointer(val) != POINTER_INVALID) ? typename_raw(val) : StringFormat("POINTER_INVALID (%s)", typename_raw(val))))); }

            // Enumerations and unknown types
            template <typename T>
            const string    LIB_DBG_NAMESPACE_DEF(dbg_lib, var_out)(const string name, T&                           val,    const int shift = 0, const string   prefix = "",    const int offset = 0)                             { return(StringFormat("%s[obj]  %-" + IntegerToString(60 - ((offset < 60) ? offset : NULL)) + "s = '%s'",                 prefix, LIB_DBG_NAMESPACE(dbg_lib, dbg_remove_leading_namespace)(name), typename(val))); }

            // Enumerations 
//            template <typename T>
//            const string    LIB_DBG_NAMESPACE_DEF(dbg_lib, var_out)(const string name, const T                      val,    const int shift = 0, const string   prefix = "",    const int offset = 0)                             { const string _name = LIB_DBG_NAMESPACE(dbg_lib, dbg_remove_leading_namespace)(name); string enum_val = EnumToString((T)val); StringReplace(enum_val, typename_raw(val), ""); const int idx = StringFind(_name, typename_raw(val));
//                                                                                                                                                                                                                                    return(StringFormat("%s[enum] %-" + IntegerToString(60 - ((offset < 60) ? offset : NULL)) + "s = %-25s (0x%08X) [%s]",  prefix, LIB_DBG_NAMESPACE(dbg_lib, dbg_remove_leading_namespace)(_name), enum_val, (uint)(val), (idx != -1) ? "Unknown enum" : typename_raw(val))); }

            // Unknown objects
            const string    LIB_DBG_NAMESPACE_DEF(dbg_lib, obj_out)(const string name, const string type_name,              const int shift = 0, const string   prefix = "",    const int offset = 0)                             { return(StringFormat("%s[obj]  %-" + IntegerToString(60 - ((offset < 60) ? offset : NULL)) + "s = '%s'",                 prefix, LIB_DBG_NAMESPACE(dbg_lib, dbg_remove_leading_namespace)(name), type_name)); }


            // Arrays
            template <typename T>
            const string    LIB_DBG_NAMESPACE_DEF(dbg_lib, var_out)(const string name, const T&                     val[],  const int shift = 0, const string   prefix = "",    const int offset = 0)
            {
                string _name = LIB_DBG_NAMESPACE(dbg_lib, dbg_remove_leading_namespace)(name); StringReplace(_name, ")", "");
                const string _shift = StringFormat("%" + IntegerToString(shift) + "s", "");
                const int elements = ArraySize(val);
                string __out = (elements > NULL) ? StringFormat("[arr]  (Size: %i) = {", elements) : StringFormat("[arr]  %-" + IntegerToString(60 - ((offset < 60) ? offset : NULL)) + "s = %-25s", typename_raw(val), "{ EMPTY_ARRAY }");
                for(int cnt = NULL; (cnt < elements) && (!_StopFlag); cnt++)
                { __out += "\n" + _shift + LIB_DBG_NAMESPACE(dbg_lib, var_out)(StringFormat("%s[%i])", _name, cnt), val[cnt], shift, prefix); cnt = ((elements > 7) && (cnt > 3) && (cnt < (elements - 3))) ? (elements - 3) : cnt; }
                return(__out); }

            // Complex types
        #ifdef LIB_DBG_INCLUDE_COMPLEX_TYPE
            const string    LIB_DBG_NAMESPACE_DEF(dbg_lib, var_out)(const string name, const complex&               val,    const int shift = 0, const string   prefix = "",    const int offset = 0)                             { return(StringFormat("%s[cplx] %-" + IntegerToString(60 - ((offset < 60) ? offset : NULL)) + "s = %-25s %s (r:%s i:%s)", prefix, LIB_DBG_NAMESPACE(dbg_lib, dbg_remove_leading_namespace)(name), StringFormat("r:%." + IntegerToString(DBG_DOUBLE_OUTPUT_DIGITS) + ((val.real > (1.0 / MathPow(10, DBG_DOUBLE_OUTPUT_DIGITS))) ? "f" : "g"), val.real), StringFormat("i:%." + IntegerToString(DBG_DOUBLE_OUTPUT_DIGITS) + ((val.imag > (1.0 / MathPow(10, DBG_DOUBLE_OUTPUT_DIGITS))) ? "f" : "g"), val.imag), LIB_DBG_NAMESPACE_DEF(dbg_lib, dbl_raw)(val.real), LIB_DBG_NAMESPACE_DEF(dbg_lib, dbl_raw)(val.imag))); }
            const string    LIB_DBG_NAMESPACE_DEF(dbg_lib, var_out)(const string name, const vector&                val,    const int shift = 0, const string   _prefix = "",   const int offset = 0)
            {
                const string _shift = StringFormat("%" + IntegerToString(shift) + "s", "");
                const string prefix = (_prefix == "") ? StringFormat("{ %s }", typename_raw(val)) : _prefix;
                const ulong v_size = val.Size();
                if(v_size == NULL)
                { return(StringFormat("%s[vct]  %-" + IntegerToString(60 - ((offset < 60) ? offset : NULL)) + "s = { EMPTY_VECTOR }", prefix, LIB_DBG_NAMESPACE(dbg_lib, dbg_remove_leading_namespace)(name))); }
                string dbg_out = StringFormat("%s\n", LIB_DBG_NAMESPACE(dbg_lib, var_out)(name + "[0]", val[0], NULL, prefix));
                for(ulong cnt = 1; (cnt < v_size); cnt++) { dbg_out += StringFormat("%s%s%s", _shift, LIB_DBG_NAMESPACE(dbg_lib, var_out)(StringFormat("%s[%llu]", name, cnt), val[(int)cnt], NULL, prefix), (cnt < v_size - 1) ? "\n" : ""); }
                return(dbg_out); }
            const string    LIB_DBG_NAMESPACE_DEF(dbg_lib, var_out)(const string name, const vectorf&               val,    const int shift = 0, const string   _prefix = "",   const int offset = 0)
            {
                const string _shift = StringFormat("%" + IntegerToString(shift) + "s", "");
                const string prefix = (_prefix == "") ? StringFormat("{ %s }", typename_raw(val)) : _prefix;
                const ulong v_size = val.Size();
                if(v_size == NULL)
                { return(StringFormat("%s[vct]  %-" + IntegerToString(60 - ((offset < 60) ? offset : NULL)) + "s = { EMPTY_VECTOR }", prefix, LIB_DBG_NAMESPACE(dbg_lib, dbg_remove_leading_namespace)(name))); }
                string dbg_out = StringFormat("%s\n", LIB_DBG_NAMESPACE(dbg_lib, var_out)(name + "[0]", val[0], NULL, prefix));
                for(ulong cnt = 1; (cnt < v_size); cnt++) { dbg_out += StringFormat("%s%s%s", _shift, LIB_DBG_NAMESPACE(dbg_lib, var_out)(StringFormat("%s[%llu]", name, cnt), val[(int)cnt], NULL, prefix), (cnt < v_size - 1) ? "\n" : ""); }
                return(dbg_out); }
            const string    LIB_DBG_NAMESPACE_DEF(dbg_lib, var_out)(const string name, const vectorc&               val,    const int shift = 0, const string   _prefix = "",   const int offset = 0)
            {
                const string _shift = StringFormat("%" + IntegerToString(shift) + "s", "");
                const string prefix = (_prefix == "") ? StringFormat("{ %s }", typename_raw(val)) : _prefix;
                const ulong v_size = val.Size();
                if(v_size == NULL)
                { return(StringFormat("%s[vct]  %-" + IntegerToString(60 - ((offset < 60) ? offset : NULL)) + "s = { EMPTY_VECTOR }", prefix, LIB_DBG_NAMESPACE(dbg_lib, dbg_remove_leading_namespace)(name))); }
                string dbg_out = StringFormat("%s\n", LIB_DBG_NAMESPACE(dbg_lib, var_out)(name + "[0]", val[0], NULL, prefix));
                for(ulong cnt = 1; (cnt < v_size); cnt++) { dbg_out += StringFormat("%s%s%s", _shift, LIB_DBG_NAMESPACE(dbg_lib, var_out)(StringFormat("%s[%llu]", name, cnt), val[(int)cnt], NULL, prefix), (cnt < v_size - 1) ? "\n" : ""); }
                return(dbg_out); }
            const string    LIB_DBG_NAMESPACE_DEF(dbg_lib, var_out)(const string name, const matrix&                val,    const int shift = 0, const string   _prefix = "",   const int offset = 0)
            {
                const string _shift = StringFormat("%" + IntegerToString(shift) + "s", "");
                const string prefix = (_prefix == "") ? StringFormat("{ %s }", typename_raw(val)) : _prefix;
                const ulong m_rows = val.Rows();
                const ulong m_cols = val.Cols();
                if(val.Rows() + val.Cols() <= NULL)
                { return(StringFormat("%s[mtx]  %-" + IntegerToString(60 - ((offset < 60) ? offset : NULL)) + "s = { EMPTY_MATRIX }", prefix, LIB_DBG_NAMESPACE(dbg_lib, dbg_remove_leading_namespace)(name))); }
                const int val_out_len = MathMax(StringLen(LIB_DBG_NAMESPACE(dbg_lib, dbg_to_string)(val.Max())), StringLen(LIB_DBG_NAMESPACE(dbg_lib, dbg_to_string)(val.Min())));
                string dbg_out = StringFormat("%s[mtx]  %s =\n", prefix, LIB_DBG_NAMESPACE(dbg_lib, dbg_remove_leading_namespace)(name));
                dbg_out += StringFormat("%" + IntegerToString(StringLen(_shift) + 9 + (long)(log10(m_rows) + 1)) + "s", "");
                for(ulong cnt = NULL; (cnt < m_cols); cnt++)
                { dbg_out += StringFormat("%" + IntegerToString(val_out_len + 2) + "s", StringFormat("[][%i]  ", cnt)); }
                dbg_out += "\n";
                for(ulong row = NULL; (row < m_rows); row++)
                {
                    vector v = val.Row(row);
                    dbg_out += StringFormat("%" + IntegerToString(StringLen(_shift) + 9 + (long)(log10(m_rows) + 1)) + "s", StringFormat("[%i][]: { ", row));
                    for(ulong col = NULL; (col < m_cols); col++)
                    { dbg_out += StringFormat("%" + IntegerToString(val_out_len + ((col < (m_cols - 1)) ? 2 : 0)) + "s", StringFormat("%s", LIB_DBG_NAMESPACE(dbg_lib, dbg_to_string)(v[col]) + ((col < (m_cols - 1)) ? ", " : ""))); }
                    dbg_out += " }" + ((row < (m_rows - 1)) ? ",\n" : "");
                }
                return(dbg_out); }
            const string    LIB_DBG_NAMESPACE_DEF(dbg_lib, var_out)(const string name, const matrixf&               val,    const int shift = 0, const string   _prefix = "",   const int offset = 0)
            {
                const string _shift = StringFormat("%" + IntegerToString(shift) + "s", "");
                const string prefix = (_prefix == "") ? StringFormat("{ %s }", typename_raw(val)) : _prefix;
                const ulong m_rows = val.Rows();
                const ulong m_cols = val.Cols();
                if(val.Rows() + val.Cols() <= NULL)
                { return(StringFormat("%s[mtx]  %-" + IntegerToString(60 - ((offset < 60) ? offset : NULL)) + "s = { EMPTY_MATRIX }", prefix, LIB_DBG_NAMESPACE(dbg_lib, dbg_remove_leading_namespace)(name))); }
                const int val_out_len = MathMax(StringLen(LIB_DBG_NAMESPACE(dbg_lib, dbg_to_string)(val.Max())), StringLen(LIB_DBG_NAMESPACE(dbg_lib, dbg_to_string)(val.Min())));
                string dbg_out = StringFormat("%s[mtx]  %s =\n", prefix, LIB_DBG_NAMESPACE(dbg_lib, dbg_remove_leading_namespace)(name));
                dbg_out += StringFormat("%" + IntegerToString(StringLen(_shift) + 9 + (long)(log10(m_rows) + 1)) + "s", "");
                for(ulong cnt = NULL; (cnt < m_cols); cnt++)
                { dbg_out += StringFormat("%" + IntegerToString(val_out_len + 2) + "s", StringFormat("[][%i]  ", cnt)); }
                dbg_out += "\n";
                for(ulong row = NULL; (row < m_rows); row++)
                {
                    vectorf v = val.Row(row);
                    dbg_out += StringFormat("%" + IntegerToString(StringLen(_shift) + 9 + (long)(log10(m_rows) + 1)) + "s", StringFormat("[%i][]: { ", row));
                    for(ulong col = NULL; (col < m_cols); col++)
                    { dbg_out += StringFormat("%" + IntegerToString(val_out_len + ((col < (m_cols - 1)) ? 2 : 0)) + "s", StringFormat("%s", LIB_DBG_NAMESPACE(dbg_lib, dbg_to_string)(v[col]) + ((col < (m_cols - 1)) ? ", " : ""))); }
                    dbg_out += " }" + ((row < (m_rows - 1)) ? ",\n" : "");
                }
                return(dbg_out); }
            const string    LIB_DBG_NAMESPACE_DEF(dbg_lib, var_out)(const string name, const matrixc&               val,    const int shift = 0, const string   _prefix = "",   const int offset = 0)
            {
                const string _shift = StringFormat("%" + IntegerToString(shift) + "s", "");
                const string prefix = (_prefix == "") ? StringFormat("{ %s }", typename_raw(val)) : _prefix;
                const ulong m_rows = val.Rows();
                const ulong m_cols = val.Cols();
                if(val.Rows() + val.Cols() <= NULL)
                { return(StringFormat("%s[mtx]  %-" + IntegerToString(60 - ((offset < 60) ? offset : NULL)) + "s = { EMPTY_MATRIX }", prefix, LIB_DBG_NAMESPACE(dbg_lib, dbg_remove_leading_namespace)(name))); }
                const int val_out_len = StringLen(LIB_DBG_NAMESPACE(dbg_lib, dbg_to_string)(val.Row(0)[0])) + 5;
                string dbg_out = StringFormat("%s[mtx]  %s =\n", prefix, LIB_DBG_NAMESPACE(dbg_lib, dbg_remove_leading_namespace)(name));
                dbg_out += StringFormat("%" + IntegerToString(StringLen(_shift) + 9 + (long)(log10(m_rows) + 1)) + "s", "");
                for(ulong cnt = NULL; (cnt < m_cols); cnt++)
                { dbg_out += StringFormat("%" + IntegerToString(val_out_len + 2) + "s", StringFormat("[][%i]  ", cnt)); }
                dbg_out += "\n";
                for(ulong row = NULL; (row < m_rows); row++)
                {
                    vectorc v = val.Row(row);
                    dbg_out += StringFormat("%" + IntegerToString(StringLen(_shift) + 9 + (long)(log10(m_rows) + 1)) + "s", StringFormat("[%i][]: { ", row));
                    for(ulong col = NULL; (col < m_cols); col++)
                    { dbg_out += StringFormat("%" + IntegerToString(val_out_len + ((col < (m_cols - 1)) ? 2 : 0)) + "s", StringFormat("%s", LIB_DBG_NAMESPACE(dbg_lib, dbg_to_string)(v[col]) + ((col < (m_cols - 1)) ? ", " : ""))); }
                    dbg_out += " }" + ((row < (m_rows - 1)) ? ",\n" : "");
                }
                return(dbg_out); }

        #endif
            // Mql types
            const string    LIB_DBG_NAMESPACE_DEF(dbg_lib, var_out)(const string _name, const MqlDateTime&          val,    const int shift = 0, const string   _prefix = "",   const int offset = 0)
            {
                const string name = " " + _name;
                const string _shift = StringFormat("%" + IntegerToString(shift) + "s", "");
                const string prefix = (_prefix == "") ? StringFormat("{ %s }", typename_raw(val)) : _prefix;
                return(StringFormat(" {\n%s%s\n%s%s\n%s%s\n%s%s\n%s%s\n%s%s\n%s%s\n%s%s",
                        _shift, LIB_DBG_NAMESPACE(dbg_lib, var_out)(name + ".year",                 val.year,               NULL, prefix),
                        _shift, LIB_DBG_NAMESPACE(dbg_lib, var_out)(name + ".mon",                  val.mon,                NULL, prefix),
                        _shift, LIB_DBG_NAMESPACE(dbg_lib, var_out)(name + ".day",                  val.day,                NULL, prefix),
                        _shift, LIB_DBG_NAMESPACE(dbg_lib, var_out)(name + ".hour",                 val.hour,               NULL, prefix),
                        _shift, LIB_DBG_NAMESPACE(dbg_lib, var_out)(name + ".min",                  val.min,                NULL, prefix),
                        _shift, LIB_DBG_NAMESPACE(dbg_lib, var_out)(name + ".sec",                  val.sec,                NULL, prefix),
                        _shift, LIB_DBG_NAMESPACE(dbg_lib, var_out)(name + ".day_of_week",          val.day_of_week,        NULL, prefix),
                        _shift, LIB_DBG_NAMESPACE(dbg_lib, var_out)(name + ".day_of_year",          val.day_of_year,        NULL, prefix)
                        )); }
            const string    LIB_DBG_NAMESPACE_DEF(dbg_lib, var_out)(const string _name, const MqlRates&                 val,    const int shift = 0, const string   _prefix = "",   const int offset = 0)
            {
                const string name = " " + _name;
                const string _shift = StringFormat("%" + IntegerToString(shift) + "s", "");
                const string prefix = (_prefix == "") ? StringFormat("{ %s }", typename_raw(val)) : _prefix;
                return(StringFormat(" {\n%s%s\n%s%s\n%s%s\n%s%s\n%s%s\n%s%s\n%s%s\n%s%s",
                        _shift, LIB_DBG_NAMESPACE(dbg_lib, var_out)(name + ".time",                 val.time,               NULL, prefix),
                        _shift, LIB_DBG_NAMESPACE(dbg_lib, var_out)(name + ".open",                 val.open,               NULL, prefix),
                        _shift, LIB_DBG_NAMESPACE(dbg_lib, var_out)(name + ".high",                 val.high,               NULL, prefix),
                        _shift, LIB_DBG_NAMESPACE(dbg_lib, var_out)(name + ".low",                  val.low,                NULL, prefix),
                        _shift, LIB_DBG_NAMESPACE(dbg_lib, var_out)(name + ".close",                val.close,              NULL, prefix),
                        _shift, LIB_DBG_NAMESPACE(dbg_lib, var_out)(name + ".tick_volume",          val.tick_volume,        NULL, prefix),
                        _shift, LIB_DBG_NAMESPACE(dbg_lib, var_out)(name + ".spread",               val.spread,             NULL, prefix),
                        _shift, LIB_DBG_NAMESPACE(dbg_lib, var_out)(name + ".real_volume",          val.real_volume,        NULL, prefix)
                        )); }
            const string    LIB_DBG_NAMESPACE_DEF(dbg_lib, var_out)(const string _name, const MqlTick&              val,    const int shift = 0, const string   _prefix = "",   const int offset = 0)
            {
                const string name = " " + _name;
                const string _shift = StringFormat("%" + IntegerToString(shift) + "s", "");
                const string prefix = (_prefix == "") ? StringFormat("{ %s }", typename_raw(val)) : _prefix;
                return(
                    #ifndef __MQL4_COMPATIBILITY_CODE__
                        StringFormat(" {\n%s%s\n%s%s\n%s%s\n%s%s\n%s%s\n%s%s\n%s%s\n%s%s",

                    #else
                        StringFormat(" {\n%s%s\n%s%s\n%s%s\n%s%s\n%s%s",

                    #endif
                        _shift, LIB_DBG_NAMESPACE(dbg_lib, var_out)(name + ".time",                 val.time,               NULL, prefix),
                        _shift, LIB_DBG_NAMESPACE(dbg_lib, var_out)(name + ".bid",                  val.bid,                NULL, prefix),
                        _shift, LIB_DBG_NAMESPACE(dbg_lib, var_out)(name + ".ask",                  val.ask,                NULL, prefix),
                        _shift, LIB_DBG_NAMESPACE(dbg_lib, var_out)(name + ".last",                 val.last,               NULL, prefix),
                        _shift, LIB_DBG_NAMESPACE(dbg_lib, var_out)(name + ".volume",               val.volume,             NULL, prefix)
                    #ifndef __MQL4_COMPATIBILITY_CODE__
                      , _shift, LIB_DBG_NAMESPACE(dbg_lib, var_out)(name + ".time_msc",   (datetime)val.time_msc,           NULL, prefix),
                        _shift, LIB_DBG_NAMESPACE(dbg_lib, var_out)(name + ".flags",         (uchar)val.flags,              NULL, prefix, NULL, false),
                        _shift, LIB_DBG_NAMESPACE(dbg_lib, var_out)(name + ".volume_real",          val.volume_real,        NULL, prefix)

                    #endif
                        )); }
        #ifndef __MQL4_COMPATIBILITY_CODE__
            const string    LIB_DBG_NAMESPACE_DEF(dbg_lib, var_out)(const string _name, const MqlParam&                 val, const int shift = 0, const string      _prefix = "",   const int offset = 0)
            {
                const string name = " " + _name;
                const string _shift = StringFormat("%" + IntegerToString(shift) + "s", "");
                const string prefix = (_prefix == "") ? StringFormat("{ %s }", typename_raw(val)) : _prefix;
                return(StringFormat(" {\n%s%s\n%s%s\n%s%s\n%s%s",
                        _shift, LIB_DBG_NAMESPACE(dbg_lib, var_out)(name + ".type",                 val.type,               NULL, prefix),
                        _shift, LIB_DBG_NAMESPACE(dbg_lib, var_out)(name + ".integer_value",        val.integer_value,      NULL, prefix),
                        _shift, LIB_DBG_NAMESPACE(dbg_lib, var_out)(name + ".double_value",         val.double_value,       NULL, prefix),
                        _shift, LIB_DBG_NAMESPACE(dbg_lib, var_out)(name + ".string_value",         val.string_value,       NULL, prefix)
                        )); }
            const string    LIB_DBG_NAMESPACE_DEF(dbg_lib, var_out)(const string _name, const MqlBookInfo&          val, const int shift = 0, const string      _prefix = "",   const int offset = 0)
            {
                const string name = " " + _name;
                const string _shift = StringFormat("%" + IntegerToString(shift) + "s", "");
                const string prefix = (_prefix == "") ? StringFormat("{ %s }", typename_raw(val)) : _prefix;
                return(StringFormat(" {\n%s%s\n%s%s\n%s%s\n%s%s",
                        _shift, LIB_DBG_NAMESPACE(dbg_lib, var_out)(name + ".type",                 val.type,               NULL, prefix),
                        _shift, LIB_DBG_NAMESPACE(dbg_lib, var_out)(name + ".price",                val.price,              NULL, prefix),
                        _shift, LIB_DBG_NAMESPACE(dbg_lib, var_out)(name + ".volume",               val.volume,             NULL, prefix),
                        _shift, LIB_DBG_NAMESPACE(dbg_lib, var_out)(name + ".volume_real",          val.volume_real,        NULL, prefix)
                        )); }
            const string    LIB_DBG_NAMESPACE_DEF(dbg_lib, var_out)(const string _name, const MqlTradeRequest&      val, const int shift = 0, const string      _prefix = "",   const int offset = 0)
            {
                const string name = " " + _name;
                const string _shift = StringFormat("%" + IntegerToString(shift) + "s", "");
                const string prefix = (_prefix == "") ? StringFormat("{%s }", typename_raw(val)) : _prefix;
                return(StringFormat(" {\n%s%s\n%s%s\n%s%s\n%s%s\n%s%s\n%s%s\n%s%s\n%s%s\n%s%s\n%s%s\n%s%s\n%s%s\n%s%s\n%s%s\n%s%s\n%s%s\n%s%s",
                        _shift, LIB_DBG_NAMESPACE(dbg_lib, var_out)(name + ".action",               val.action,             NULL, prefix),
                        _shift, LIB_DBG_NAMESPACE(dbg_lib, var_out)(name + ".magic",                val.magic,              NULL, prefix),
                        _shift, LIB_DBG_NAMESPACE(dbg_lib, var_out)(name + ".order",                val.order,              NULL, prefix),
                        _shift, LIB_DBG_NAMESPACE(dbg_lib, var_out)(name + ".symbol",               val.symbol,             NULL, prefix),
                        _shift, LIB_DBG_NAMESPACE(dbg_lib, var_out)(name + ".volume",               val.volume,             NULL, prefix),
                        _shift, LIB_DBG_NAMESPACE(dbg_lib, var_out)(name + ".price",                val.price,              NULL, prefix),
                        _shift, LIB_DBG_NAMESPACE(dbg_lib, var_out)(name + ".stoplimit",            val.stoplimit,          NULL, prefix),
                        _shift, LIB_DBG_NAMESPACE(dbg_lib, var_out)(name + ".sl",                   val.sl,                 NULL, prefix),
                        _shift, LIB_DBG_NAMESPACE(dbg_lib, var_out)(name + ".tp",                   val.tp,                 NULL, prefix),
                        _shift, LIB_DBG_NAMESPACE(dbg_lib, var_out)(name + ".deviation",            val.deviation,          NULL, prefix),
                        _shift, LIB_DBG_NAMESPACE(dbg_lib, var_out)(name + ".type",                 val.type,               NULL, prefix),
                        _shift, LIB_DBG_NAMESPACE(dbg_lib, var_out)(name + ".type_filling",         val.type_filling,       NULL, prefix),
                        _shift, LIB_DBG_NAMESPACE(dbg_lib, var_out)(name + ".type_time",            val.type_time,          NULL, prefix),
                        _shift, LIB_DBG_NAMESPACE(dbg_lib, var_out)(name + ".expiration",           val.expiration,         NULL, prefix),
                        _shift, LIB_DBG_NAMESPACE(dbg_lib, var_out)(name + ".comment",              val.comment,            NULL, prefix),
                        _shift, LIB_DBG_NAMESPACE(dbg_lib, var_out)(name + ".position",             val.position,           NULL, prefix),
                        _shift, LIB_DBG_NAMESPACE(dbg_lib, var_out)(name + ".position_by",          val.position_by,        NULL, prefix)
                        )); }
            const string    LIB_DBG_NAMESPACE_DEF(dbg_lib, var_out)(const string _name, const MqlTradeCheckResult&  val, const int shift = 0, const string      _prefix = "",   const int offset = 0)
            {
                const string name = " " + _name;
                const string _shift = StringFormat("%" + IntegerToString(shift) + "s", "");
                const string prefix = (_prefix == "") ? StringFormat("{ %s }", typename_raw(val)) : _prefix;
                return(StringFormat(" {\n%s%s\n%s%s\n%s%s\n%s%s\n%s%s\n%s%s\n%s%s\n%s%s",
                        _shift, LIB_DBG_NAMESPACE(dbg_lib, var_out)(name + ".retcode",              val.retcode,            NULL, prefix),
                        _shift, LIB_DBG_NAMESPACE(dbg_lib, var_out)(name + ".balance",              val.balance,            NULL, prefix),
                        _shift, LIB_DBG_NAMESPACE(dbg_lib, var_out)(name + ".equity",               val.equity,             NULL, prefix),
                        _shift, LIB_DBG_NAMESPACE(dbg_lib, var_out)(name + ".profit",               val.profit,             NULL, prefix),
                        _shift, LIB_DBG_NAMESPACE(dbg_lib, var_out)(name + ".margin",               val.margin,             NULL, prefix),
                        _shift, LIB_DBG_NAMESPACE(dbg_lib, var_out)(name + ".margin_free",          val.margin_free,        NULL, prefix),
                        _shift, LIB_DBG_NAMESPACE(dbg_lib, var_out)(name + ".margin_level",         val.margin_level,       NULL, prefix),
                        _shift, LIB_DBG_NAMESPACE(dbg_lib, var_out)(name + ".comment",              val.comment,            NULL, prefix)
                        )); }
            const string    LIB_DBG_NAMESPACE_DEF(dbg_lib, var_out)(const string _name, const MqlTradeResult&       val, const int shift = 0, const string      _prefix = "",   const int offset = 0)
            {
                const string name = " " + _name;
                const string _shift = StringFormat("%" + IntegerToString(shift) + "s", "");
                const string prefix = (_prefix == "") ? StringFormat("{ %s }", typename_raw(val)) : _prefix;
                return(StringFormat(" {\n%s%s\n%s%s\n%s%s\n%s%s\n%s%s\n%s%s\n%s%s\n%s%s\n%s%s\n%s%s",
                        _shift, LIB_DBG_NAMESPACE(dbg_lib, var_out)(name + ".retcode",              val.retcode,            NULL, prefix),
                        _shift, LIB_DBG_NAMESPACE(dbg_lib, var_out)(name + ".deal",                 val.deal,               NULL, prefix),
                        _shift, LIB_DBG_NAMESPACE(dbg_lib, var_out)(name + ".order",                val.order,              NULL, prefix),
                        _shift, LIB_DBG_NAMESPACE(dbg_lib, var_out)(name + ".volume",               val.volume,             NULL, prefix),
                        _shift, LIB_DBG_NAMESPACE(dbg_lib, var_out)(name + ".price",                val.price,              NULL, prefix),
                        _shift, LIB_DBG_NAMESPACE(dbg_lib, var_out)(name + ".bid",                  val.bid,                NULL, prefix),
                        _shift, LIB_DBG_NAMESPACE(dbg_lib, var_out)(name + ".ask",                  val.ask,                NULL, prefix),
                        _shift, LIB_DBG_NAMESPACE(dbg_lib, var_out)(name + ".comment",              val.comment,            NULL, prefix),
                        _shift, LIB_DBG_NAMESPACE(dbg_lib, var_out)(name + ".request_id",           val.request_id,         NULL, prefix),
                        _shift, LIB_DBG_NAMESPACE(dbg_lib, var_out)(name + ".retcode_external",     val.retcode_external,   NULL, prefix)
                        )); }
            const string    LIB_DBG_NAMESPACE_DEF(dbg_lib, var_out)(const string _name, const MqlTradeTransaction&  val, const int shift = 0, const string      _prefix = "",   const int offset = 0)
            {
                const string name = " " + _name;
                const string _shift = StringFormat("%" + IntegerToString(shift) + "s", "");
                const string prefix = (_prefix == "") ? StringFormat("{ %s }", typename_raw(val)) : _prefix;
                return(StringFormat(" {\n%s%s\n%s%s\n%s%s\n%s%s\n%s%s\n%s%s\n%s%s\n%s%s\n%s%s\n%s%s\n%s%s\n%s%s\n%s%s\n%s%s\n%s%s\n%s%s",
                        _shift, LIB_DBG_NAMESPACE(dbg_lib, var_out)(name + ".deal",                 val.deal,               NULL, prefix),
                        _shift, LIB_DBG_NAMESPACE(dbg_lib, var_out)(name + ".order",                val.order,              NULL, prefix),
                        _shift, LIB_DBG_NAMESPACE(dbg_lib, var_out)(name + ".symbol",               val.symbol,             NULL, prefix),
                        _shift, LIB_DBG_NAMESPACE(dbg_lib, var_out)(name + ".type",                 val.type,               NULL, prefix),
                        _shift, LIB_DBG_NAMESPACE(dbg_lib, var_out)(name + ".order_type",           val.order_type,         NULL, prefix),
                        _shift, LIB_DBG_NAMESPACE(dbg_lib, var_out)(name + ".order_state",          val.order_state,        NULL, prefix),
                        _shift, LIB_DBG_NAMESPACE(dbg_lib, var_out)(name + ".deal_type",            val.deal_type,          NULL, prefix),
                        _shift, LIB_DBG_NAMESPACE(dbg_lib, var_out)(name + ".time_type",            val.time_type,          NULL, prefix),
                        _shift, LIB_DBG_NAMESPACE(dbg_lib, var_out)(name + ".time_expiration",      val.time_expiration,    NULL, prefix),
                        _shift, LIB_DBG_NAMESPACE(dbg_lib, var_out)(name + ".price",                val.price,              NULL, prefix),
                        _shift, LIB_DBG_NAMESPACE(dbg_lib, var_out)(name + ".price_trigger",        val.price_trigger,      NULL, prefix),
                        _shift, LIB_DBG_NAMESPACE(dbg_lib, var_out)(name + ".price_sl",             val.price_sl,           NULL, prefix),
                        _shift, LIB_DBG_NAMESPACE(dbg_lib, var_out)(name + ".price_tp",             val.price_tp,           NULL, prefix),
                        _shift, LIB_DBG_NAMESPACE(dbg_lib, var_out)(name + ".volume",               val.volume,             NULL, prefix),
                        _shift, LIB_DBG_NAMESPACE(dbg_lib, var_out)(name + ".position",             val.position,           NULL, prefix),
                        _shift, LIB_DBG_NAMESPACE(dbg_lib, var_out)(name + ".position_by",          val.position_by,        NULL, prefix)
                        )); }
            const string    LIB_DBG_NAMESPACE_DEF(dbg_lib, var_out)(const string _name, const MqlCalendarCountry&   val, const int shift = 0, const string      _prefix = "",   const int offset = 0)
            {
                const string name = " " + _name;
                const string _shift = StringFormat("%" + IntegerToString(shift) + "s", "");
                const string prefix = (_prefix == "") ? StringFormat("{ %s }", typename_raw(val)) : _prefix;
                return(StringFormat(" {\n%s%s\n%s%s\n%s%s\n%s%s\n%s%s\n%s%s",
                        _shift, LIB_DBG_NAMESPACE(dbg_lib, var_out)(name + ".id",                   val.id,                 NULL, prefix),
                        _shift, LIB_DBG_NAMESPACE(dbg_lib, var_out)(name + ".name",                 val.name,               NULL, prefix),
                        _shift, LIB_DBG_NAMESPACE(dbg_lib, var_out)(name + ".code",                 val.code,               NULL, prefix),
                        _shift, LIB_DBG_NAMESPACE(dbg_lib, var_out)(name + ".currency",             val.currency,           NULL, prefix),
                        _shift, LIB_DBG_NAMESPACE(dbg_lib, var_out)(name + ".currency_symbol",      val.currency_symbol,    NULL, prefix),
                        _shift, LIB_DBG_NAMESPACE(dbg_lib, var_out)(name + ".url_name",             val.url_name,           NULL, prefix)
                        )); }
            const string    LIB_DBG_NAMESPACE_DEF(dbg_lib, var_out)(const string _name, const MqlCalendarEvent&         val, const int shift = 0, const string      _prefix = "",   const int offset = 0)
            {
                const string name = " " + _name;
                const string _shift = StringFormat("%" + IntegerToString(shift) + "s", "");
                const string prefix = (_prefix == "") ? StringFormat("{ %s }", typename_raw(val)) : _prefix;
                return(StringFormat(" {\n%s%s\n%s%s\n%s%s\n%s%s\n%s%s\n%s%s\n%s%s\n%s%s\n%s%s\n%s%s\n%s%s\n%s%s\n%s%s",
                        _shift, LIB_DBG_NAMESPACE(dbg_lib, var_out)(name + ".id",                   val.id,                 NULL, prefix),
                        _shift, LIB_DBG_NAMESPACE(dbg_lib, var_out)(name + ".type",                 val.type,               NULL, prefix),
                        _shift, LIB_DBG_NAMESPACE(dbg_lib, var_out)(name + ".sector",               val.sector,             NULL, prefix),
                        _shift, LIB_DBG_NAMESPACE(dbg_lib, var_out)(name + ".frequency",            val.frequency,          NULL, prefix),
                        _shift, LIB_DBG_NAMESPACE(dbg_lib, var_out)(name + ".time_mode",            val.time_mode,          NULL, prefix),
                        _shift, LIB_DBG_NAMESPACE(dbg_lib, var_out)(name + ".country_id",           val.country_id,         NULL, prefix),
                        _shift, LIB_DBG_NAMESPACE(dbg_lib, var_out)(name + ".unit",                 val.unit,               NULL, prefix),
                        _shift, LIB_DBG_NAMESPACE(dbg_lib, var_out)(name + ".importance",           val.importance,         NULL, prefix),
                        _shift, LIB_DBG_NAMESPACE(dbg_lib, var_out)(name + ".multiplier",           val.multiplier,         NULL, prefix),
                        _shift, LIB_DBG_NAMESPACE(dbg_lib, var_out)(name + ".digits",               val.digits,             NULL, prefix),
                        _shift, LIB_DBG_NAMESPACE(dbg_lib, var_out)(name + ".source_url",           val.source_url,         NULL, prefix),
                        _shift, LIB_DBG_NAMESPACE(dbg_lib, var_out)(name + ".event_code",           val.event_code,         NULL, prefix),
                        _shift, LIB_DBG_NAMESPACE(dbg_lib, var_out)(name + ".url_name",             val.name,               NULL, prefix)
                        )); }
            const string    LIB_DBG_NAMESPACE_DEF(dbg_lib, var_out)(const string _name, const MqlCalendarValue&         val, const int shift = 0, const string      _prefix = "",   const int offset = 0)
            {
                const string name = " " + _name;
                const string _shift = StringFormat("%" + IntegerToString(shift) + "s", "");
                const string prefix = (_prefix == "") ? StringFormat("{ %s }", typename_raw(val)) : _prefix;
                return(StringFormat(" {\n%s%s\n%s%s\n%s%s\n%s%s\n%s%s\n%s%s\n%s%s\n%s%s\n%s%s\n%s%s\n%s%s\n%s%s\n%s%s\n%s%s\n%s%s\n%s%s\n%s%s\n%s%s",
                        _shift, LIB_DBG_NAMESPACE(dbg_lib, var_out)(name + ".id",                   val.id,                 NULL, prefix),
                        _shift, LIB_DBG_NAMESPACE(dbg_lib, var_out)(name + ".event_id",             val.event_id,           NULL, prefix),
                        _shift, LIB_DBG_NAMESPACE(dbg_lib, var_out)(name + ".time",                 val.time,               NULL, prefix),
                        _shift, LIB_DBG_NAMESPACE(dbg_lib, var_out)(name + ".period",               val.period,             NULL, prefix),
                        _shift, LIB_DBG_NAMESPACE(dbg_lib, var_out)(name + ".revision",             val.revision,           NULL, prefix),
                        _shift, LIB_DBG_NAMESPACE(dbg_lib, var_out)(name + ".actual_value",         val.actual_value,       NULL, prefix),
                        _shift, LIB_DBG_NAMESPACE(dbg_lib, var_out)(name + ".prev_value",           val.prev_value,         NULL, prefix),
                        _shift, LIB_DBG_NAMESPACE(dbg_lib, var_out)(name + ".revised_prev_value",   val.revised_prev_value, NULL, prefix),
                        _shift, LIB_DBG_NAMESPACE(dbg_lib, var_out)(name + ".forecast_value",       val.forecast_value,     NULL, prefix),
                        _shift, LIB_DBG_NAMESPACE(dbg_lib, var_out)(name + ".impact_type",          val.impact_type,        NULL, prefix),
                    #ifndef __MQLPUBLISHING__
                        _shift, LIB_DBG_NAMESPACE(dbg_lib, var_out)(name + ".HasActualValue",       val.HasActualValue(),   NULL, prefix),
                        _shift, LIB_DBG_NAMESPACE(dbg_lib, var_out)(name + ".HasPreviousValue",     val.HasPreviousValue(), NULL, prefix),
                        _shift, LIB_DBG_NAMESPACE(dbg_lib, var_out)(name + ".HasRevisedValue",      val.HasRevisedValue(),  NULL, prefix),
                        _shift, LIB_DBG_NAMESPACE(dbg_lib, var_out)(name + ".HasForecastValue",     val.HasForecastValue(), NULL, prefix),
                        _shift, LIB_DBG_NAMESPACE(dbg_lib, var_out)(name + ".GetActualValue",       val.GetActualValue(),   NULL, prefix),
                        _shift, LIB_DBG_NAMESPACE(dbg_lib, var_out)(name + ".GetPreviousValue",     val.GetPreviousValue(), NULL, prefix),
                        _shift, LIB_DBG_NAMESPACE(dbg_lib, var_out)(name + ".GetRevisedValue",      val.GetRevisedValue(),  NULL, prefix),
                        _shift, LIB_DBG_NAMESPACE(dbg_lib, var_out)(name + ".GetForecastValue",     val.GetForecastValue(), NULL, prefix)
                    #else
                        "", "", "", "", "", "", "", ""
                    #endif
                        )); }
        #endif

            // Literal to bit string
            const string LIB_DBG_NAMESPACE_DEF(dbg_lib, bits_out)(const ulong val)                      { return(StringFormat("%s %s", LIB_DBG_NAMESPACE(dbg_lib, bits_out)((uint)(val>>32)), LIB_DBG_NAMESPACE(dbg_lib, bits_out)((uint)val))); }
            const string LIB_DBG_NAMESPACE_DEF(dbg_lib, bits_out)(const uint val)                       { return(StringFormat("%s %s", LIB_DBG_NAMESPACE(dbg_lib, bits_out)((ushort)(val>>16)), LIB_DBG_NAMESPACE(dbg_lib, bits_out)((ushort)val))); }
            const string LIB_DBG_NAMESPACE_DEF(dbg_lib, bits_out)(const ushort val)                     { return(StringFormat("%s %s", LIB_DBG_NAMESPACE(dbg_lib, bits_out)((uchar)(val>>8)), LIB_DBG_NAMESPACE(dbg_lib, bits_out)((uchar)val))); }
            const string LIB_DBG_NAMESPACE_DEF(dbg_lib, bits_out)(const uchar val)                      { return(StringFormat("%s%s%s%s%s%s%s%s", ((((uchar)val)&0x80) > NULL) ? "1" : "0", ((((uchar)val)&0x40) > NULL) ? "1" : "0", ((((uchar)val)&0x20) > NULL) ? "1" : "0", ((((uchar)val)&0x10) > NULL) ? "1" : "0", ((((uchar)val)&0x08) > NULL) ? "1" : "0", ((((uchar)val)&0x04) > NULL) ? "1" : "0", ((((uchar)val)&0x02) > NULL)? "1" : "0", ((((uchar)val)&0x01) > NULL) ? "1" : "0")); }

            // Uninit code to string
            void LIB_DBG_NAMESPACE_DEF(dbg_lib, uninit_text)(const string func_name, const int custom_uninit_reason = -1)
            {
                LIB_DBG_NAMESPACE(dbg_lib, dbg_uninit_reason) = (LIB_DBG_NAMESPACE(dbg_lib, dbg_uninit_reason) == -1) && ((_UninitReason != NULL) || (_StopFlag && (func_name == "OnDeinit"))) ? _UninitReason : LIB_DBG_NAMESPACE(dbg_lib, dbg_uninit_reason);
                if(LIB_DBG_NAMESPACE(dbg_lib, dbg_uninit_reason) == -1)
                { return; }
                switch((custom_uninit_reason == -1) ? LIB_DBG_NAMESPACE(dbg_lib, dbg_uninit_reason) : custom_uninit_reason)
                {
                    // Terminal built-in reasons
                    case REASON_PROGRAM:                    DBG_MSG(StringFormat("(_UninitReason) %i = REASON_PROGRAM: %s (session id: %llu)",                 (int)LIB_DBG_NAMESPACE(dbg_lib, dbg_uninit_reason), "Expert Advisor terminated its operation by calling the ExpertRemove() function.", LIB_DBG_NAMESPACE(dbg_lib, dbg_session_id))); return;
                    case REASON_REMOVE:                     DBG_MSG(StringFormat("(_UninitReason) %i = REASON_REMOVE: %s (session id: %llu)",                  (int)LIB_DBG_NAMESPACE(dbg_lib, dbg_uninit_reason), "Program has been deleted from the chart.", LIB_DBG_NAMESPACE(dbg_lib, dbg_session_id))); return;
                    case REASON_RECOMPILE:                  DBG_MSG(StringFormat("(_UninitReason) %i = REASON_RECOMPILE: %s (session id: %llu)",               (int)LIB_DBG_NAMESPACE(dbg_lib, dbg_uninit_reason), "Program has been recompiled.", LIB_DBG_NAMESPACE(dbg_lib, dbg_session_id))); return;
                    case REASON_CHARTCHANGE:                DBG_MSG(StringFormat("(_UninitReason) %i = REASON_CHARTCHANGE: %s (session id: %llu)",             (int)LIB_DBG_NAMESPACE(dbg_lib, dbg_uninit_reason), "Symbol or chart period has been changed.", LIB_DBG_NAMESPACE(dbg_lib, dbg_session_id))); return;
                    case REASON_CHARTCLOSE:                 DBG_MSG(StringFormat("(_UninitReason) %i = REASON_CHARTCLOSE: %s (session id: %llu)",              (int)LIB_DBG_NAMESPACE(dbg_lib, dbg_uninit_reason), "Chart has been closed.", LIB_DBG_NAMESPACE(dbg_lib, dbg_session_id))); return;
                    case REASON_PARAMETERS:                 DBG_MSG(StringFormat("(_UninitReason) %i = REASON_PARAMETERS: %s (session id: %llu)",              (int)LIB_DBG_NAMESPACE(dbg_lib, dbg_uninit_reason), "Input parameters have been changed by a user.", LIB_DBG_NAMESPACE(dbg_lib, dbg_session_id))); return;
                    case REASON_ACCOUNT:                    DBG_MSG(StringFormat("(_UninitReason) %i = REASON_ACCOUNT: %s (session id: %llu)",                 (int)LIB_DBG_NAMESPACE(dbg_lib, dbg_uninit_reason), "Another account has been activated or reconnection to the trade server has occurred due to changes in the account settings.", LIB_DBG_NAMESPACE(dbg_lib, dbg_session_id))); return;
                    case REASON_TEMPLATE:                   DBG_MSG(StringFormat("(_UninitReason) %i = REASON_TEMPLATE: %s (session id: %llu)",                (int)LIB_DBG_NAMESPACE(dbg_lib, dbg_uninit_reason), "A new template has been applied.", LIB_DBG_NAMESPACE(dbg_lib, dbg_session_id))); return;
                    case REASON_INITFAILED:                 DBG_MSG(StringFormat("(_UninitReason) %i = REASON_INITFAILED: %s (session id: %llu)",              (int)LIB_DBG_NAMESPACE(dbg_lib, dbg_uninit_reason), "This value means that OnInit() handler has returned a nonzero value.", LIB_DBG_NAMESPACE(dbg_lib, dbg_session_id))); return;
                    case REASON_CLOSE:                      DBG_MSG(StringFormat("(_UninitReason) %i = REASON_CLOSE: %s (session id: %llu)",                   (int)LIB_DBG_NAMESPACE(dbg_lib, dbg_uninit_reason), "Terminal has been closed.", LIB_DBG_NAMESPACE(dbg_lib, dbg_session_id))); return;

                    // MQLplus extended reasons
                    case REASON_MQLPLUS_EXPERT_KILL:        DBG_MSG(StringFormat("(_UninitReason) %i = REASON_MQLPLUS_EXPERT_KILL: %s (session id: %llu)",     (int)LIB_DBG_NAMESPACE(dbg_lib, dbg_uninit_reason), "Program terminated its operation by calling the ExpertKill() function.", LIB_DBG_NAMESPACE(dbg_lib, dbg_session_id))); return;

                    // Unknown reasons
                    default:                                DBG_MSG(StringFormat("Unknown reason: %i (session id: %llu)", (int)LIB_DBG_NAMESPACE(dbg_lib, dbg_uninit_reason), LIB_DBG_NAMESPACE(dbg_lib, dbg_session_id)));
                }
                return;
            }

            template <typename T>
            T LIB_DBG_NAMESPACE_DEF(dbg_lib, return_function_result)(const string name, const T value, const string msg, const string func_name)
            {
                LIB_DBG_NAMESPACE(dbg_lib, dbg_printf)(((LIB_DBG_NAMESPACE(dbg_lib, trace_call_depth) == 1) ? "" : DBG_OUTPUT_PREFIX) + DBG_OUTPUT_PREFIX + DBG_OUTPUT_PREFIX + msg, "", StringFormat("=> %s return(%s);", typename_raw((value)), (LIB_DBG_NAMESPACE(dbg_lib, var_out)("(" + name + ")", value, NULL, "", StringLen(typename_raw(value)) + 11))));
                LIB_DBG_NAMESPACE(dbg_lib, dbg_printf)("%*s%s", LIB_DBG_NAMESPACE(dbg_lib, trace_call_depth) * 2, "", StringFormat(msg, DBG_TRACE_END_MSG_TXT, StringFormat(DBG_OUTPUT_TRACE_END_FORMAT , dbg_lib::trace_call_depth, func_name))); LIB_DBG_NAMESPACE(dbg_lib, dbg_printf)("%s", " "); dbg_lib::trace_call_depth--; DBG_TRACE_EXEC_DELAY;
                return(value);
            }

            template <typename T>
            void LIB_DBG_NAMESPACE_DEF(dbg_lib, return_function_object)(const string name, T& value, const string msg, const string func_name)
            {
                LIB_DBG_NAMESPACE(dbg_lib, dbg_printf)(((LIB_DBG_NAMESPACE(dbg_lib, trace_call_depth) == 1) ? "" : DBG_OUTPUT_PREFIX) + DBG_OUTPUT_PREFIX + DBG_OUTPUT_PREFIX + msg, "", StringFormat("=> %s return(%s);", typename_raw((value)), (LIB_DBG_NAMESPACE(dbg_lib, obj_out)("(" + name + ")", typename(value), NULL, "", StringLen(typename(value)) + 11))));
                LIB_DBG_NAMESPACE(dbg_lib, dbg_printf)("%*s%s", LIB_DBG_NAMESPACE(dbg_lib, trace_call_depth) * 2, "", StringFormat(msg, DBG_TRACE_END_MSG_TXT, StringFormat(DBG_OUTPUT_TRACE_END_FORMAT , dbg_lib::trace_call_depth, func_name))); LIB_DBG_NAMESPACE(dbg_lib, dbg_printf)("%s", " "); dbg_lib::trace_call_depth--; DBG_TRACE_EXEC_DELAY;
                return;
            }

        #ifndef __MQL4_COMPATIBILITY_CODE__
        };
        #endif
    #endif

//
/////////////////////////////////////////////////////////////////////////////////////////////////////





/////////////////////////////////////////////////////////////////////////////////////////////////////
//
// Vardump array
//

    // Vardump pause execution
    #ifdef DBG_VARDUMP_PAUSE
    #undef DBG_VARDUMP_PAUSE_COMMAND
    #define DBG_VARDUMP_PAUSE_COMMAND(x) DBG_MSG(LIB_DBG_NAMESPACE(dbg_lib, dbg_StringFormat)("Vardump: %s %s[%i] done. Execution delayed for %i seconds.", typename_raw((x)), #x, LIB_DBG_NAMESPACE(dbg_lib, dbg_ArraySize)(x), DBG_VARDUMP_PAUSE)); DBG_SLEEP_SECONDS(DBG_VARDUMP_PAUSE)
    #else
    #undef DBG_VARDUMP_PAUSE_COMMAND
    #define DBG_VARDUMP_PAUSE_COMMAND(x) DBG_MSG(LIB_DBG_NAMESPACE(dbg_lib, dbg_StringFormat)("Vardump: %s %s[%i] done.", typename_raw((x)), #x, LIB_DBG_NAMESPACE(dbg_lib, dbg_ArraySize)(x)));
    #endif

    // Dump function
    #ifndef LIB_DEBUG_NAMESPACE
        #ifndef __MQL4_COMPATIBILITY_CODE__
        namespace dbg_lib
        {
        #endif
            const int typename_known(const string type)
            {   return( (type == "bool") || (type == "float") || (type == "double") || (type == "datetime")
                     || (type == "char") || (type == "short") || (type == "int") || (type == "long")
                     || (type == "uchar") || (type == "ushort") ||(type == "uint") || (type == "ulong")
                     || (type == "complex") || (type == "matrix") || (type == "vector")
                     || (type == "string") );
            }
            template <typename T>
            void LIB_DBG_NAMESPACE_DEF(dbg_lib, VarDump)(const T &_array_[], const string _var_name_, const string _file_, const string _func_, const int _line_, const int limit)
            {
                const string type = typename_raw(_array_);
                const int arr_size = ArraySize(_array_);
                if(!typename_known(type))
                {
                    LIB_DBG_NAMESPACE(dbg_lib, dbg_printf)(DBG_OUTPUT_STRING, "", _file_, _func_, _line_, StringFormat("Vardump array type unknown: %s; %s[%]; type: %s", type, _var_name_, ArraySize(_array_), ((ArrayIsDynamic(_array_)) ? "dynamic" : "static")));
                    if(!_DEBUG)
                    { LIB_DBG_NAMESPACE(dbg_lib, dbg_printf)(DBG_OUTPUT_STRING, "", _file_, _func_, _line_, StringFormat("Vardump: %s %s[%i] done. Execution delayed for %i seconds.", type, _var_name_, ArraySize(_array_), DBG_VARDUMP_PAUSE)); DBG_SLEEP_SECONDS(DBG_VARDUMP_PAUSE); }
                    else
                    { LIB_DBG_NAMESPACE(dbg_lib, dbg_printf)(DBG_OUTPUT_STRING, "", _file_, _func_, _line_, StringFormat("Vardump: %s %s[%i] done.", type, _var_name_, ArraySize(_array_))); }
                    return;
                }

                LIB_DBG_NAMESPACE(dbg_lib, dbg_printf)(DBG_OUTPUT_STRING, "", _file_, _func_, _line_, StringFormat("Vardump array: %s %s[%i] type: %s", type, _var_name_, arr_size, ((ArrayIsDynamic(_array_)) ? "dynamic" : "static")));
                if( (limit == NULL) || (limit >= arr_size))
                { for(int cnt = 0x00; cnt < arr_size; cnt++) { LIB_DBG_NAMESPACE(dbg_lib, dbg_printf)("%s%s%s%s[%i] = %s ", DBG_OUTPUT_PREFIX, DBG_OUTPUT_PREFIX, DBG_OUTPUT_PREFIX, _var_name_, cnt, LIB_DBG_NAMESPACE(dbg_lib, dbg_to_string)(_array_[cnt])); } }
                else
                {
                    for(int cnt = 0x00; cnt < limit; cnt++) { LIB_DBG_NAMESPACE(dbg_lib, dbg_printf)("%s%s%s%s[%i] = %s ", DBG_OUTPUT_PREFIX, DBG_OUTPUT_PREFIX, DBG_OUTPUT_PREFIX, _var_name_, cnt, LIB_DBG_NAMESPACE(dbg_lib, dbg_to_string)(_array_[cnt])); }
                    LIB_DBG_NAMESPACE(dbg_lib, dbg_printf)("%s%s%s%s[%i - %i] = %s ", DBG_OUTPUT_PREFIX, DBG_OUTPUT_PREFIX, DBG_OUTPUT_PREFIX, _var_name_, limit, arr_size - limit - 1, "... SKIPPED ...");
                    for(int cnt = arr_size - limit; cnt < arr_size; cnt++) { LIB_DBG_NAMESPACE(dbg_lib, dbg_printf)("%s%s%s%s[%i] = %s ", DBG_OUTPUT_PREFIX, DBG_OUTPUT_PREFIX, DBG_OUTPUT_PREFIX, _var_name_, cnt, LIB_DBG_NAMESPACE(dbg_lib, dbg_to_string)(_array_[cnt])); }
                }
                if(!_DEBUG)
                { LIB_DBG_NAMESPACE(dbg_lib, dbg_printf)(DBG_OUTPUT_STRING, "", _file_, _func_, _line_, StringFormat("Vardump: %s %s[%i] done. Execution delayed for %i seconds.", type, _var_name_, ArraySize(_array_), DBG_VARDUMP_PAUSE)); DBG_SLEEP_SECONDS(DBG_VARDUMP_PAUSE); }
                else
                { LIB_DBG_NAMESPACE(dbg_lib, dbg_printf)(DBG_OUTPUT_STRING, "", _file_, _func_, _line_, StringFormat("Vardump: %s %s[%i] done.", type, _var_name_, ArraySize(_array_))); }
            return;
            }
            template <typename T, typename U>
            void LIB_DBG_NAMESPACE_DEF(dbg_lib, VarDump)(const T& _array1_[], const string _var_name1_, const U& _array2_[], const string _var_name2_, const string _file_, const string _func_, const int _line_, const int limit = NULL)
            {
                const string type1 = typename_raw(_array1_);
                const string type2 = typename_raw(_array2_);
                LIB_DBG_NAMESPACE(dbg_lib, dbg_printf)(DBG_OUTPUT_STRING, "", _file_, _func_, _line_, StringFormat("Vardump list: %s %s[%i] type: %s; %s %s[%i] type: %s", type1, _var_name1_, ArraySize(_array1_), ((ArrayIsDynamic(_array1_)) ? "dynamic" : "static"), type2, _var_name2_, ArraySize(_array2_), ((ArrayIsDynamic(_array2_)) ? "dynamic" : "static")));
                const int arr_size = MathMin(ArraySize(_array1_), ArraySize(_array2_));
                if( (limit == NULL) || (limit >= arr_size))
                { for(int cnt = 0x00; cnt < arr_size; cnt++) { LIB_DBG_NAMESPACE(dbg_lib, dbg_printf)("%s%s%s%s[%i], %30s[%i] = %-30s -> %s", DBG_OUTPUT_PREFIX, DBG_OUTPUT_PREFIX, DBG_OUTPUT_PREFIX, _var_name1_, cnt, _var_name2_, cnt, LIB_DBG_NAMESPACE(dbg_lib, dbg_to_string)(_array1_[cnt]), LIB_DBG_NAMESPACE(dbg_lib, dbg_to_string)(_array2_[cnt])); } }
                else
                {
                    for(int cnt = 0x00; cnt < limit; cnt++) { LIB_DBG_NAMESPACE(dbg_lib, dbg_printf)("%s%s%s%s[%i], %30s[%i] = %-30s -> %s", DBG_OUTPUT_PREFIX, DBG_OUTPUT_PREFIX, DBG_OUTPUT_PREFIX, _var_name1_, cnt, _var_name2_, cnt, VoidToString(_array1_[cnt]. type_id1), VoidToString(_array2_[cnt]. type_id2)); }
                    LIB_DBG_NAMESPACE(dbg_lib, dbg_printf)("%s%s%s%s[%i - %i] = %s ", DBG_OUTPUT_PREFIX, DBG_OUTPUT_PREFIX, DBG_OUTPUT_PREFIX, _var_name_, limit, arr_size - limit - 1, "... SKIPPED ...");
                    for(int cnt = arr_size - limit; cnt < arr_size; cnt++) { LIB_DBG_NAMESPACE(dbg_lib, dbg_printf)("%s%s%s%s[%i], %30s[%i] = %-30s -> %s", DBG_OUTPUT_PREFIX, DBG_OUTPUT_PREFIX, DBG_OUTPUT_PREFIX, _var_name1_, cnt, _var_name2_, cnt, LIB_DBG_NAMESPACE(dbg_lib, dbg_to_string)(_array1_[cnt]), LIB_DBG_NAMESPACE(dbg_lib, dbg_to_string)(_array2_[cnt])); }
                }
                if(!_DEBUG)
                { LIB_DBG_NAMESPACE(dbg_lib, dbg_printf)(DBG_OUTPUT_STRING, "", _file_, _func_, _line_, StringFormat("Vardump: %s %s[%i] -> %s %s[%i] done. Execution delayed for %i seconds.", typename_raw(_array1_), _var_name1_, ArraySize(_array1_), typename_raw(_array2_), _var_name2_, ArraySize(_array2_), DBG_VARDUMP_PAUSE)); DBG_SLEEP_SECONDS(DBG_VARDUMP_PAUSE); }
                else
                { LIB_DBG_NAMESPACE(dbg_lib, dbg_printf)(DBG_OUTPUT_STRING, "", _file_, _func_, _line_, StringFormat("Vardump: %s %s[%i] -> %s %s[%i] done.", typename_raw(_array1_), _var_name1_, ArraySize(_array1_), typename_raw(_array1_), _var_name1_, ArraySize(_array1_))); }
            return;
            }
            template <typename T>
            void LIB_DBG_NAMESPACE_DEF(dbg_lib, VarDump)(const T _value_, const string _var_name_, const string _file_, const string _func_, const int _line_)
            {
                const string type = typename_raw(_value_);
                LIB_DBG_NAMESPACE(dbg_lib, dbg_printf)(DBG_OUTPUT_STRING, "", _file_, _func_, _line_, StringFormat("Vardump value: %s %s", type, _var_name_));
                if(type == "string")
                { LIB_DBG_NAMESPACE(dbg_lib, dbg_printf)("%s%s%s%s = %s ", DBG_OUTPUT_PREFIX, DBG_OUTPUT_PREFIX, DBG_OUTPUT_PREFIX, _var_name_, _value_); }
                else if(type == "double")
                { LIB_DBG_NAMESPACE(dbg_lib, dbg_printf)("%s%s%s%s = %." + IntegerToString(DBG_DOUBLE_OUTPUT_DIGITS) + "f ", DBG_OUTPUT_PREFIX, DBG_OUTPUT_PREFIX, DBG_OUTPUT_PREFIX, _var_name_, _value_); }
                else if(type == "bool")
                { LIB_DBG_NAMESPACE(dbg_lib, dbg_printf)("%s%s%s%s = %s ", DBG_OUTPUT_PREFIX, DBG_OUTPUT_PREFIX, DBG_OUTPUT_PREFIX, _var_name_, ((_value_ != NULL) ? "true" : "false")); }
                else if(type == "datetime")
                { LIB_DBG_NAMESPACE(dbg_lib, dbg_printf)("%s%s%s%s = %s ", DBG_OUTPUT_PREFIX, DBG_OUTPUT_PREFIX, DBG_OUTPUT_PREFIX, _var_name_, TimeToString((datetime)_value_)); }
                else
                { LIB_DBG_NAMESPACE(dbg_lib, dbg_printf)("%s%s%s%s = %i ", DBG_OUTPUT_PREFIX, DBG_OUTPUT_PREFIX, DBG_OUTPUT_PREFIX, _var_name_, _value_); }
                if(!_DEBUG)
                { LIB_DBG_NAMESPACE(dbg_lib, dbg_printf)(DBG_OUTPUT_STRING, "", _file_, _func_, _line_, StringFormat("Vardump: %s %s done. Execution delayed for %i seconds.", type, _var_name_, DBG_VARDUMP_PAUSE)); DBG_SLEEP_SECONDS(DBG_VARDUMP_PAUSE); }
                else
                { LIB_DBG_NAMESPACE(dbg_lib, dbg_printf)(DBG_OUTPUT_STRING, "", _file_, _func_, _line_, StringFormat("Vardump: %s %s done.", type, _var_name_)); }
            return;
            }
        #ifndef __MQL4_COMPATIBILITY_CODE__
        };
        #endif
    #endif

    // Var dump macro
    #define DBG_MSG_VARDUMP(x)      LIB_DBG_NAMESPACE(dbg_lib, VarDump)(x, #x, __FILE__, __FUNCSIG__, __LINE__, DBG_VARDUMP_ARRAY_LIMIT(x))
    #define DBG_MSG_LISTDUMP(x, y)  LIB_DBG_NAMESPACE(dbg_lib, VarDump)(x, #x, y, #y, __FILE__, __FUNCSIG__, __LINE__, DBG_VARDUMP_ARRAY_LIMIT(x))

//
/////////////////////////////////////////////////////////////////////////////////////////////////////





/////////////////////////////////////////////////////////////////////////////////////////////////////
//
// Assert support
//

    // Generic assert definition
    #define DBG_GENERIC_ASSERT(condition, message) { if(!(condition)) { string msg = LIB_DBG_NAMESPACE(dbg_lib, dbg_StringFormat)(DBG_OUTPUT_STRING, ((#condition == "") ? "" : #condition + " "), DBG_CODE_LOCATION_STRING, message);

    // Call modal dialog and div/zero!
    #define DBG_ASSERT(condition, message)                          DBG_GENERIC_ASSERT(condition, message) LIB_DBG_NAMESPACE(dbg_lib, dbg_Alert)(DBG_ASSERT_MSG_TXT + " " + msg); DBG_CRASH_CODE; } }

    // Print out information
    #define DBG_ASSERT_LOG(condition, message)                      DBG_GENERIC_ASSERT(condition, message) LIB_DBG_NAMESPACE(dbg_lib, dbg_printf)("%s%s %s", DBG_OUTPUT_PREFIX + DBG_OUTPUT_PREFIX, DBG_ASSERT_MSG_TXT, msg); } }

    // Print info and abort execution by return;
    #define DBG_ASSERT_RETURN(condition, message)                   DBG_GENERIC_ASSERT(condition, message) LIB_DBG_NAMESPACE(dbg_lib, dbg_printf)("%s%s %s", DBG_OUTPUT_PREFIX + DBG_OUTPUT_PREFIX, DBG_ASSERT_MSG_TXT, msg); return; } }

    // Print info and abort execution by return;
    #define DBG_ASSERT_RETURN_VAR(condition, message, return_value) DBG_GENERIC_ASSERT(condition, message) LIB_DBG_NAMESPACE(dbg_lib, dbg_printf)("%s%s %s", DBG_OUTPUT_PREFIX + DBG_OUTPUT_PREFIX, DBG_ASSERT_MSG_TXT, msg); return(return_value); } }


//
/////////////////////////////////////////////////////////////////////////////////////////////////////





/////////////////////////////////////////////////////////////////////////////////////////////////////
//
// Software inherited brakepoints
//

    // Stop function
    #ifndef LIB_DEBUG_NAMESPACE
    #define LIB_DEBUG_NAMESPACE
        #ifndef __MQL4_COMPATIBILITY_CODE__
        namespace dbg_lib
        {
        #endif
            const bool LIB_DBG_NAMESPACE_DEF(dbg_lib, BreakPoint)(const int _line_, const string _file_, const long _timestamp_ = NULL)
            {
                #ifndef DBG_DEBUGGER_OVERWRITE
                if(IS_DEBUG_MODE)
                { printf("##### Breakpoint set at line: %i in file: %s.", _line_, _file_); return(true); }
                else
                #endif
                if(_timestamp_ <= ((TimeCurrent() - (TimeCurrent() % PeriodSeconds())) * (_timestamp_ > NULL)))
                { printf("##### Breakpoint set at line: %i in file: %s, waiting %i seconds.", _line_, _file_, DBG_SOFT_BKP_TIMEOUT); return(true); }
                return(false);
            }
            const bool LIB_DBG_NAMESPACE_DEF(dbg_lib, ExecTime)(const uint _seconds_)
            {
                static ulong exec_time_start = GetMicrosecondCount();
                exec_time_start = (exec_time_start * (ulong)((_seconds_ > 0x00) & 0x01)) + (GetMicrosecondCount() * (ulong)((_seconds_ == NULL) & 0x01));
                return(((long)exec_time_start) < ((long)(GetMicrosecondCount() - (_seconds_ * 1000000))));
            }
        #ifndef __MQL4_COMPATIBILITY_CODE__
        };
        #endif
    #endif

    // Debugging macros
    #define DBG_SOFT_BREAKPOINT                         { LIB_DBG_NAMESPACE(dbg_lib, BreakPoint)(__LINE__, __FILE__); if(IS_DEBUG_MODE) { DebugBreak(); } else { DBG_SLEEP_SECONDS(DBG_SOFT_BKP_TIMEOUT); } }
    #define DBG_SOFT_BREAKPOINT_TS(timestamp)           { LIB_DBG_NAMESPACE(dbg_lib, BreakPoint)(__LINE__, __FILE__, LIB_DBG_NAMESPACE(dbg_lib, dbg_StringToTime)(timestamp)); DBG_SOFT_BREAKPOINT }
    #define DBG_SOFT_BREAKPOINT_CONDITION(x)            { if((x) && (LIB_DBG_NAMESPACE(dbg_lib, BreakPoint)(__LINE__, __FILE__, LIB_DBG_NAMESPACE(dbg_lib, dbg_TimeCurrent)() + DBG_SOFT_BKP_TIMEOUT))) { DBG_SOFT_BREAKPOINT; } }
    #define DBG_SOFT_BREAKPOINT_EXEC_TIME(x)            { DBG_SOFT_BREAKPOINT_CONDITION(LIB_DBG_NAMESPACE(dbg_lib, ExecTime)(x)); LIB_DBG_NAMESPACE(dbg_lib, ExecTime)(NULL); }

    // Conditional break debugging macros
    #define DBG_BREAK_CALL_COUNTER(x)                   if(dbg_lib_func_call_count == x) { DebugBreak(); }
    #define DBG_BREAK_IF(x)                             if(x) { DebugBreak(); }

    #ifndef __MQL4_COMPATIBILITY_CODE__
        #define DBG_BREAK_CONDITION_CREATE(_id_, y)     namespace dbg_lib { static bool dbg_cond_ID_state_##x = false; static bool dbg_cond_ID_enabled_##x = y; }
        #define DBG_BREAK_CONDITION_ACTIVATE(x, y)      namespace dbg_lib { static bool dbg_cond_ID_state_##x = (y); }
        #define DBG_BREAK_CONDITION_DEACTIVATE(x, y)    namespace dbg_lib { static bool dbg_cond_ID_state_##x = !(y); }
        #define DBG_BREAK_CONDITION_ON_ID(x)            { if(dbg_lib::dbg_cond_ID_state_##x && dbg_lib::dbg_cond_ID_enabled_##x) { DebugBreak(); } }
    #else
        #define DBG_BREAK_CONDITION_CREATE(_id_, y)     static bool dbg_cond_ID_state_##x = false; static bool dbg_cond_ID_enabled_##x = y;
        #define DBG_BREAK_CONDITION_ACTIVATE(x, y)      dbg_cond_ID_state_##x = (y);
        #define DBG_BREAK_CONDITION_DEACTIVATE(x, y)    dbg_cond_ID_state_##x = !(y);
        #define DBG_BREAK_CONDITION_ON_ID(x)            { if(dbg_cond_ID_state_##x && dbg_cond_ID_enabled_##x) { DebugBreak(); } }
    #endif

    // Array out of range stop macro
    #define DBG_BREAK_ARRAY_OUT_OF_RANGE(x, y)                      { if((LIB_DBG_NAMESPACE(dbg_lib, dbg_ArraySize)(x) <= (y)) || ((y) < NULL)) { DBG_MSG_VARDUMP(x); DBG_MSG_VAR(typename_raw(x)); DBG_MSG_VAR(LIB_DBG_NAMESPACE(dbg_lib, dbg_ArraySize)(x)); DBG_MSG_VAR((y)); DebugBreak(); } }
/*
    #ifndef __MQL4_COMPATIBILITY_CODE__
    #define DBG_BREAK_ARRAY_OUT_OF_RANGE(x, y)                      { const int arr_size = LIB_DBG_NAMESPACE(dbg_lib, dbg_ArraySize)(x); if((arr_size <= y) || (y < NULL)) { LIB_DBG_NAMESPACE(dbg_lib, dbg_ArrayPrint)(x, _Digits, (arr_size < 5) ? NULL : (arr_size - 5), NULL); DBG_MSG_VAR(typename_raw(x)); DBG_MSG_VAR(LIB_DBG_NAMESPACE(dbg_lib, dbg_ArraySize)(x)); DBG_MSG_VAR(y); DebugBreak(); } }
    #else
    #define DBG_BREAK_ARRAY_OUT_OF_RANGE(x, y)                      { if((LIB_DBG_NAMESPACE(dbg_lib, dbg_ArraySize)(x) <= y) || (y < NULL)) { DBG_MSG_VARDUMP(x); DBG_MSG_VAR(typename_raw(x)); DBG_MSG_VAR(LIB_DBG_NAMESPACE(dbg_lib, dbg_ArraySize)(x)); DBG_MSG_VAR(y); DebugBreak(); } }
    #endif
*/

//
/////////////////////////////////////////////////////////////////////////////////////////////////////





/////////////////////////////////////////////////////////////////////////////////////////////////////
//
// Loop tracing
//

    // Init loop trace
    #define DBG_TRACE_LOOP_BEGIN_ID(x)  int _dbg_loop_start##x = 0x00; int _dbg_loop_finish##x = 0x00; ulong _dbg_loop_runtime##x = LIB_DBG_NAMESPACE(dbg_lib, dbg_GetMicrosecondCount)();
    #define DBG_TRACE_LOOP_BEGIN        DBG_TRACE_LOOP_BEGIN_ID(__FUNCTION__)

    // Count loop heads
    #define DBG_TRACE_LOOP_START_ID(x)  _dbg_loop_start##x++;
    #define DBG_TRACE_LOOP_START        DBG_TRACE_LOOP_START_ID(__FUNCTION__)

    // Count loop footers
    #define DBG_TRACE_LOOP_FINISH_ID(x) _dbg_loop_finish##x++;
    #define DBG_TRACE_LOOP_FINISH       DBG_TRACE_LOOP_FINISH_ID(__FUNCTION__)

    // Print loop stats
    #define DBG_TRACE_LOOP_END_ID(x)    DBG_MSG(LIB_DBG_NAMESPACE(dbg_lib, dbg_StringFormat)("Iterations begin: %i; Iterations end: %i; Runtime: %i microseconds.", _dbg_loop_start##x, _dbg_loop_finish##x, (LIB_DBG_NAMESPACE(dbg_lib, dbg_GetMicrosecondCount)() - _dbg_loop_runtime##x)));
    #define DBG_TRACE_LOOP_END          DBG_TRACE_LOOP_END_ID(__FUNCTION__)

//
/////////////////////////////////////////////////////////////////////////////////////////////////////





/////////////////////////////////////////////////////////////////////////////////////////////////////
//
// MT4/5 API function call tracing
//
#ifndef LIB_MQLAPI_CALL_TRACING_DISABLE
    #define AccountInfoDouble                       DBG_MSG_MQLFUNC_RETURN(AccountInfoDouble,               "double")
    #ifndef __MQL4_COMPATIBILITY_CODE__
        #define AccountInfoInteger                  DBG_MSG_MQLFUNC_RETURN(AccountInfoInteger,              "int")

    #endif
    #define AccountInfoString                       DBG_MSG_MQLFUNC_RETURN(AccountInfoString,               "string")
    #define acos                                    DBG_MSG_MQLFUNC_RETURN(acos,                            "double")
    #define Alert                                   DBG_MSG_MQLFUNC(Alert)
    #define ArrayBsearch                            DBG_MSG_MQLFUNC_RETURN(ArrayBsearch,                    "int")
    #define ArrayCompare                            DBG_MSG_MQLFUNC_RETURN(ArrayCompare,                    "int")
    #define ArrayCopy                               DBG_MSG_MQLFUNC_RETURN(ArrayCopy,                       "int")
    #define ArrayFill                               DBG_MSG_MQLFUNC(ArrayFill)
    #define ArrayFree                               DBG_MSG_MQLFUNC(ArrayFree)
    #define ArrayGetAsSeries                        DBG_MSG_MQLFUNC_RETURN(ArrayGetAsSeries,                "bool")
    #define ArrayInitialize                         DBG_MSG_MQLFUNC_RETURN(ArrayInitialize,                 "int")
    #define ArrayIsDynamic                          DBG_MSG_MQLFUNC_RETURN(ArrayIsDynamic,                  "bool")
    #define ArrayIsSeries                           DBG_MSG_MQLFUNC_RETURN(ArrayIsSeries,                   "bool")
    #define ArrayMaximum                            DBG_MSG_MQLFUNC_RETURN(ArrayMaximum,                    "int")
    #define ArrayMinimum                            DBG_MSG_MQLFUNC_RETURN(ArrayMinimum,                    "int")
    #define ArrayRange                              DBG_MSG_MQLFUNC_RETURN(ArrayRange,                      "int")
    #define ArrayResize                             DBG_MSG_MQLFUNC_RETURN(ArrayResize,                     "int")
    #define ArraySetAsSeries                        DBG_MSG_MQLFUNC_RETURN(ArraySetAsSeries,                "bool")
    #define ArraySize                               DBG_MSG_MQLFUNC_RETURN(ArraySize,                       "int")
    #define ArraySort                               DBG_MSG_MQLFUNC_RETURN(ArraySort,                       "bool")
    #ifndef __MQL4_COMPATIBILITY_CODE__
        #define ArrayPrint                          DBG_MSG_MQLFUNC(ArrayPrint)
        #define ArrayInsert                         DBG_MSG_MQLFUNC_RETURN(ArrayInsert,                     "bool")
        #define ArrayRemove                         DBG_MSG_MQLFUNC_RETURN(ArrayRemove,                     "bool")
        #define ArrayReverse                        DBG_MSG_MQLFUNC_RETURN(ArrayReverse,                    "bool")
        #define ArraySwap                           DBG_MSG_MQLFUNC_RETURN(ArraySwap,                       "bool")

    #endif
    #define asin                                    DBG_MSG_MQLFUNC_RETURN(asin,                            "double")
    #define atan                                    DBG_MSG_MQLFUNC_RETURN(atan,                            "double")
    #ifndef __MQL4_COMPATIBILITY_CODE__
        #define Bars                                DBG_MSG_MQLFUNC_RETURN(Bars,                            "int")
        #define BarsCalculated                      DBG_MSG_MQLFUNC_RETURN(BarsCalculated,                  "int")
        #define CalendarCountryById                 DBG_MSG_MQLFUNC_RETURN(CalendarCountryById,             "bool")
        #define CalendarEventById                   DBG_MSG_MQLFUNC_RETURN(CalendarEventById,               "bool")
        #define CalendarValueById                   DBG_MSG_MQLFUNC_RETURN(CalendarValueById,               "bool")
        #define CalendarCountries                   DBG_MSG_MQLFUNC_RETURN(CalendarCountries,               "int")
        #define CalendarEventByCountry              DBG_MSG_MQLFUNC_RETURN(CalendarEventByCountry,          "int")
        #define CalendarEventByCurrency             DBG_MSG_MQLFUNC_RETURN(CalendarEventByCurrency,         "int")
        #define CalendarValueHistoryByEvent         DBG_MSG_MQLFUNC_RETURN(CalendarValueHistoryByEvent,     "bool")
        #define CalendarValueHistory                DBG_MSG_MQLFUNC_RETURN(CalendarValueHistory,            "bool")
        #define CalendarValueLastByEvent            DBG_MSG_MQLFUNC_RETURN(CalendarValueLastByEvent,        "int")
        #define CalendarValueLast                   DBG_MSG_MQLFUNC_RETURN(CalendarValueLast,               "int")

    #endif
    #define ceil                                    DBG_MSG_MQLFUNC_RETURN(ceil,                            "double")
    #define CharArrayToString                       DBG_MSG_MQLFUNC_RETURN(CharArrayToString,               "string")
    #define ChartApplyTemplate                      DBG_MSG_MQLFUNC_RETURN(ChartApplyTemplate,              "bool")
    #define ChartClose                              DBG_MSG_MQLFUNC_RETURN(ChartClose,                      "bool")
    #define ChartFirst                              DBG_MSG_MQLFUNC_RETURN(ChartFirst,                      "long")
    #define ChartGetDouble                          DBG_MSG_MQLFUNC_RETURN(ChartGetDouble,                  "double, bool")
    #define ChartGetInteger                         DBG_MSG_MQLFUNC_RETURN(ChartGetInteger,                 "int")
    #define ChartGetString                          DBG_MSG_MQLFUNC_RETURN(ChartGetString,                  "string")
    #define ChartID                                 DBG_MSG_MQLFUNC_RETURN(ChartID,                         "long")
    #ifndef __MQL4_COMPATIBILITY_CODE__
        #define ChartIndicatorAdd                   DBG_MSG_MQLFUNC_RETURN(ChartIndicatorAdd,               "bool")

    #endif
    #define ChartIndicatorDelete                    DBG_MSG_MQLFUNC_RETURN(ChartIndicatorDelete,            "bool")
    #ifndef __MQL4_COMPATIBILITY_CODE__
        #define ChartIndicatorGet                   DBG_MSG_MQLFUNC_RETURN(ChartIndicatorGet,               "int")

    #endif
    #define ChartIndicatorName                      DBG_MSG_MQLFUNC_RETURN(ChartIndicatorName,              "string")
    #define ChartIndicatorsTotal                    DBG_MSG_MQLFUNC_RETURN(ChartIndicatorsTotal,            "int")
    #define ChartNavigate                           DBG_MSG_MQLFUNC_RETURN(ChartNavigate,                   "bool")
    #define ChartNext                               DBG_MSG_MQLFUNC_RETURN(ChartNext,                       "long")
    #define ChartOpen                               DBG_MSG_MQLFUNC_RETURN(ChartOpen,                       "long")
    #define CharToString                            DBG_MSG_MQLFUNC_RETURN(CharToString,                    "string")
    #define ChartPeriod                             DBG_MSG_MQLFUNC_RETURN(ChartPeriod,                     "enum")
    #define ChartPriceOnDropped                     DBG_MSG_MQLFUNC_RETURN(ChartPriceOnDropped,             "double")
    #define ChartRedraw                             DBG_MSG_MQLFUNC(ChartRedraw)
    #define ChartSaveTemplate                       DBG_MSG_MQLFUNC_RETURN(ChartSaveTemplate,               "bool")
    #define ChartScreenShot                         DBG_MSG_MQLFUNC_RETURN(ChartScreenShot,                 "bool")
    #define ChartSetDouble                          DBG_MSG_MQLFUNC_RETURN(ChartSetDouble,                  "bool")
    #define ChartSetInteger                         DBG_MSG_MQLFUNC_RETURN(ChartSetInteger)
    #define ChartSetString                          DBG_MSG_MQLFUNC_RETURN(ChartSetString)
    #define ChartSetSymbolPeriod                    DBG_MSG_MQLFUNC_RETURN(ChartSetSymbolPeriod)
    #define ChartSymbol                             DBG_MSG_MQLFUNC_RETURN(ChartSymbol)
    #define ChartTimeOnDropped                      DBG_MSG_MQLFUNC_RETURN(ChartTimeOnDropped)
    #define ChartTimePriceToXY                      DBG_MSG_MQLFUNC_RETURN(ChartTimePriceToXY)
    #define ChartWindowFind                         DBG_MSG_MQLFUNC_RETURN(ChartWindowFind)
    #define ChartWindowOnDropped                    DBG_MSG_MQLFUNC_RETURN(ChartWindowOnDropped)
    #define ChartXOnDropped                         DBG_MSG_MQLFUNC_RETURN(ChartXOnDropped)
    #define ChartXYToTimePrice                      DBG_MSG_MQLFUNC_RETURN(ChartXYToTimePrice)
    #define ChartYOnDropped                         DBG_MSG_MQLFUNC_RETURN(ChartYOnDropped)
    #define CheckPointer                            DBG_MSG_MQLFUNC_RETURN(CheckPointer)
    #ifndef __MQL4_COMPATIBILITY_CODE__
        #define CLBufferCreate                      DBG_MSG_MQLFUNC_RETURN(CLBufferCreate)
        #define CLBufferFree                        DBG_MSG_MQLFUNC(CLBufferFree)
        #define CLBufferRead                        DBG_MSG_MQLFUNC_RETURN(CLBufferRead)
        #define CLBufferWrite                       DBG_MSG_MQLFUNC_RETURN(CLBufferWrite)
        #define CLContextCreate                     DBG_MSG_MQLFUNC_RETURN(CLContextCreate)
        #define CLContextFree                       DBG_MSG_MQLFUNC(CLContextFree)
        #define CLExecute                           DBG_MSG_MQLFUNC_RETURN(CLExecute)
        #define CLGetDeviceInfo                     DBG_MSG_MQLFUNC_RETURN(CLGetDeviceInfo)
        #define CLGetInfoInteger                    DBG_MSG_MQLFUNC_RETURN(CLGetInfoInteger)
        #define CLHandleType                        DBG_MSG_MQLFUNC_RETURN(CLHandleType)
        #define CLKernelCreate                      DBG_MSG_MQLFUNC_RETURN(CLKernelCreate)
        #define CLKernelFree                        DBG_MSG_MQLFUNC(CLKernelFree)
        #define CLProgramCreate                     DBG_MSG_MQLFUNC_RETURN(CLProgramCreate)
        #define CLProgramFree                       DBG_MSG_MQLFUNC(CLProgramFree)
        #define CLSetKernelArg                      DBG_MSG_MQLFUNC_RETURN(CLSetKernelArg)
        #define CLSetKernelArgMem                   DBG_MSG_MQLFUNC_RETURN(CLSetKernelArgMem)

    #endif
    #define ColorToARGB                             DBG_MSG_MQLFUNC_RETURN(ColorToARGB)
    #define ColorToString                           DBG_MSG_MQLFUNC_RETURN(ColorToString)
    #define Comment                                 DBG_MSG_MQLFUNC(Comment)
    #ifndef __MQL4_COMPATIBILITY_CODE__
        #define CopyBuffer                          DBG_MSG_MQLFUNC_RETURN(CopyBuffer)

    #endif
    #define CopyClose                               DBG_MSG_MQLFUNC_RETURN(CopyClose)
    #define CopyHigh                                DBG_MSG_MQLFUNC_RETURN(CopyHigh)
    #define CopyLow                                 DBG_MSG_MQLFUNC_RETURN(CopyLow)
    #define CopyOpen                                DBG_MSG_MQLFUNC_RETURN(CopyOpen)
    #define CopyRates                               DBG_MSG_MQLFUNC_RETURN(CopyRates)
    #define CopyRealVolume                          DBG_MSG_MQLFUNC_RETURN(CopyRealVolume)
    #define CopySpread                              DBG_MSG_MQLFUNC_RETURN(CopySpread)
    #ifndef __MQL4_COMPATIBILITY_CODE__
        #define CopyTicks                           DBG_MSG_MQLFUNC_RETURN(CopyTicks)

    #endif
    #define CopyTickVolume                          DBG_MSG_MQLFUNC_RETURN(CopyTickVolume)
    #define CopyTime                                DBG_MSG_MQLFUNC_RETURN(CopyTime)
    #define cos                                     DBG_MSG_MQLFUNC_RETURN(cos)
    #define CryptDecode                             DBG_MSG_MQLFUNC_RETURN(CryptDecode)
    #define CryptEncode                             DBG_MSG_MQLFUNC_RETURN(CryptEncode)
    #ifndef __MQL4_COMPATIBILITY_CODE__
        #define CustomSymbolCreate                  DBG_MSG_MQLFUNC_RETURN(CustomSymbolCreate)
        #define CustomSymbolDelete                  DBG_MSG_MQLFUNC_RETURN(CustomSymbolDelete)
        #define CustomSymbolSetInteger              DBG_MSG_MQLFUNC_RETURN(CustomSymbolSetInteger)
        #define CustomSymbolSetDouble               DBG_MSG_MQLFUNC_RETURN(CustomSymbolSetDouble)
        #define CustomSymbolSetString               DBG_MSG_MQLFUNC_RETURN(CustomSymbolSetString)
        #define CustomSymbolSetMarginRate           DBG_MSG_MQLFUNC_RETURN(CustomSymbolSetMarginRate)
        #define CustomSymbolSetSessionQuote         DBG_MSG_MQLFUNC_RETURN(CustomSymbolSetSessionQuote)
        #define CustomSymbolSetSessionTrade         DBG_MSG_MQLFUNC_RETURN(CustomSymbolSetSessionTrade)
        #define CustomRatesDelete                   DBG_MSG_MQLFUNC_RETURN(CustomRatesDelete)
        #define CustomRatesReplace                  DBG_MSG_MQLFUNC_RETURN(CustomRatesReplace)
        #define CustomRatesUpdate                   DBG_MSG_MQLFUNC_RETURN(CustomRatesUpdate)
        #define CustomTicksAdd                      DBG_MSG_MQLFUNC_RETURN(CustomTicksAdd)
        #define CustomTicksDelete                   DBG_MSG_MQLFUNC_RETURN(CustomTicksDelete)
        #define CustomTicksReplace                  DBG_MSG_MQLFUNC_RETURN(CustomTicksReplace)
        #define CustomBookAdd                       DBG_MSG_MQLFUNC_RETURN(CustomBookAdd)
        #define DatabaseOpen                        DBG_MSG_MQLFUNC_RETURN(DatabaseOpen)
        #define DatabaseClose                       DBG_MSG_MQLFUNC(DatabaseClose)
        #define DatabaseImport                      DBG_MSG_MQLFUNC_RETURN(DatabaseImport)
        #define DatabaseExport                      DBG_MSG_MQLFUNC_RETURN(DatabaseExport)
        #define DatabasePrint                       DBG_MSG_MQLFUNC_RETURN(DatabasePrint)
        #define DatabaseTableExists                 DBG_MSG_MQLFUNC_RETURN(DatabaseTableExists)
        #define DatabaseExecute                     DBG_MSG_MQLFUNC_RETURN(DatabaseExecute)
        #define DatabasePrepare                     DBG_MSG_MQLFUNC_RETURN(DatabasePrepare)
        #define DatabaseReset                       DBG_MSG_MQLFUNC_RETURN(DatabaseReset)
        #define DatabaseBind                        DBG_MSG_MQLFUNC_RETURN(DatabaseBind)
        #define DatabaseBindArray                   DBG_MSG_MQLFUNC_RETURN(DatabaseBindArray)
        #define DatabaseRead                        DBG_MSG_MQLFUNC_RETURN(DatabaseRead)
        #define DatabaseReadBind                    DBG_MSG_MQLFUNC_RETURN(DatabaseReadBind)
        #define DatabaseFinalize                    DBG_MSG_MQLFUNC(DatabaseFinalize)
        #define DatabaseTransactionBegin            DBG_MSG_MQLFUNC_RETURN(DatabaseTransactionBegin)
        #define DatabaseTransactionCommit           DBG_MSG_MQLFUNC_RETURN(DatabaseTransactionCommit)
        #define DatabaseTransactionRollback         DBG_MSG_MQLFUNC_RETURN(DatabaseTransactionRollback)
        #define DatabaseColumnsCount                DBG_MSG_MQLFUNC_RETURN(DatabaseColumnsCount)
        #define DatabaseColumnName                  DBG_MSG_MQLFUNC_RETURN(DatabaseColumnName)
        #define DatabaseColumnType                  DBG_MSG_MQLFUNC_RETURN(DatabaseColumnType)
        #define DatabaseColumnSize                  DBG_MSG_MQLFUNC_RETURN(DatabaseColumnSize)
        #define DatabaseColumnText                  DBG_MSG_MQLFUNC_RETURN(DatabaseColumnText)
        #define DatabaseColumnInteger               DBG_MSG_MQLFUNC_RETURN(DatabaseColumnInteger)
        #define DatabaseColumnLong                  DBG_MSG_MQLFUNC_RETURN(DatabaseColumnLong)
        #define DatabaseColumnDouble                DBG_MSG_MQLFUNC_RETURN(DatabaseColumnDouble)
        #define DatabaseColumnBlob                  DBG_MSG_MQLFUNC_RETURN(DatabaseColumnBlob)

    #endif
    //#define DebugBreak                              DBG_MSG_MQLFUNC(DebugBreak)
    #ifndef __MQL4_COMPATIBILITY_CODE__
        #define Digits                              DBG_MSG_MQLFUNC_RETURN(Digits)

    #endif
    #define DoubleToString                          DBG_MSG_MQLFUNC_RETURN(DoubleToString)
    #ifndef __MQL4_COMPATIBILITY_CODE__
        #define DXContextCreate                     DBG_MSG_MQLFUNC_RETURN(DXContextCreate)
        #define DXContextSetSize                    DBG_MSG_MQLFUNC_RETURN(DXContextSetSize)
        #define DXContextGetSize                    DBG_MSG_MQLFUNC_RETURN(DXContextGetSize)
        #define DXContextClearColors                DBG_MSG_MQLFUNC_RETURN(DXContextClearColors)
        #define DXContextClearDepth                 DBG_MSG_MQLFUNC_RETURN(DXContextClearDepth)
        #define DXContextGetColors                  DBG_MSG_MQLFUNC_RETURN(DXContextGetColors)
        #define DXContextGetDepth                   DBG_MSG_MQLFUNC_RETURN(DXContextGetDepth)
        #define DXBufferCreate                      DBG_MSG_MQLFUNC_RETURN(DXBufferCreate)
        #define DXTextureCreate                     DBG_MSG_MQLFUNC_RETURN(DXTextureCreate)
        #define DXInputCreate                       DBG_MSG_MQLFUNC_RETURN(DXInputCreate)
        #define DXInputSet                          DBG_MSG_MQLFUNC_RETURN(DXInputSet)
        #define DXShaderCreate                      DBG_MSG_MQLFUNC_RETURN(DXShaderCreate)
        #define DXShaderSetLayout                   DBG_MSG_MQLFUNC_RETURN(DXShaderSetLayout)
        #define DXShaderInputsSet                   DBG_MSG_MQLFUNC_RETURN(DXShaderInputsSet)
        #define DXShaderTexturesSet                 DBG_MSG_MQLFUNC_RETURN(DXShaderTexturesSet)
        #define DXDraw                              DBG_MSG_MQLFUNC_RETURN(DXDraw)
        #define DXDrawIndexed                       DBG_MSG_MQLFUNC_RETURN(DXDrawIndexed)
        #define DXPrimiveTopologySet                DBG_MSG_MQLFUNC_RETURN(DXPrimiveTopologySet)
        #define DXBufferSet                         DBG_MSG_MQLFUNC_RETURN(DXBufferSet)
        #define DXShaderSet                         DBG_MSG_MQLFUNC_RETURN(DXShaderSet)
        #define DXHandleType                        DBG_MSG_MQLFUNC_RETURN(DXHandleType)
        #define DXRelease                           DBG_MSG_MQLFUNC_RETURN(DXRelease)

    #endif
    #define EnumToString                            DBG_MSG_MQLFUNC_RETURN(EnumToString)
    #define EventChartCustom                        DBG_MSG_MQLFUNC_RETURN(EventChartCustom)
    #define EventKillTimer                          DBG_MSG_MQLFUNC(EventKillTimer)
    #define EventSetMillisecondTimer                DBG_MSG_MQLFUNC_RETURN(EventSetMillisecondTimer)
    #define EventSetTimer                           DBG_MSG_MQLFUNC_RETURN(EventSetTimer)
    #define exp                                     DBG_MSG_MQLFUNC_RETURN(exp)
    #define ExpertRemove                            DBG_MSG_MQLFUNC(ExpertRemove)
    #define fabs                                    DBG_MSG_MQLFUNC_RETURN(fabs)
    #define FileClose                               DBG_MSG_MQLFUNC(FileClose)
    #define FileCopy                                DBG_MSG_MQLFUNC_RETURN(FileCopy)
    #define FileDelete                              DBG_MSG_MQLFUNC_RETURN(FileDelete)
    #define FileFindClose                           DBG_MSG_MQLFUNC(FileFindClose)
    #define FileFindFirst                           DBG_MSG_MQLFUNC_RETURN(FileFindFirst)
    #define FileFindNext                            DBG_MSG_MQLFUNC_RETURN(FileFindNext)
    #define FileFlush                               DBG_MSG_MQLFUNC(FileFlush)
    #define FileGetInteger                          DBG_MSG_MQLFUNC_RETURN(FileGetInteger)
    #define FileIsEnding                            DBG_MSG_MQLFUNC_RETURN(FileIsEnding)
    #define FileIsExist                             DBG_MSG_MQLFUNC_RETURN(FileIsExist)
    #define FileIsLineEnding                        DBG_MSG_MQLFUNC_RETURN(FileIsLineEnding)
    #define FileMove                                DBG_MSG_MQLFUNC_RETURN(FileMove)
    #define FileOpen                                DBG_MSG_MQLFUNC_RETURN(FileOpen)
    #define FileReadArray                           DBG_MSG_MQLFUNC_RETURN(FileReadArray)
    #define FileReadBool                            DBG_MSG_MQLFUNC_RETURN(FileReadBool)
    #define FileReadDatetime                        DBG_MSG_MQLFUNC_RETURN(FileReadDatetime)
    #define FileReadDouble                          DBG_MSG_MQLFUNC_RETURN(FileReadDouble)
    #define FileReadFloat                           DBG_MSG_MQLFUNC_RETURN(FileReadFloat)
    #define FileReadInteger                         DBG_MSG_MQLFUNC_RETURN(FileReadInteger)
    #define FileReadLong                            DBG_MSG_MQLFUNC_RETURN(FileReadLong)
    #define FileReadNumber                          DBG_MSG_MQLFUNC_RETURN(FileReadNumber)
    #define FileReadString                          DBG_MSG_MQLFUNC_RETURN(FileReadString)
    #define FileReadStruct                          DBG_MSG_MQLFUNC_RETURN(FileReadStruct)
    #define FileSeek                                DBG_MSG_MQLFUNC_RETURN(FileSeek)
    #define FileSize                                DBG_MSG_MQLFUNC_RETURN(FileSize)
    #define FileTell                                DBG_MSG_MQLFUNC_RETURN(FileTell)
    #define FileWrite                               DBG_MSG_MQLFUNC_RETURN(FileWrite)
    #define FileWriteArray                          DBG_MSG_MQLFUNC_RETURN(FileWriteArray)
    #define FileWriteDouble                         DBG_MSG_MQLFUNC_RETURN(FileWriteDouble)
    #define FileWriteFloat                          DBG_MSG_MQLFUNC_RETURN(FileWriteFloat)
    #define FileWriteInteger                        DBG_MSG_MQLFUNC_RETURN(FileWriteInteger)
    #define FileWriteLong                           DBG_MSG_MQLFUNC_RETURN(FileWriteLong)
    #define FileWriteString                         DBG_MSG_MQLFUNC_RETURN(FileWriteString)
    #define FileWriteStruct                         DBG_MSG_MQLFUNC_RETURN(FileWriteStruct)
    #define floor                                   DBG_MSG_MQLFUNC_RETURN(floor)
    #define fmax                                    DBG_MSG_MQLFUNC_RETURN(fmax)
    #define fmin                                    DBG_MSG_MQLFUNC_RETURN(fmin)
    #define fmod                                    DBG_MSG_MQLFUNC_RETURN(fmod)
    #define FolderClean                             DBG_MSG_MQLFUNC_RETURN(FolderClean)
    #define FolderCreate                            DBG_MSG_MQLFUNC_RETURN(FolderCreate)
    #define FolderDelete                            DBG_MSG_MQLFUNC_RETURN(FolderDelete)
    #ifndef __MQL4_COMPATIBILITY_CODE__
        #define FrameAdd                            DBG_MSG_MQLFUNC_RETURN(FrameAdd)
        #define FrameFilter                         DBG_MSG_MQLFUNC_RETURN(FrameFilter)
        #define FrameFirst                          DBG_MSG_MQLFUNC_RETURN(FrameFirst)
        #define FrameInputs                         DBG_MSG_MQLFUNC_RETURN(FrameInputs)
        #define FrameNext                           DBG_MSG_MQLFUNC_RETURN(FrameNext)

    #endif
    #define GetLastError                            DBG_MSG_MQLFUNC_RETURN(GetLastError)
    #define GetMicrosecondCount                     DBG_MSG_MQLFUNC_RETURN(GetMicrosecondCount)
    #define GetPointer                              DBG_MSG_MQLFUNC_PTR(GetPointer)
    #define GetTickCount                            DBG_MSG_MQLFUNC_RETURN(GetTickCount)
    #ifndef __MQL4_COMPATIBILITY_CODE__
        #define GetTickCount64                      DBG_MSG_MQLFUNC_RETURN(GetTickCount64)

    #endif
    #define GlobalVariableCheck                     DBG_MSG_MQLFUNC_RETURN(GlobalVariableCheck)
    #define GlobalVariableDel                       DBG_MSG_MQLFUNC_RETURN(GlobalVariableDel)
    #define GlobalVariableGet                       DBG_MSG_MQLFUNC_RETURN(GlobalVariableGet)
    #define GlobalVariableName                      DBG_MSG_MQLFUNC_RETURN(GlobalVariableName)
    #define GlobalVariablesDeleteAll                DBG_MSG_MQLFUNC_RETURN(GlobalVariablesDeleteAll)
    #define GlobalVariableSet                       DBG_MSG_MQLFUNC_RETURN(GlobalVariableSet)
    #define GlobalVariableSetOnCondition            DBG_MSG_MQLFUNC_RETURN(GlobalVariableSetOnCondition)
    #define GlobalVariablesFlush                    DBG_MSG_MQLFUNC(GlobalVariablesFlush)
    #define GlobalVariablesTotal                    DBG_MSG_MQLFUNC_RETURN(GlobalVariablesTotal)
    #define GlobalVariableTemp                      DBG_MSG_MQLFUNC_RETURN(GlobalVariableTemp)
    #define GlobalVariableTime                      DBG_MSG_MQLFUNC_RETURN(GlobalVariableTime)
    #ifndef __MQL4_COMPATIBILITY_CODE__
        #define HistoryDealGetDouble                DBG_MSG_MQLFUNC_RETURN(HistoryDealGetDouble)
        #define HistoryDealGetInteger               DBG_MSG_MQLFUNC_RETURN(HistoryDealGetInteger)
        #define HistoryDealGetString                DBG_MSG_MQLFUNC_RETURN(HistoryDealGetString)
        #define HistoryDealGetTicket                DBG_MSG_MQLFUNC_RETURN(HistoryDealGetTicket)
        #define HistoryDealSelect                   DBG_MSG_MQLFUNC_RETURN(HistoryDealSelect)
        #define HistoryDealsTotal                   DBG_MSG_MQLFUNC_RETURN(HistoryDealsTotal)
        #define HistoryOrderGetDouble               DBG_MSG_MQLFUNC_RETURN(HistoryOrderGetDouble)
        #define HistoryOrderGetInteger              DBG_MSG_MQLFUNC_RETURN(HistoryOrderGetInteger)
        #define HistoryOrderGetString               DBG_MSG_MQLFUNC_RETURN(HistoryOrderGetString)
        #define HistoryOrderGetTicket               DBG_MSG_MQLFUNC_RETURN(HistoryOrderGetTicket)
        #define HistoryOrderSelect                  DBG_MSG_MQLFUNC_RETURN(HistoryOrderSelect)
        #define HistoryOrdersTotal                  DBG_MSG_MQLFUNC_RETURN(HistoryOrdersTotal)
        #define HistorySelect                       DBG_MSG_MQLFUNC_RETURN(HistorySelect)
        #define HistorySelectByPosition             DBG_MSG_MQLFUNC_RETURN(HistorySelectByPosition)

    #endif
    #define iBars                                   DBG_MSG_MQLFUNC_RETURN(iBars)
    #define iBarShift                               DBG_MSG_MQLFUNC_RETURN(iBarShift)
    #define iClose                                  DBG_MSG_MQLFUNC_RETURN(iClose)
    #define iHigh                                   DBG_MSG_MQLFUNC_RETURN(iHigh)
    #define iHighest                                DBG_MSG_MQLFUNC_RETURN(iHighest)
    #define iLow                                    DBG_MSG_MQLFUNC_RETURN(iLow)
    #define iLowest                                 DBG_MSG_MQLFUNC_RETURN(iLowest)
    #define iOpen                                   DBG_MSG_MQLFUNC_RETURN(iOpen)
    #define iTime                                   DBG_MSG_MQLFUNC_RETURN(iTime)
    #ifndef __MQL4_COMPATIBILITY_CODE__
        #define iTickVolume                         DBG_MSG_MQLFUNC_RETURN(iTickVolume)
        #define iRealVolume                         DBG_MSG_MQLFUNC_RETURN(iRealVolume)

    #endif
    #define iVolume                                 DBG_MSG_MQLFUNC_RETURN(iVolume)
    #ifndef __MQL4_COMPATIBILITY_CODE__
        #define iSpread                             DBG_MSG_MQLFUNC_RETURN(iSpread)

    #endif
    #define iAD                                     DBG_MSG_MQLFUNC_RETURN(iAD)
    #define iADX                                    DBG_MSG_MQLFUNC_RETURN(iADX)
    #ifndef __MQL4_COMPATIBILITY_CODE__
        #define iADXWilder                          DBG_MSG_MQLFUNC_RETURN(iADXWilder)

    #endif
    #define iAlligator                              DBG_MSG_MQLFUNC_RETURN(iAlligator)
    #ifndef __MQL4_COMPATIBILITY_CODE__
        #define iAMA                                DBG_MSG_MQLFUNC_RETURN(iAMA)

    #endif
    #define iAO                                     DBG_MSG_MQLFUNC_RETURN(iAO)
    #define iATR                                    DBG_MSG_MQLFUNC_RETURN(iATR)
    #define iBands                                  DBG_MSG_MQLFUNC_RETURN(iBands)
    #define iBearsPower                             DBG_MSG_MQLFUNC_RETURN(iBearsPower)
    #define iBullsPower                             DBG_MSG_MQLFUNC_RETURN(iBullsPower)
    #define iBWMFI                                  DBG_MSG_MQLFUNC_RETURN(iBWMFI)
    #define iCCI                                    DBG_MSG_MQLFUNC_RETURN(iCCI)
    #ifndef __MQL4_COMPATIBILITY_CODE__
        #define iChaikin                            DBG_MSG_MQLFUNC_RETURN(iChaikin)

    #endif
    #define iCustom                                 DBG_MSG_MQLFUNC_RETURN(iCustom)
    #ifndef __MQL4_COMPATIBILITY_CODE__
        #define iDEMA                               DBG_MSG_MQLFUNC_RETURN(iDEMA)

    #endif
    #define iDeMarker                               DBG_MSG_MQLFUNC_RETURN(iDeMarker)
    #define iEnvelopes                              DBG_MSG_MQLFUNC_RETURN(iEnvelopes)
    #define iForce                                  DBG_MSG_MQLFUNC_RETURN(iForce)
    #define iFractals                               DBG_MSG_MQLFUNC_RETURN(iFractals)
    #ifndef __MQL4_COMPATIBILITY_CODE__
        #define iFrAMA                              DBG_MSG_MQLFUNC_RETURN(iFrAMA)

    #endif
    #define iGator                                  DBG_MSG_MQLFUNC_RETURN(iGator)
    #define iIchimoku                               DBG_MSG_MQLFUNC_RETURN(iIchimoku)
    #define iMA                                     DBG_MSG_MQLFUNC_RETURN(iMA)
    #define iMACD                                   DBG_MSG_MQLFUNC_RETURN(iMACD)
    #define iMFI                                    DBG_MSG_MQLFUNC_RETURN(iMFI)
    #define iMomentum                               DBG_MSG_MQLFUNC_RETURN(iMomentum)
    #ifndef __MQL4_COMPATIBILITY_CODE__
        #define IndicatorCreate                     DBG_MSG_MQLFUNC_RETURN(IndicatorCreate)
        #define IndicatorParameters                 DBG_MSG_MQLFUNC_RETURN(IndicatorParameters)
        #define IndicatorRelease                    DBG_MSG_MQLFUNC_RETURN(IndicatorRelease)

    #endif
    #define IndicatorSetDouble                      DBG_MSG_MQLFUNC_RETURN(IndicatorSetDouble)
    #define IndicatorSetInteger                     DBG_MSG_MQLFUNC_RETURN(IndicatorSetInteger)
    #define IndicatorSetString                      DBG_MSG_MQLFUNC_RETURN(IndicatorSetString)
    #define IntegerToString                         DBG_MSG_MQLFUNC_RETURN(IntegerToString)
    #define iOBV                                    DBG_MSG_MQLFUNC_RETURN(iOBV)
    #define iOsMA                                   DBG_MSG_MQLFUNC_RETURN(iOsMA)
    #define iRSI                                    DBG_MSG_MQLFUNC_RETURN(iRSI)
    #define iRVI                                    DBG_MSG_MQLFUNC_RETURN(iRVI)
    #define iSAR                                    DBG_MSG_MQLFUNC_RETURN(iSAR)
    #define IsStopped                               DBG_MSG_MQLFUNC_RETURN(IsStopped)
    #define iStdDev                                 DBG_MSG_MQLFUNC_RETURN(iStdDev)
    #define iStochastic                             DBG_MSG_MQLFUNC_RETURN(iStochastic)
    #ifndef __MQL4_COMPATIBILITY_CODE__
        #define iTEMA                               DBG_MSG_MQLFUNC_RETURN(iTEMA)
        #define iTriX                               DBG_MSG_MQLFUNC_RETURN(iTriX)
        #define iVIDyA                              DBG_MSG_MQLFUNC_RETURN(iVIDyA)
        #define iVolumes                            DBG_MSG_MQLFUNC_RETURN(iVolumes)
        #define iWPR                                DBG_MSG_MQLFUNC_RETURN(iWPR)

    #endif
    #define log                                     DBG_MSG_MQLFUNC_RETURN(log)
    #define log10                                   DBG_MSG_MQLFUNC_RETURN(log10)
    #ifndef __MQL4_COMPATIBILITY_CODE__
        #define MarketBookAdd                       DBG_MSG_MQLFUNC_RETURN(MarketBookAdd)
        #define MarketBookGet                       DBG_MSG_MQLFUNC_RETURN(MarketBookGet)
        #define MarketBookRelease                   DBG_MSG_MQLFUNC_RETURN(MarketBookRelease)

    #endif
    #define MathAbs                                 DBG_MSG_MQLFUNC_RETURN(MathAbs)
    #define MathArccos                              DBG_MSG_MQLFUNC_RETURN(MathArccos)
    #define MathArcsin                              DBG_MSG_MQLFUNC_RETURN(MathArcsin)
    #define MathArctan                              DBG_MSG_MQLFUNC_RETURN(MathArctan)
    #define MathCeil                                DBG_MSG_MQLFUNC_RETURN(MathCeil)
    #define MathCos                                 DBG_MSG_MQLFUNC_RETURN(MathCos)
    #define MathExp                                 DBG_MSG_MQLFUNC_RETURN(MathExp)
    #define MathFloor                               DBG_MSG_MQLFUNC_RETURN(MathFloor)
    #define MathIsValidNumber                       DBG_MSG_MQLFUNC_RETURN(MathIsValidNumber)
    #define MathLog                                 DBG_MSG_MQLFUNC_RETURN(MathLog)
    #define MathLog10                               DBG_MSG_MQLFUNC_RETURN(MathLog10)
    #define MathMax                                 DBG_MSG_MQLFUNC_RETURN(MathMax)
    #define MathMin                                 DBG_MSG_MQLFUNC_RETURN(MathMin)
    #define MathMod                                 DBG_MSG_MQLFUNC_RETURN(MathMod)
    #define MathPow                                 DBG_MSG_MQLFUNC_RETURN(MathPow)
    #define MathRand                                DBG_MSG_MQLFUNC_RETURN(MathRand)
    #define MathRound                               DBG_MSG_MQLFUNC_RETURN(MathRound)
    #define MathSin                                 DBG_MSG_MQLFUNC_RETURN(MathSin)
    #define MathSqrt                                DBG_MSG_MQLFUNC_RETURN(MathSqrt)
    #define MathSrand                               DBG_MSG_MQLFUNC_RETURN(MathSrand)
    #define MathTan                                 DBG_MSG_MQLFUNC_RETURN(MathTan)
    #define MessageBox                              DBG_MSG_MQLFUNC(MessageBox)
    #ifndef __MQL4_COMPATIBILITY_CODE__
        #define MQLInfoInteger                      DBG_MSG_MQLFUNC_RETURN(MQLInfoInteger)

    #endif
    #define MQLInfoString                           DBG_MSG_MQLFUNC_RETURN(MQLInfoString)
    #define NormalizeDouble                         DBG_MSG_MQLFUNC_RETURN(NormalizeDouble)
    #define ObjectCreate                            DBG_MSG_MQLFUNC_RETURN(ObjectCreate)
    #define ObjectDelete                            DBG_MSG_MQLFUNC_RETURN(ObjectDelete)
    #define ObjectFind                              DBG_MSG_MQLFUNC_RETURN(ObjectFind)
    #define ObjectGetDouble                         DBG_MSG_MQLFUNC_RETURN(ObjectGetDouble)
    #define ObjectGetInteger                        DBG_MSG_MQLFUNC_RETURN(ObjectGetInteger)
    #define ObjectGetString                         DBG_MSG_MQLFUNC_RETURN(ObjectGetString)
    #define ObjectGetTimeByValue                    DBG_MSG_MQLFUNC_RETURN(ObjectGetTimeByValue)
    #define ObjectGetValueByTime                    DBG_MSG_MQLFUNC_RETURN(ObjectGetValueByTime)
    #define ObjectMove                              DBG_MSG_MQLFUNC_RETURN(ObjectMove)
    #define ObjectName                              DBG_MSG_MQLFUNC_RETURN(ObjectName)
    #define ObjectsDeleteAll                        DBG_MSG_MQLFUNC_RETURN(ObjectsDeleteAll)
    #define ObjectSetDouble                         DBG_MSG_MQLFUNC_RETURN(ObjectSetDouble)
    #define ObjectSetInteger                        DBG_MSG_MQLFUNC_RETURN(ObjectSetInteger)
    #define ObjectSetString                         DBG_MSG_MQLFUNC_RETURN(ObjectSetString)
    #define ObjectsTotal                            DBG_MSG_MQLFUNC_RETURN(ObjectsTotal)
    #ifndef __MQL4_COMPATIBILITY_CODE__
        #define OrderCalcMargin                     DBG_MSG_MQLFUNC_RETURN(OrderCalcMargin)
        #define OrderCalcProfit                     DBG_MSG_MQLFUNC_RETURN(OrderCalcProfit)
        #define OrderCheck                          DBG_MSG_MQLFUNC_RETURN(OrderCheck)

    #endif
    #define OrderGetDouble                          DBG_MSG_MQLFUNC_RETURN(OrderGetDouble)
    #ifndef __MQL4_COMPATIBILITY_CODE__
        #define OrderGetInteger                     DBG_MSG_MQLFUNC_RETURN(OrderGetInteger)
        #define OrderGetString                      DBG_MSG_MQLFUNC_RETURN(OrderGetString)
        #define OrderGetTicket                      DBG_MSG_MQLFUNC_RETURN(OrderGetTicket)
    #define OrderSelect                             DBG_MSG_MQLFUNC_RETURN(OrderSelect)

    #endif
    #define OrderSend                               DBG_MSG_MQLFUNC_RETURN(OrderSend)
    #ifndef __MQL4_COMPATIBILITY_CODE__
        #define OrderSendAsync                      DBG_MSG_MQLFUNC_RETURN(OrderSendAsync)
        #define OrdersTotal                         DBG_MSG_MQLFUNC_RETURN(OrdersTotal)
        #define ParameterGetRange                   DBG_MSG_MQLFUNC_RETURN(ParameterGetRange)
        #define ParameterSetRange                   DBG_MSG_MQLFUNC_RETURN(ParameterSetRange)

    #endif
    #define Period                                  DBG_MSG_MQLFUNC_RETURN(Period)
    #define PeriodSeconds                           DBG_MSG_MQLFUNC_RETURN(PeriodSeconds)
    #define PlaySound                               DBG_MSG_MQLFUNC_RETURN(PlaySound)
    #define PlotIndexGetInteger                     DBG_MSG_MQLFUNC_RETURN(PlotIndexGetInteger)
    #define PlotIndexSetDouble                      DBG_MSG_MQLFUNC_RETURN(PlotIndexSetDouble)
    #define PlotIndexSetInteger                     DBG_MSG_MQLFUNC_RETURN(PlotIndexSetInteger)
    #define PlotIndexSetString                      DBG_MSG_MQLFUNC_RETURN(PlotIndexSetString)
    #define Point                                   DBG_MSG_MQLFUNC_RETURN(Point)
    #ifndef __MQL4_COMPATIBILITY_CODE__
        #define PositionGetDouble                   DBG_MSG_MQLFUNC_RETURN(PositionGetDouble)
        #define PositionGetInteger                  DBG_MSG_MQLFUNC_RETURN(PositionGetInteger)
        #define PositionGetString                   DBG_MSG_MQLFUNC_RETURN(PositionGetString)
        #define PositionGetSymbol                   DBG_MSG_MQLFUNC_RETURN(PositionGetSymbol)
        #define PositionGetTicket                   DBG_MSG_MQLFUNC_RETURN(PositionGetTicket)
        #define PositionSelect                      DBG_MSG_MQLFUNC_RETURN(PositionSelect)
        #define PositionSelectByTicket              DBG_MSG_MQLFUNC_RETURN(PositionSelectByTicket)
        #define PositionsTotal                      DBG_MSG_MQLFUNC_RETURN(PositionsTotal)

    #endif
    #define pow                                     DBG_MSG_MQLFUNC_RETURN(pow)
    #define Print                                   DBG_MSG_MQLFUNC(Print)
    #define PrintFormat                             DBG_MSG_MQLFUNC(PrintFormat)
    #define rand                                    DBG_MSG_MQLFUNC_RETURN(rand)
    #define ResetLastError                          DBG_MSG_MQLFUNC(ResetLastError)
    #define ResourceCreate                          DBG_MSG_MQLFUNC_RETURN(ResourceCreate)
    #define ResourceFree                            DBG_MSG_MQLFUNC_RETURN(ResourceFree)
    #define ResourceReadImage                       DBG_MSG_MQLFUNC_RETURN(ResourceReadImage)
    #define ResourceSave                            DBG_MSG_MQLFUNC_RETURN(ResourceSave)
    #define round                                   DBG_MSG_MQLFUNC_RETURN(round)
    #define SendFTP                                 DBG_MSG_MQLFUNC_RETURN(SendFTP)
    #define SendMail                                DBG_MSG_MQLFUNC_RETURN(SendMail)
    #define SendNotification                        DBG_MSG_MQLFUNC_RETURN(SendNotification)
    #define SeriesInfoInteger                       DBG_MSG_MQLFUNC_RETURN(SeriesInfoInteger)
    #define SetIndexBuffer                          DBG_MSG_MQLFUNC_RETURN(SetIndexBuffer)
    #define ShortArrayToString                      DBG_MSG_MQLFUNC_RETURN(ShortArrayToString)
    #define ShortToString                           DBG_MSG_MQLFUNC_RETURN(ShortToString)
    #define SignalBaseGetDouble                     DBG_MSG_MQLFUNC_RETURN(SignalBaseGetDouble)
    #define SignalBaseGetInteger                    DBG_MSG_MQLFUNC_RETURN(SignalBaseGetInteger)
    #define SignalBaseGetString                     DBG_MSG_MQLFUNC_RETURN(SignalBaseGetString)
    #define SignalBaseSelect                        DBG_MSG_MQLFUNC_RETURN(SignalBaseSelect)
    #define SignalBaseTotal                         DBG_MSG_MQLFUNC_RETURN(SignalBaseTotal)
    #define SignalInfoGetDouble                     DBG_MSG_MQLFUNC_RETURN(SignalInfoGetDouble)
    #define SignalInfoGetInteger                    DBG_MSG_MQLFUNC_RETURN(SignalInfoGetInteger)
    #define SignalInfoGetString                     DBG_MSG_MQLFUNC_RETURN(SignalInfoGetString)
    #define SignalInfoSetDouble                     DBG_MSG_MQLFUNC_RETURN(SignalInfoSetDouble)
    #define SignalInfoSetInteger                    DBG_MSG_MQLFUNC_RETURN(SignalInfoSetInteger)
    #define SignalSubscribe                         DBG_MSG_MQLFUNC_RETURN(SignalSubscribe)
    #define SignalUnsubscribe                       DBG_MSG_MQLFUNC_RETURN(SignalUnsubscribe)
    #define sin                                     DBG_MSG_MQLFUNC_RETURN(sin)
    #define Sleep                                   DBG_MSG_MQLFUNC(Sleep)
    #ifndef __MQL4_COMPATIBILITY_CODE__
        #define SocketCreate                        DBG_MSG_MQLFUNC_RETURN(SocketCreate)
        #define SocketClose                         DBG_MSG_MQLFUNC_RETURN(SocketClose)
        #define SocketConnect                       DBG_MSG_MQLFUNC_RETURN(SocketConnect)
        #define SocketIsConnected                   DBG_MSG_MQLFUNC_RETURN(SocketIsConnected)
        #define SocketIsReadable                    DBG_MSG_MQLFUNC_RETURN(SocketIsReadable)
        #define SocketIsWritable                    DBG_MSG_MQLFUNC_RETURN(SocketIsWritable)
        #define SocketTimeouts                      DBG_MSG_MQLFUNC_RETURN(SocketTimeouts)
        #define SocketRead                          DBG_MSG_MQLFUNC_RETURN(SocketRead)
        #define SocketSend                          DBG_MSG_MQLFUNC_RETURN(SocketSend)
        #define SocketTlsHandshake                  DBG_MSG_MQLFUNC_RETURN(SocketTlsHandshake)
        #define SocketTlsCertificate                DBG_MSG_MQLFUNC_RETURN(SocketTlsCertificate)
        #define SocketTlsRead                       DBG_MSG_MQLFUNC_RETURN(SocketTlsRead)
        #define SocketTlsReadAvailable              DBG_MSG_MQLFUNC_RETURN(SocketTlsReadAvailable)
        #define SocketTlsSend                       DBG_MSG_MQLFUNC_RETURN(SocketTlsSend)

    #endif
    #define sqrt                                    DBG_MSG_MQLFUNC_RETURN(sqrt)
    #define srand                                   DBG_MSG_MQLFUNC(srand)
    #define StringAdd                               DBG_MSG_MQLFUNC_RETURN(StringAdd)
    #define StringBufferLen                         DBG_MSG_MQLFUNC_RETURN(StringBufferLen)
    #define StringCompare                           DBG_MSG_MQLFUNC_RETURN(StringCompare)
    #define StringConcatenate                       DBG_MSG_MQLFUNC_RETURN(StringConcatenate)
    #define StringFill                              DBG_MSG_MQLFUNC_RETURN(StringFill)
    #define StringFind                              DBG_MSG_MQLFUNC_RETURN(StringFind)
    #define StringFormat                            DBG_MSG_MQLFUNC_RETURN(StringFormat)
    #define StringGetCharacter                      DBG_MSG_MQLFUNC_RETURN(StringGetCharacter)
    #define StringInit                              DBG_MSG_MQLFUNC_RETURN(StringInit)
    #define StringLen                               DBG_MSG_MQLFUNC_RETURN(StringLen)
    #define StringReplace                           DBG_MSG_MQLFUNC_RETURN(StringReplace)
    #define StringSetCharacter                      DBG_MSG_MQLFUNC_RETURN(StringSetCharacter)
    #define StringSplit                             DBG_MSG_MQLFUNC_RETURN(StringSplit)
    #define StringSubstr                            DBG_MSG_MQLFUNC_RETURN(StringSubstr)
    #define StringToCharArray                       DBG_MSG_MQLFUNC_RETURN(StringToCharArray)
    #define StringToColor                           DBG_MSG_MQLFUNC_RETURN(StringToColor)
    #define StringToDouble                          DBG_MSG_MQLFUNC_RETURN(StringToDouble)
    #define StringToInteger                         DBG_MSG_MQLFUNC_RETURN(StringToInteger)
    #define StringToLower                           DBG_MSG_MQLFUNC_RETURN(StringToLower)
    #define StringToShortArray                      DBG_MSG_MQLFUNC_RETURN(StringToShortArray)
    #define StringToTime                            DBG_MSG_MQLFUNC_RETURN(StringToTime)
    #define StringToUpper                           DBG_MSG_MQLFUNC_RETURN(StringToUpper)
    #define StringTrimLeft                          DBG_MSG_MQLFUNC_RETURN(StringTrimLeft)
    #define StringTrimRight                         DBG_MSG_MQLFUNC_RETURN(StringTrimRight)
    #define StructToTime                            DBG_MSG_MQLFUNC_RETURN(StructToTime)
    #define Symbol                                  DBG_MSG_MQLFUNC_RETURN(Symbol)
    #define SymbolInfoDouble                        DBG_MSG_MQLFUNC_RETURN(SymbolInfoDouble)
    #define SymbolInfoInteger                       DBG_MSG_MQLFUNC_RETURN(SymbolInfoInteger)
    #ifndef __MQL4_COMPATIBILITY_CODE__
        #define SymbolInfoMarginRate                DBG_MSG_MQLFUNC_RETURN(SymbolInfoMarginRate)

    #endif
    #define SymbolInfoSessionQuote                  DBG_MSG_MQLFUNC_RETURN(SymbolInfoSessionQuote)
    #define SymbolInfoSessionTrade                  DBG_MSG_MQLFUNC_RETURN(SymbolInfoSessionTrade)
    #define SymbolInfoString                        DBG_MSG_MQLFUNC_RETURN(SymbolInfoString)
    #define SymbolInfoTick                          DBG_MSG_MQLFUNC_RETURN(SymbolInfoTick)
    #define SymbolIsSynchronized                    DBG_MSG_MQLFUNC_RETURN(SymbolIsSynchronized)
    #define SymbolName                              DBG_MSG_MQLFUNC_RETURN(SymbolName)
    #define SymbolSelect                            DBG_MSG_MQLFUNC_RETURN(SymbolSelect)
    #define SymbolsTotal                            DBG_MSG_MQLFUNC_RETURN(SymbolsTotal)
    #define tan                                     DBG_MSG_MQLFUNC_RETURN(tan)
    #define TerminalClose                           DBG_MSG_MQLFUNC_RETURN(TerminalClose)
    #define TerminalInfoDouble                      DBG_MSG_MQLFUNC_RETURN(TerminalInfoDouble)
    #ifndef __MQL4_COMPATIBILITY_CODE__
        #define TerminalInfoInteger                 DBG_MSG_MQLFUNC_RETURN(TerminalInfoInteger)

    #endif
    #define TerminalInfoString                      DBG_MSG_MQLFUNC_RETURN(TerminalInfoString)
    #define TesterStatistics                        DBG_MSG_MQLFUNC_RETURN(TesterStatistics)
    #define TextGetSize                             DBG_MSG_MQLFUNC_RETURN(TextGetSize)
    #define TextOut                                 DBG_MSG_MQLFUNC_RETURN(TextOut)
    #define TextSetFont                             DBG_MSG_MQLFUNC_RETURN(TextSetFont)
    #define TimeCurrent                             DBG_MSG_MQLFUNC_RETURN(TimeCurrent)
    #define TimeDaylightSavings                     DBG_MSG_MQLFUNC_RETURN(TimeDaylightSavings)
    #define TimeGMT                                 DBG_MSG_MQLFUNC_RETURN(TimeGMT)
    #define TimeGMTOffset                           DBG_MSG_MQLFUNC_RETURN(TimeGMTOffset)
    #define TimeLocal                               DBG_MSG_MQLFUNC_RETURN(TimeLocal)
    #define TimeToString                            DBG_MSG_MQLFUNC_RETURN(TimeToString)
    #define TimeToStruct                            DBG_MSG_MQLFUNC_RETURN(TimeToStruct)
    #ifndef __MQL4_COMPATIBILITY_CODE__
        #define TimeTradeServer                     DBG_MSG_MQLFUNC_RETURN(TimeTradeServer)

    #endif
    #define UninitializeReason                      DBG_MSG_MQLFUNC_RETURN(UninitializeReason)
    #define WebRequest                              DBG_MSG_MQLFUNC_RETURN(WebRequest)
    #define ZeroMemory                              DBG_MSG_MQLFUNC(ZeroMemory)

#endif
//
/////////////////////////////////////////////////////////////////////////////////////////////////////





/////////////////////////////////////////////////////////////////////////////////////////////////////
//
// Runtime code setup
//
#else
    // Define runtime mode

        #define LIB_DBG_DEBUG_MQH_RUNTIME_MODE


    // Clear any existing definitions

        #ifdef DBG_CODE_LOCATION
        #undef DBG_CODE_LOCATION
        #endif
        #ifdef DBG_DEBUGGER_FLAG_STATE
        #undef DBG_DEBUGGER_FLAG_STATE
        #endif
        #ifdef DBG_STR_EX45_FILEINFO
        #undef DBG_STR_EX45_FILEINFO
        #endif
        #ifdef DBG_STR
        #undef DBG_STR
        #endif
        #ifdef DBG_STR_PERSIST
        #undef DBG_STR_PERSIST
        #endif
        #ifdef DBG_STR_VAR
        #undef DBG_STR_VAR
        #endif
        #ifdef DBG_STR_VAR_PREFIX
        #undef DBG_STR_VAR_PREFIX
        #endif
        #ifdef DBG_STR_BOOL
        #undef DBG_STR_BOOL
        #endif
        #ifdef DBG_MSG
        #undef DBG_MSG
        #endif
        #ifdef DBG_MSG_SHIFT
        #undef DBG_MSG_SHIFT
        #endif
        #ifdef DBG_MSG_PERSIST
        #undef DBG_MSG_PERSIST
        #endif
        #ifdef DBG_MSG_VAR
        #undef DBG_MSG_VAR
        #endif
        #ifdef DBG_MSG_FUNC_RETVAL
        #undef DBG_MSG_FUNC_RETVAL
        #endif
        #ifdef DBG_MSG_VAR_IF
        #undef DBG_MSG_VAR_IF
        #endif
        #ifdef DBG_MSG_EVAL
        #undef DBG_MSG_EVAL
        #endif
        #ifdef DBG_MSG_EVAL_CMNT
        #undef DBG_MSG_EVAL_CMNT
        #endif
        #ifdef DBG_MSG_EVAL_IF
        #undef DBG_MSG_EVAL_IF
        #endif
        #ifdef DBG_MSG_EVAL_IF_CMNT
        #undef DBG_MSG_EVAL_IF_CMNT
        #endif
        #ifdef DBG_MSG_ARRAY_OUT_OF_RANGE
        #undef DBG_MSG_ARRAY_OUT_OF_RANGE
        #endif
        #ifdef DBG_MSG_ARRAY_INDEX_CHECK
        #undef DBG_MSG_ARRAY_INDEX_CHECK
        #endif
        #ifdef DBG_MSG_VARDUMP
        #undef DBG_MSG_VARDUMP
        #endif
        #ifdef DBG_MSG_LISTDUMP
        #undef DBG_MSG_LISTDUMP
        #endif
        #ifdef DBG_MSG_TRACE_BEGIN
        #undef DBG_MSG_TRACE_BEGIN
        #endif
        #ifdef DBG_MSG_TRACE_END
        #undef DBG_MSG_TRACE_END
        #endif
        #ifdef DBG_MSG_TRACE_RETURN
        #undef DBG_MSG_TRACE_RETURN
        #endif
        #ifdef DBG_MSG_TRACE_RETURN_VAR
        #undef DBG_MSG_TRACE_RETURN_VAR
        #endif
        #ifdef DBG_MSG_TRACE_RETURN_OBJ
        #undef DBG_MSG_TRACE_RETURN_OBJ
        #endif
        #ifdef DBG_MSG_NOTRACE_RETURN
        #undef DBG_MSG_NOTRACE_RETURN
        #endif
        #ifdef DBG_MSG_NOTRACE_RETURN_VAR
        #undef DBG_MSG_NOTRACE_RETURN_VAR
        #endif
        #ifdef DBG_MSG_NOTRACE_RETURN_OBJ
        #undef DBG_MSG_NOTRACE_RETURN_OBJ
        #endif
        #ifdef DBG_SET_UNINIT_REASON
        #undef DBG_SET_UNINIT_REASON
        #endif
        #ifdef DBG_MSG_UNINIT_RESOLVER
        #undef DBG_MSG_UNINIT_RESOLVER
        #endif
        #ifdef DBG_UNINIT_REASON
        #undef DBG_UNINIT_REASON
        #endif
        #ifdef DBG_STR_COMMENT
        #undef DBG_STR_COMMENT
        #endif
        #ifdef DBG_FILELOADER_VARNAME
        #undef DBG_FILELOADER_VARNAME
        #endif
        #ifdef DBG_MSG_TRACE_FILE_LOADER
        #undef DBG_MSG_TRACE_FILE_LOADER
        #endif
        #ifdef DBG_ASSERT
        #undef DBG_ASSERT
        #endif
        #ifdef DBG_ASSERT_LOG
        #undef DBG_ASSERT_LOG
        #endif
        #ifdef DBG_ASSERT_RETURN
        #undef DBG_ASSERT_RETURN
        #endif
        #ifdef DBG_ASSERT_RETURN_VAR
        #undef DBG_ASSERT_RETURN_VAR
        #endif
        #ifdef DBG_BREAK_ARRAY_OUT_OF_RANGE
        #undef DBG_BREAK_ARRAY_OUT_OF_RANGE
        #endif
        #ifdef DBG_SLEEP_SECONDS
        #undef DBG_SLEEP_SECONDS
        #endif
        #ifdef DBG_SOFT_BREAKPOINT
        #undef DBG_SOFT_BREAKPOINT
        #endif
        #ifdef DBG_SOFT_BREAKPOINT_TS
        #undef DBG_SOFT_BREAKPOINT_TS
        #endif
        #ifdef DBG_SOFT_BREAKPOINT_CONDITION
        #undef DBG_SOFT_BREAKPOINT_CONDITION
        #endif
        #ifdef DBG_SOFT_BREAKPOINT_EXEC_TIME
        #undef DBG_SOFT_BREAKPOINT_EXEC_TIME
        #endif
        #ifdef DBG_BREAK_IF
        #undef DBG_BREAK_IF
        #endif
        #ifdef DBG_BREAK_CONDITION_CREATE
        #undef DBG_BREAK_CONDITION_CREATE
        #endif
        #ifdef DBG_BREAK_CONDITION_ACTIVATE
        #undef DBG_BREAK_CONDITION_ACTIVATE
        #endif
        #ifdef DBG_BREAK_CONDITION_DEACTIVATE
        #undef DBG_BREAK_CONDITION_DEACTIVATE
        #endif
        #ifdef DBG_BREAK_CONDITION_ON_ID
        #undef DBG_BREAK_CONDITION_ON_ID
        #endif
        #ifdef DBG_TRACE_LOOP_BEGIN
        #undef DBG_TRACE_LOOP_BEGIN
        #endif
        #ifdef DBG_TRACE_LOOP_START
        #undef DBG_TRACE_LOOP_START
        #endif
        #ifdef DBG_TRACE_LOOP_FINISH
        #undef DBG_TRACE_LOOP_FINISH
        #endif
        #ifdef DBG_TRACE_LOOP_END
        #undef DBG_TRACE_LOOP_END
        #endif
        #ifdef DBG_TRACE_LOOP_BEGIN_ID
        #undef DBG_TRACE_LOOP_BEGIN_ID
        #endif
        #ifdef DBG_TRACE_LOOP_START_ID
        #undef DBG_TRACE_LOOP_START_ID
        #endif
        #ifdef DBG_TRACE_LOOP_FINISH_ID
        #undef DBG_TRACE_LOOP_FINISH_ID
        #endif
        #ifdef DBG_TRACE_LOOP_END_ID
        #undef DBG_TRACE_LOOP_END_ID
        #endif


    // EX5 File info string

        #define DBG_DEBUGGER_FLAG_STATE "[RELEASE]"
        #ifndef __MQL4_COMPATIBILITY_CODE__
            #define DBG_STR_EX45_FILEINFO StringFormat("MQL5 build: %i %s", __MQL5BUILD__, DBG_DEBUGGER_FLAG_STATE)

        #else
            #define DBG_STR_EX45_FILEINFO StringFormat("MQL4 Terminal build: %i; compiler build: %i %s", TerminalInfoInteger(TERMINAL_BUILD), __MQL4BUILD__, DBG_DEBUGGER_FLAG_STATE)

        #endif


    // Remove debug output and comments

        // Location string
        #define DBG_CODE_LOCATION(x)

        // Debug to string functions
        #define DBG_STR(x)
        #define DBG_STR_PERSIST(x) x
        #define DBG_STR_VAR(x)
        #define DBG_STR_VAR_PREFIX(x)
        #define DBG_STR_BOOL(x)

        // Debug std out
        #define DBG_MSG(x)
        #define DBG_MSG_IF(condition, message)
        #define DBG_MSG_FUNC_RETVAL(function_name)                          function_name
        #define DBG_MSG_EVAL(evalutaion_term)                               evalutaion_term
        #define DBG_MSG_EVAL_CMNT(message, evalutaion_term)                 evalutaion_term
        #define DBG_MSG_EVAL_IF(condition, evalutaion_term)                 evalutaion_term
        #define DBG_MSG_EVAL_IF_CMNT(condition, message, evalutaion_term)   evalutaion_term
        #define DBG_MSG_ARRAY_OUT_OF_RANGE(array, index)
        #define DBG_MSG_ARRAY_INDEX_CHECK(array, index)                     array[index]
        #define DBG_MSG_SHIFT
        #define DBG_MSG_PERSIST(message)                                    printf(message)
        #define DBG_MSG_VAR(x)
        #define DBG_MSG_VAR_IF(x, y)
        #define DBG_MSG_VARDUMP(x)
        #define DBG_MSG_LISTDUMP(x, y)

        // Code tracing helpers
        #define DBG_MSG_TRACE_BEGIN
        #define DBG_MSG_TRACE_END
        #define DBG_MSG_TRACE_RETURN                                        PERF_COUNTER_END return
        #define DBG_MSG_TRACE_RETURN_VAR(x)                                 PERF_COUNTER_END return(x)
        #define DBG_MSG_TRACE_RETURN_OBJ(x)                                 PERF_COUNTER_END return(x)
        #define DBG_MSG_NOTRACE_RETURN                                      PERF_COUNTER_END return
        #define DBG_MSG_NOTRACE_RETURN_VAR(x)                               PERF_COUNTER_END return(x)
        #define DBG_MSG_NOTRACE_RETURN_OBJ(x)                               PERF_COUNTER_END return(x)

        // Debug comments
        #define DBG_SET_UNINIT_REASON(x)
        #define DBG_MSG_UNINIT_RESOLVER
        #define DBG_UNINIT_REASON(x)
        #define DBG_STR_COMMENT(x) NULL
        #define DBG_MSG_TRACE_FILE_LOADER


    // Remove asserts

        #define DBG_ASSERT(condition, message)
        #define DBG_ASSERT_LOG(condition, message)
        #define DBG_ASSERT_RETURN_VOID(condition, message)
        #define DBG_ASSERT_RETURN(condition, message, return_value)
        #define DBG_BREAK_ARRAY_OUT_OF_RANGE(x, y)
        #define DBG_BREAK_IF(x)


    // Remove soft break points

        #define DBG_SLEEP_SECONDS(x)
        #define DBG_SOFT_BREAKPOINT
        #define DBG_SOFT_BREAKPOINT_TS(x)
        #define DBG_SOFT_BREAKPOINT_CONDITION(x)
        #define DBG_SOFT_BREAKPOINT_EXEC_TIME(x)
        #define DBG_BREAK_CONDITION_CREATE(x, y)
        #define DBG_BREAK_CONDITION_ACTIVATE(x, y)
        #define DBG_BREAK_CONDITION_DEACTIVATE(x, y)
        #define DBG_BREAK_CONDITION_ON_ID(x)


    // Loop tracing

        #define DBG_TRACE_LOOP_BEGIN
        #define DBG_TRACE_LOOP_START
        #define DBG_TRACE_LOOP_FINISH
        #define DBG_TRACE_LOOP_END
        #define DBG_TRACE_LOOP_BEGIN_ID(x)
        #define DBG_TRACE_LOOP_START_ID(x)
        #define DBG_TRACE_LOOP_FINISH_ID(x)
        #define DBG_TRACE_LOOP_END_ID(x)

//
/////////////////////////////////////////////////////////////////////////////////////////////////////





/////////////////////////////////////////////////////////////////////////////////////////////////////
//
// Performance profiling support
//
#ifdef LIB_PERF_PROFILING

    // Internal global counters
    #ifndef LIB_PERF_NAMESPACE
    #define LIB_PERF_NAMESPACE
        #ifndef __MQL4_COMPATIBILITY_CODE__
        namespace lib_perf
        {
        #endif
            static ulong LIB_DBG_NAMESPACE_DEF(lib_perf, perf_counters) = 0x00;
            static ulong LIB_DBG_NAMESPACE_DEF(lib_perf, perf_array)[];
            static ulong LIB_DBG_NAMESPACE_DEF(lib_perf, perf_min)[];
            static ulong LIB_DBG_NAMESPACE_DEF(lib_perf, perf_max)[];
            static ulong LIB_DBG_NAMESPACE_DEF(lib_perf, _call_counter)[];
            static ulong LIB_DBG_NAMESPACE_DEF(lib_perf, _perf_array)[];
            static ulong LIB_DBG_NAMESPACE_DEF(lib_perf, _perf_min)[];
            static ulong LIB_DBG_NAMESPACE_DEF(lib_perf, _perf_max)[];

            void LIB_DBG_NAMESPACE_DEF(lib_perf, perf_print_details)(const string func_id, const ulong exec_micros, const ulong avg_micros, const ulong min_micros, const ulong max_micros, const ulong call_count)
            { printf("%s: Runtime: %i microseconds; %s", func_id, exec_micros, (call_count < 2) ? "" : StringFormat("average(%i), min(%i), max(%i); total calls: %i", avg_micros, min_micros, max_micros, call_count)); };

            template <typename T>
            T LIB_DBG_NAMESPACE_DEF(lib_perf, perf_R_call)(const ulong start, T retval, const ulong end, const int perf_id, const string func_id)
            {
                if(ArraySize(_call_counter) <= (int)perf_id)
                {
                    const int prev_size = ArraySize(_call_counter);
                    ArrayResize(_call_counter, perf_id + 1, 512);
                    ArrayResize(_perf_array, perf_id + 1, 512);
                    ArrayResize(_perf_min, perf_id + 1, 512);
                    ArrayResize(_perf_max, perf_id + 1, 512);
                    ArrayFill(_call_counter, prev_size, perf_id + 1 - prev_size, 0);
                    ArrayFill(_perf_array, prev_size, perf_id + 1 - prev_size, 0);
                    ArrayFill(_perf_min, prev_size, perf_id + 1 - prev_size, ULONG_MAX);
                    ArrayFill(_perf_max, prev_size, perf_id + 1 - prev_size, 0);
                }

                // Update data
                const ulong exec_micros = (start > end) ? (start - end) : (end - start);
                _call_counter[perf_id]++;
                _perf_array[perf_id]   += exec_micros;
                _perf_min[perf_id]      = (_perf_min[perf_id] > exec_micros) ? exec_micros : _perf_min[perf_id];
                _perf_max[perf_id]      = (_perf_max[perf_id] < exec_micros) ? exec_micros : _perf_max[perf_id];

                // Print user info
                LIB_DBG_NAMESPACE_DEF(lib_perf, perf_print_details)(func_id, exec_micros, _perf_array[perf_id] / _call_counter[perf_id], _perf_min[perf_id], _perf_max[perf_id], _call_counter[perf_id]);
                return(retval);
            };

            template <typename T>
            T* LIB_DBG_NAMESPACE_DEF(lib_perf, perf_R_call)(const ulong start, T* retval, const ulong end, const int perf_id, const string func_id)
            {
                if(ArraySize(_call_counter) <= (int)perf_id)
                {
                    const int prev_size = ArraySize(_call_counter);
                    ArrayResize(_call_counter, perf_id + 1, 512);
                    ArrayResize(_perf_array, perf_id + 1, 512);
                    ArrayResize(_perf_min, perf_id + 1, 512);
                    ArrayResize(_perf_max, perf_id + 1, 512);
                    ArrayFill(_call_counter, prev_size, perf_id + 1 - prev_size, 0);
                    ArrayFill(_perf_array, prev_size, perf_id + 1 - prev_size, 0);
                    ArrayFill(_perf_min, prev_size, perf_id + 1 - prev_size, ULONG_MAX);
                    ArrayFill(_perf_max, prev_size, perf_id + 1 - prev_size, 0);
                }

                // Update data
                const ulong exec_micros = (start > end) ? (start - end) : (end - start);
                _call_counter[perf_id]++;
                _perf_array[perf_id]   += exec_micros;
                _perf_min[perf_id]      = (_perf_min[perf_id] > exec_micros) ? exec_micros : _perf_min[perf_id];
                _perf_max[perf_id]      = (_perf_max[perf_id] < exec_micros) ? exec_micros : _perf_max[perf_id];

                // Print user info
                LIB_DBG_NAMESPACE_DEF(lib_perf, perf_print_details)(func_id, exec_micros, _perf_array[perf_id] / _call_counter[perf_id], _perf_min[perf_id], _perf_max[perf_id], _call_counter[perf_id]);
                return(retval);
            };

            template <typename T>
            T LIB_DBG_NAMESPACE_DEF(lib_perf, perf_O_call)(const ulong start, T& retval, const ulong end, const int perf_id, const string func_id)
            {
                if(ArraySize(_call_counter) <= (int)perf_id)
                {
                    const int prev_size = ArraySize(_call_counter);
                    ArrayResize(_call_counter, perf_id + 1, 512);
                    ArrayResize(_perf_array, perf_id + 1, 512);
                    ArrayResize(_perf_min, perf_id + 1, 512);
                    ArrayResize(_perf_max, perf_id + 1, 512);
                    ArrayFill(_call_counter, prev_size, perf_id + 1 - prev_size, 0);
                    ArrayFill(_perf_array, prev_size, perf_id + 1 - prev_size, 0);
                    ArrayFill(_perf_min, prev_size, perf_id + 1 - prev_size, ULONG_MAX);
                    ArrayFill(_perf_max, prev_size, perf_id + 1 - prev_size, 0);
                }

                // Update data
                const ulong exec_micros = (start > end) ? (start - end) : (end - start);
                _call_counter[perf_id]++;
                _perf_array[perf_id]   += exec_micros;
                _perf_min[perf_id]      = (_perf_min[perf_id] > exec_micros) ? exec_micros : _perf_min[perf_id];
                _perf_max[perf_id]      = (_perf_max[perf_id] < exec_micros) ? exec_micros : _perf_max[perf_id];

                // Print user info
                LIB_DBG_NAMESPACE_DEF(lib_perf, perf_print_details)(func_id, exec_micros, _perf_array[perf_id] / _call_counter[perf_id], _perf_min[perf_id], _perf_max[perf_id], _call_counter[perf_id]);
                return(retval);
            };

            template <typename T>
            T* LIB_DBG_NAMESPACE_DEF(lib_perf, perf_O_call)(const ulong start, T* retval, const ulong end, const int perf_id, const string func_id)
            {
                if(ArraySize(_call_counter) <= (int)perf_id)
                {
                    const int prev_size = ArraySize(_call_counter);
                    ArrayResize(_call_counter, perf_id + 1, 512);
                    ArrayResize(_perf_array, perf_id + 1, 512);
                    ArrayResize(_perf_min, perf_id + 1, 512);
                    ArrayResize(_perf_max, perf_id + 1, 512);
                    ArrayFill(_call_counter, prev_size, perf_id + 1 - prev_size, 0);
                    ArrayFill(_perf_array, prev_size, perf_id + 1 - prev_size, 0);
                    ArrayFill(_perf_min, prev_size, perf_id + 1 - prev_size, ULONG_MAX);
                    ArrayFill(_perf_max, prev_size, perf_id + 1 - prev_size, 0);
                }

                // Update data
                const ulong exec_micros = (start > end) ? (start - end) : (end - start);
                _call_counter[perf_id]++;
                _perf_array[perf_id]   += exec_micros;
                _perf_min[perf_id]      = (_perf_min[perf_id] > exec_micros) ? exec_micros : _perf_min[perf_id];
                _perf_max[perf_id]      = (_perf_max[perf_id] < exec_micros) ? exec_micros : _perf_max[perf_id];

                // Print user info
                LIB_DBG_NAMESPACE_DEF(lib_perf, perf_print_details)(func_id, exec_micros, _perf_array[perf_id] / _call_counter[perf_id], _perf_min[perf_id], _perf_max[perf_id], _call_counter[perf_id]);
                return(retval);
            };

        #ifndef __MQL4_COMPATIBILITY_CODE__
        };
        #endif
    #endif

    // Performance output format string
    #define PERF_OUTPUT_FORMAT_ID(x, id, prefix)        LIB_DBG_NAMESPACE(lib_perf, perf_print_details)(StringFormat("%s%s", prefix, id), _perf_runtime_##x, (LIB_DBG_NAMESPACE(lib_perf, perf_array)[(int)_perf_id_##x] / _perf_calls_##x), LIB_DBG_NAMESPACE(lib_perf, perf_min)[(int)_perf_id_##x], LIB_DBG_NAMESPACE(lib_perf, perf_max)[(int)_perf_id_##x], _perf_calls_##x);
    #define PERF_OUTPUT_FORMAT(x)                       LIB_DBG_NAMESPACE(lib_perf, perf_print_details)(__FUNCTION__, _perf_runtime_##x, (LIB_DBG_NAMESPACE(lib_perf, perf_array)[(int)_perf_id_##x] / _perf_calls_##x), LIB_DBG_NAMESPACE(lib_perf, perf_min)[(int)_perf_id_##x], LIB_DBG_NAMESPACE(lib_perf, perf_max)[(int)_perf_id_##x], _perf_calls_##x)

    // Performance arrays
    #define PERF_SET_ARRAYS                             ((ulong)((ArrayResize(LIB_DBG_NAMESPACE(lib_perf, perf_array), (int)LIB_DBG_NAMESPACE(lib_perf, perf_counters), 512) > NULL) && (ArrayResize(LIB_DBG_NAMESPACE(lib_perf, perf_min), (int)LIB_DBG_NAMESPACE(lib_perf, perf_counters), 512) > NULL) && ((LIB_DBG_NAMESPACE(lib_perf, perf_min)[(int)LIB_DBG_NAMESPACE(lib_perf, perf_counters) - 1] = ULONG_MAX) > 0x00) && (ArrayResize(LIB_DBG_NAMESPACE(lib_perf, perf_max), (int)LIB_DBG_NAMESPACE(lib_perf, perf_counters), 512) > 0x00)  && ((LIB_DBG_NAMESPACE(lib_perf, perf_max)[(int)LIB_DBG_NAMESPACE(lib_perf, perf_counters) - 1] = 0x00) == 0x00)))
    #define PERF_UPDATE_COUNTERS(x)                     LIB_DBG_NAMESPACE(lib_perf, perf_array)[(int)_perf_id_##x] += _perf_runtime_##x; LIB_DBG_NAMESPACE(lib_perf, perf_min)[(int)_perf_id_##x] = (((LIB_DBG_NAMESPACE(lib_perf, perf_min)[(int)_perf_id_##x] > _perf_runtime_##x) || (LIB_DBG_NAMESPACE(lib_perf, perf_min)[(int)_perf_id_##x] == 0x00)) ? _perf_runtime_##x : LIB_DBG_NAMESPACE(lib_perf, perf_min)[(int)_perf_id_##x]); LIB_DBG_NAMESPACE(lib_perf, perf_max)[(int)_perf_id_##x] = ((LIB_DBG_NAMESPACE(lib_perf, perf_max)[(int)_perf_id_##x] < _perf_runtime_##x) ? _perf_runtime_##x : LIB_DBG_NAMESPACE(lib_perf, perf_max)[(int)_perf_id_##x]);

    // Counter init
    #define PERF_COUNTER_DEFINE_ID(x)                   const static ulong _perf_id_##x = LIB_DBG_NAMESPACE(lib_perf, perf_counters)++; static ulong _perf_start_##x = PERF_SET_ARRAYS; static ulong _perf_calls_##x = (LIB_DBG_NAMESPACE(lib_perf, perf_array)[(int)_perf_id_##x] = 0x00);

    // Counter start
    #define PERF_COUNTER_SET_ID(x)                      _perf_calls_##x++; _perf_start_##x = GetMicrosecondCount();

    // Display performance counter
    #define PERF_COUNTER_CLOSE_CUSTOM(y, x)             { const ulong _perf_runtime_##x = (GetMicrosecondCount() - _perf_start_##x); PERF_UPDATE_COUNTERS(x); PERF_OUTPUT_FORMAT_ID(x, #x, y) }
    #define PERF_COUNTER_CLOSE_ID(x)                    { const ulong _perf_runtime_##x = (GetMicrosecondCount() - _perf_start_##x); PERF_UPDATE_COUNTERS(x); PERF_OUTPUT_FORMAT_ID(x, #x, "") }
    #define PERF_COUNTER_CLOSE(x)                       { const ulong _perf_runtime_##x = (GetMicrosecondCount() - _perf_start_##x); PERF_UPDATE_COUNTERS(x); PERF_OUTPUT_FORMAT(x) }

    // Predefined function global performance counter macros
    #define PERF_COUNTER_BEGIN                          PERF_COUNTER_DEFINE_ID(__FUNCTION__) PERF_COUNTER_SET_ID(__FUNCTION__)
    #define PERF_COUNTER_END                            PERF_COUNTER_CLOSE(__FUNCTION__)
    #define PERF_COUNTER_BEGIN_ID(x)                    PERF_COUNTER_SET_ID(x)
    #define PERF_COUNTER_END_ID(x)                      PERF_COUNTER_CLOSE_ID(x)

    // Predefined standalone performance measurements
    #define PERF_COUNTER_TIMEIT_V(x)                    { PERF_COUNTER_DEFINE_ID(__LINE__); PERF_COUNTER_BEGIN_ID(__LINE__); x; PERF_COUNTER_CLOSE_CUSTOM(StringFormat("%s() @Line ", __FUNCTION__), __LINE__); }
    #define PERF_COUNTER_TIMEIT_R(x)                    LIB_DBG_NAMESPACE(lib_perf, perf_R_call)(GetMicrosecondCount(), (x), GetMicrosecondCount(), __COUNTER__, #x)
    #define PERF_COUNTER_TIMEIT_O(x)                    LIB_DBG_NAMESPACE(lib_perf, perf_O_call)(GetMicrosecondCount(), (x), GetMicrosecondCount(), __COUNTER__, #x)

#endif
#endif
//
/////////////////////////////////////////////////////////////////////////////////////////////////////





/////////////////////////////////////////////////////////////////////////////////////////////////////
//
// Remove performance profiling support
//
#ifndef LIB_PERF_PROFILING

    // Remove all performance collector code
    #ifndef PERF_COUNTER_DEFINE_ID
        #define PERF_COUNTER_DEFINE_ID(x)

    #endif

    #ifndef PERF_COUNTER_BEGIN_ID
        #define PERF_COUNTER_BEGIN_ID(x)

    #endif

    #ifndef PERF_COUNTER_END_ID
        #define PERF_COUNTER_END_ID(x)

    #endif

    #ifndef PERF_COUNTER_CLOSE
        #define PERF_COUNTER_CLOSE(x)

    #endif

    #ifndef PERF_COUNTER_BEGIN
        #define PERF_COUNTER_BEGIN

    #endif

    #ifndef PERF_COUNTER_END
        #define PERF_COUNTER_END

    #endif

    #ifndef PERF_COUNTER_TIMEIT_V
        #define PERF_COUNTER_TIMEIT_V(x)    x

    #endif

    #ifndef PERF_COUNTER_TIMEIT_R
        #define PERF_COUNTER_TIMEIT_R(x)    x

    #endif

    #ifndef PERF_COUNTER_TIMEIT_O
        #define PERF_COUNTER_TIMEIT_O(x)    x

    #endif


#endif
//
/////////////////////////////////////////////////////////////////////////////////////////////////////



//
// END Debugging support
//*********************************************************************************************************************************************************/
#endif // LIB_DEBUG_MQH_INCLUDED
