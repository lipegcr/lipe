//+------------------------------------------------------------------+
//|                                                     LibDebug.mq5 |
//|                                             Licensed under GPLv2 |
//|                                       https://www.freie-netze.de |
//+------------------------------------------------------------------+
#property copyright "GPLv2"
#property link      "https://www.gnu.org/licenses/old-licenses/gpl-2.0.html"
#property version   "1.00"








///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
// Include debugging library
//
//  Select operational mode:
//
//  - #define LIB_DEBUG
//      -> This will disable LIB_PERF_PROFILING and enable DEBUGGING extensions
//
//  - #define LIB_PERF_PROFILING
//      -> This will enable PERF_PROFILING macros. Only available in "runtime"-mode compilation.
//          If trying to measure these metrics while "_DEBUG" or "LIB_DEBUG" is defined will not work.
//
//  Define these before you include the library, as they define the included parts of the library.
//
//      LIB_DEBUG is superior to LIB_PERF_PROFILING and will disable LIB_PERF_PROFILING.
//
//  Debugging library supports output logging to file. This feature can be enabled by defining
//  "LIB_DEBUG_LOGFILE" as shown below. (Automatically also defines LIB_DEBUG)
//      Logs will be written to Common/* directory.
//
//      This feature supports debug logging within optimizer runs of the program.
//
//  Additionally the expert-journal output can be surpressed, separating the logs into two
//  targets. - This way logging debug output and logging terminal output is separated.
//
//  Define "LIB_DEBUG_NO_JOURNAL_OUTPUT" to disable expert-journal output from this library.
//
#define LIB_DEBUG
//#define LIB_DEBUG_LOGFILE
//#define LIB_DEBUG_NO_JOURNAL_OUTPUT
#define LIB_PERF_PROFILING
#include <lib_debug.mqh>



///////////////////////////////////////////////////////////////////////
//
// In OnInit you can see a simple usage of the debugging macros.
//
//  We will only use some stand-alone macros for quick debugging.
//
//  DBG_MSG()
//  DBG_MSG_VAR()
//  DBG_MSG_VAR_IF()
//
//  These macros support all built-in datatypes (also in form of arrays).
//      (unsigned) char, short, int, long
//      bool, datetime, color, complex, matrix, vector,
//      float, double,
//      string, enum, struct, class and interface as well as pointers.
//
//
//  And MQL structures:
//      MqlDateTime, MqlRates, MqlTick, MqlParam, MqlBookInfo,
//      MqlTradeRequest, MqlTradeCheckResult, MqlTradeResult,
//      MqlTradeTransaction,
//      MqlCalendarCountry, MqlCalendarEvent, MqlCalendarValue
//

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit() {
 DBG_MSG("Example how to use lib_debug.mqh");
 // Output details about current program
 printf("%s", DBG_STR_EX45_FILEINFO);
 EventSetTimer(10);
 // Output primitive variables
 ENUM_APPLIED_PRICE  e_val    = PRICE_CLOSE;
 char        c_val       = 1;
 uchar       uc_val      = 2;
 short       s_val       = 3;
 int         i_val       = 4;
 long        l_val       = 5;
 bool        b_val       = true;
 datetime    d_val       = TimeCurrent();
 color       clr_val     = clrAqua;
 string      str_val     = "Some string";
 complex     cmplx_val   = { 0.1, 0.2 };
 matrix      m_val(1, 2);
 matrixf     mf_val(1.3, 2.3);
 vector      v_val       = { 0, 1, 2, 3 };
 vectorf     vf_val      = { (float)0.1, (float)1.1, (float)2.1, (float)3.1 };
 complex  c1 = { 0.1, 0.2 };
 complex  c2 = { 0.3, 0.4 };
 complex  c3 = { 0.5, 0.6 };
 complex  c4 = { 0.6, 0.7 };
 matrixc     mc_val      {{c1, c2 }, {c3, c4 } };
 vectorc     vc_val      = { c1, c2, c3, c4 };
 //////////////////////////////////////////////////////////////
 //
 // Limitations of DBG_MSG_VAR() macro
 //
 //  Direct resolving of enumeration types does not work.
 //
 //DBG_MSG_VAR(PRICE_CLOSE);
 //DBG_MSG_VAR((ENUM_APPLIED_PRICE)PRICE_CLOSE);
 //
 //  Instead a variable must be passed.
 //
 //ENUM_APPLIED_PRICE  e_val    = PRICE_CLOSE;
 //DBG_MSG_VAR(e_val);
 // Direct value printing
 DBG_MSG_VAR(1);
 DBG_MSG_VAR(true);
 DBG_MSG_VAR(TimeCurrent());
 DBG_MSG_VAR(clrBlue);
 DBG_MSG_VAR("Print Me");
 DBG_MSG_VAR(0.25);
 DBG_MSG_VAR(e_val);
 DBG_MSG_VAR(c_val);
 DBG_MSG_VAR(uc_val);
 DBG_MSG_VAR(s_val);
 DBG_MSG_VAR(i_val);
 DBG_MSG_VAR(l_val);
 DBG_MSG_VAR(b_val);
 DBG_MSG_VAR(d_val);
 DBG_MSG_VAR(clr_val);
 DBG_MSG_VAR(str_val);
 DBG_MSG_VAR(cmplx_val);
 DBG_MSG_VAR(m_val);
 DBG_MSG_VAR(mf_val);
 DBG_MSG_VAR(mc_val);
 DBG_MSG_VAR(v_val);
 DBG_MSG_VAR(vf_val);
 DBG_MSG_VAR(vc_val);
 // Example of printing objects
 call_obj_function();
 //////////////////////////////////////////////////////////////
 //
 // Conditional execution of DBG_MSG_VAR() macro
 //
 //  Use DBG_MSG_VAR_IF() as shown below.
 //
 // NOTE: The fist statement is a boolean evaluation.
 //       It is encapuslated properly and therefore can
 //       be anything that evaluates to "true" or "false".
 //       Same rules apply as for an "if()" statement.
 bool printme = true;
 DBG_MSG_VAR_IF(printme, TimeLocal());
 // Output arrays
 int i_arr[50];
 for(int cnt = NULL; (cnt < 50) && !_StopFlag; cnt++) {
  i_arr[cnt] = MathRand(); }
 DBG_MSG_VAR(i_arr);
 matrixc mc_val1 {{c1, c2 }, {c3, c4 } };
 matrixc mc_val2 {{c2, c1 }, {c3, c4 } };
 matrixc mc_val3 {{c1, c2 }, {c4, c3 } };
 matrixc     mc_val_arr[3];
 mc_val_arr[0]       = mc_val1;
 mc_val_arr[1]       = mc_val2;
 mc_val_arr[2]       = mc_val3;
 DBG_MSG_VAR(mc_val_arr);
 string str_val_arr[3];
 DBG_MSG_VAR(str_val_arr);
 // Output MQL structures
 MqlDateTime             mql_dtm;
 MqlRates                mql_rates;
 MqlTick                 mql_tick;
 MqlParam                mql_param;
 MqlBookInfo             mql_book;
 MqlTradeRequest         mql_trade_request;
 MqlTradeCheckResult     mql_tradecheckresult;
 MqlTradeResult          mql_trade_result;
 MqlTradeTransaction     mql_transaction;
 MqlCalendarCountry      mql_cal_cntry;
 MqlCalendarEvent        mql_cal_event;
 MqlCalendarValue        mql_cal_value;
 DBG_MSG_VAR(mql_dtm);
 DBG_MSG_VAR(mql_rates);
 DBG_MSG_VAR(mql_tick);
 DBG_MSG_VAR(mql_param);
 DBG_MSG_VAR(mql_book);
 DBG_MSG_VAR(mql_trade_request);
 DBG_MSG_VAR(mql_tradecheckresult);
 DBG_MSG_VAR(mql_trade_result);
 DBG_MSG_VAR(mql_transaction);
 DBG_MSG_VAR(mql_cal_cntry);
 DBG_MSG_VAR(mql_cal_event);
 DBG_MSG_VAR(mql_cal_value);
 // Output arrays of structurees
 MqlDateTime             arr_mql_dtm[3];
 MqlRates                arr_mql_rates[3];
 MqlTick                 arr_mql_tick[3];
 MqlParam                arr_mql_param[3];
 MqlBookInfo             arr_mql_book[3];
 MqlTradeRequest         arr_mql_trade_request[3];
 MqlTradeCheckResult     arr_mql_tradecheckresult[3];
 MqlTradeResult          arr_mql_trade_result[3];
 MqlTradeTransaction     arr_mql_transaction[3];
 MqlCalendarCountry      arr_mql_cal_cntry[3];
 MqlCalendarEvent        arr_mql_cal_event[3];
 MqlCalendarValue        arr_mql_cal_value[3];
 DBG_MSG_VAR(arr_mql_dtm);
 DBG_MSG_VAR(arr_mql_rates);
 DBG_MSG_VAR(arr_mql_tick);
 DBG_MSG_VAR(arr_mql_param);
 DBG_MSG_VAR(arr_mql_book);
 DBG_MSG_VAR(arr_mql_trade_request);
 DBG_MSG_VAR(arr_mql_tradecheckresult);
 DBG_MSG_VAR(arr_mql_trade_result);
 DBG_MSG_VAR(arr_mql_transaction);
 DBG_MSG_VAR(arr_mql_cal_cntry);
 DBG_MSG_VAR(arr_mql_cal_event);
 DBG_MSG_VAR(arr_mql_cal_value);
 return(INIT_SUCCEEDED); }



///////////////////////////////////////////////////////////////////////
//
// In OnDeinit we will use full tracing of the function call.
//
//  First we define some helpers for compile time code
//  inclusion selection. This will make it easy to enable/disable
//  function tracing as needed.
//
//  To do this, first a macro is defined which will be used as a
//  switch (defined = trace function) (not defined = disable tracing)
//
//  We can collect these "switches" at top of file for a better overview
//  Also we could wrap them into a condition, so that they will only be
//  defined when debugging is enabled.
//
//  Example:
//  #ifdef LIB_DEBUG
//      #define DBG_TRACE_EXPERT_MAIN_ONDEINIT
//
//  #endif

// En/Disable function tracing by commenting following macro:
#define DBG_TRACE_EXPERT_MAIN_ONDEINIT


// Now we define the helper macros which will be used inside
//  the functions body.

//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
/////////////////////////////////////
// Function debug trace code
#ifdef DBG_TRACE_EXPERT_MAIN_ONDEINIT
#undef DBG_TRACE_EXPERT_MAIN_ONDEINIT
#define DBG_TRACE_EXPERT_MAIN_ONDEINIT(x) x
#define DBG_TRACE_EXPERT_MAIN_ONDEINIT_RETURN       DBG_MSG_TRACE_RETURN

#else
#define DBG_TRACE_EXPERT_MAIN_ONDEINIT(x)
#define DBG_TRACE_EXPERT_MAIN_ONDEINIT_RETURN       DBG_MSG_NOTRACE_RETURN

#endif
/////////////////////////////////////
void OnDeinit(const int reason) {
 /////////////////////////////////////
 //
 // TOP of function body
 //
 // Here the tracing code gets included, this is mandatory for tracing to work.
 // The switching macro can also be used to include additional
 // debugging code, if any is required, see example below.
 DBG_TRACE_EXPERT_MAIN_ONDEINIT(
  DBG_MSG_TRACE_BEGIN;
  // Additional details can be added here, as required.
  // For example to trace the inputs to this function, we can add
  DBG_MSG_VAR(reason);
  // Or whatever we would like to add.
 );
 // Additionally the macro "PERF_COUNTER_BEGIN" must be added.
 // It is mandatory to complete the "return" macro, irrespective of it
 // being used or not. (Any insertions will be removed for runtime builds,
 // if "LIB_PERF_PROFILING" is not defined)
 PERF_COUNTER_BEGIN;
 //
 // This concludes the functions head
 //  control code required for tracing.
 //  If tracing is disabled for this function,
 //  all additional code will be stripped at
 //  compile time.
 //
 //  Now follows the actual functions body:
 /////////////////////////////////////
 // Local init
 int     some_int_val    = 3;
 string  some_string     = "I dont know";
 /////////////////////////////////////
 //
 // As an example, here the local variables
 //  are printed, but only if tracing is enbaled.
 //  In contrast to the usage of macros in OnInit, where
 //  the macros were not wrapped in the
 //  Trace-Enable-Disable macro.
 //
 DBG_TRACE_EXPERT_MAIN_ONDEINIT(
  DBG_MSG_VAR(some_int_val);
  DBG_MSG_VAR(some_string);
 );
 // Destroy timer
 EventKillTimer();
 /////////////////////////////////////
 //
 // EXITING/RETURNING from the fucntions body.
 //
 // A return statement is mandatory, no matter the functions signature.
 // This will inform the debug library about the functions ending/exiting.
 //
 //  The special function "OnDeinit" will auto-resolve the deinit reason
 //  and show the state of the _StopFlag/IsStopped() variable.
 //  This is automatically inserted and needs no extra care taking.
 //
 DBG_TRACE_EXPERT_MAIN_ONDEINIT_RETURN; }




///////////////////////////////////////////////////////////////////////
//
// In OnTick we will use full tracing of the function call as
//  shown with OnDeinit, and we will integrate global performance
//  counters as well. This will give output of the runtime used by
//  this function.
//
//  Since the tracing has already been exlained, here is a
//  stripped version, showing the raw requirements for a full trace.
//
//  Short outline.
//  - First define the enable/disable macros.
//  - Then include the head required inside the body.
//  - Use the return macro at all exit points of the function.
//
//  To enable tracing for this function, same procedure as
//  with OnDeinit applies.
//  Again, this could be collected at top of file for better oversight.

// Turn on tracing
#define DBG_TRACE_EXPERT_MAIN_ONTICK


//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
/////////////////////////////////////
// Function debug trace code
#ifdef DBG_TRACE_EXPERT_MAIN_ONTICK
#undef DBG_TRACE_EXPERT_MAIN_ONTICK
#define DBG_TRACE_EXPERT_MAIN_ONTICK(x) x
#define DBG_TRACE_EXPERT_MAIN_ONTICK_RETURN         DBG_MSG_TRACE_RETURN

#else
#define DBG_TRACE_EXPERT_MAIN_ONTICK(x)
#define DBG_TRACE_EXPERT_MAIN_ONTICK_RETURN         DBG_MSG_NOTRACE_RETURN

#endif
/////////////////////////////////////
void OnTick() {
 DBG_TRACE_EXPERT_MAIN_ONTICK(
  DBG_MSG_TRACE_BEGIN;
 );
 PERF_COUNTER_BEGIN;
 // Local init
 int some_var = MathRand();
 // Some random check operation
 if((some_var % 2) == 0) {
  call_sub_function();
  call_sub2_function();
  call_obj_function(); }
 // Some eventual exit at annother point inside the functions body
 if((some_var % 2048) == 0) {
  DBG_TRACE_EXPERT_MAIN_ONTICK_RETURN; }
 // Return
 DBG_TRACE_EXPERT_MAIN_ONTICK_RETURN; }






///////////////////////////////////////////////////////////////////////
//
// In OnTimer we will use only the performance metrics macros.
//
//  For ease of use, a return macro will be defined. This is the
//  only requirement for performance metrics to be displayed in the
//  experts journal.
//
//  Performance macros are enabled only in release versions
//  of the code, they are disabled inside of debugging environments.
//
//  Debugging environment is defined by the flag LIB_DEBUG.
//  To enable performance macros, define LIB_PERF_PROFILING.
//
//  NOTE:
//      The macro "DBG_MSG_TRACE_RETURN" or "DBG_MSG_NOTRACE_RETURN"
//      must be used, so the performance control block will be properly closed.
//      Therefore we define relevant macros again, as shown in other examples.
//
//  Enable/disable tracing does not influence the perfomrance macros, as tracing
//  is only enabled when "LIB_DEBUG" is defined and "PERF_*"-macros are disabled.
//  You will get performance measurements when the global macro "LIB_PERF_PROFILING"
//  is defined and the global macro "LIB_DEBUG" is not defined.
//
//
// We can now define additional, custom performance blocks on a global level.
//  These work accross functions and can be used to trace certain parts of the
//  code. - Each block has its own call counter, therefore it is not advised
//  to reuse the blocks for different code sections, except of course thats
//  exactly what you want to measure.
//
// These blocks may overlap, if required. - It is necessary t ounderstand,
//  when doing so, you will also measure the times each macro takes. The execution
//  of these macros would be part of your measurement.
//
//  See example below.
//

// Create additional performance counters
//  IDs can be specified freely
PERF_COUNTER_DEFINE_ID(on_timer_for_loop);

// Additional example (these are not used)
PERF_COUNTER_DEFINE_ID(if_g_func);
PERF_COUNTER_DEFINE_ID(call_f3_func);
PERF_COUNTER_DEFINE_ID(printf_f1);
PERF_COUNTER_DEFINE_ID(printf_f2);

// Performance block IDs can be created on a global scope as well
//  as on function local scope and even in code blocks inside of
//  functions scope.


//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+
/////////////////////////////////////
// Function performance trace code
#define DBG_TRACE_EXPERT_MAIN_ONTIMER_RETURN        DBG_MSG_NOTRACE_RETURN

/////////////////////////////////////
void OnTimer() {
 PERF_COUNTER_BEGIN;
 // Measuring a loop
 double sum = NULL;
 PERF_COUNTER_BEGIN_ID(on_timer_for_loop);
 for(int cnt = NULL; (cnt < 1000000) && !_StopFlag; cnt++) {
  sum += 1.0; }
 PERF_COUNTER_END_ID(on_timer_for_loop);
 /////////////////////////////////////////////////////////////////////////////
 //
 // Here an example of possible nested performance blocks.
 // This example is very theoretical, but shows how blocks can be applied.
 //
 // Local scope
 {
  // These definitions can be on any scope in
  //  the hirarchy above this scope of the function all
  //  the way up to the global scope.
  PERF_COUNTER_DEFINE_ID(a_local_scope);
  PERF_COUNTER_DEFINE_ID(nested_level_1);
  PERF_COUNTER_DEFINE_ID(overlapping_block_a);
  PERF_COUNTER_DEFINE_ID(overlapping_block_b);
  // Begin measurement of most outer block
  PERF_COUNTER_BEGIN_ID(a_local_scope);
  // Have some code here (not mandatory)
  // Nested performance block 1
  PERF_COUNTER_BEGIN_ID(nested_level_1);
  // Have more code here
  // Overlapping execution block
  PERF_COUNTER_BEGIN_ID(overlapping_block_a);
  // Maybe some code here for block A
  // Open next block
  PERF_COUNTER_BEGIN_ID(overlapping_block_b);
  // Have some code here for block A and B (shared code block)
  // Now closing block A
  PERF_COUNTER_END_ID(overlapping_block_a);
  // Some code for block B
  // Now closing block B
  PERF_COUNTER_END_ID(overlapping_block_b);
  // Maybe more code here for nested level 1
  // Close nested block 1
  PERF_COUNTER_END_ID(nested_level_1);
  // Optionally have code here as well....
  // Close most outer block
  PERF_COUNTER_END_ID(a_local_scope); }
 // The above example will also measure the performance counters itself.
 //  Although they are held as short as possible, code-wise, it will
 //  have some influence on the pure code thats being measured.
 //
 //  The impact can vary, depending on the memory-paging that happens
 //  by accessing different areas of memory. - The variations will be
 //  within the margins of error and therefore can (mostly) be ignored.
 //
 /////////////////////////////////////////////////////////////////////////////
 /////////////////////////////////////////////////////////////////////////////
 //
 // Standalone performance macros example
 //
 //  To measure certain parts of code in a standalone environment,
 //  following macros are implemented to do this.
 //
 //  There are three variations of this macro available. Depending on
 //  the return value of the function to be measured, either having
 //  a return value, a return object or not having a return value, you
 //  need to use the appropiate macro.
 //
 //      PERF_COUNTER_TIMEIT_V   (V = void)
 //          This macro is used to measure functions or function sequences
 //          that do not have a return value.
 //
 //      PERF_COUNTER_TIMEIT_R   (R = return)
 //          This macro will return the resulting value (return value)
 //          of the function being called, or their combination of such.
 //          For a better understanding, see the examples below.
 //
 //      PERF_COUNTER_TIMEIT_O   (O = Object)
 //          This macro will return the object (returned by the function)
 //          of the function being called.
 //
 //  NOTE:
 //
 //      PERF_COUNTER_TIMEIT_V may not be mentioned more than once per line of code.
 //      Internally the macro uses the __LINE__ macro for identifying the call,
 //      therefore it is mandatory to have only one call per code line.
 //      Also be aware, if including this macro inside of another macro, all
 //      statements will be on one line of code.
 //
 //      PERF_COUNTER_TIMEIT_R uses the complier macro __COUNTER__ to identify
 //      unique its callings. Be aware, in case you rely on the sequence of
 //      counting provided by __COUNTER__ within your code. Each mentioning of
 //      the macro "PERF_COUNTER_TIMEIT_R" will increase the __COUNTER__ by one.
 //
 //      PERF_COUNTER_TIMEIT_O notes are same as for PERF_COUNTER_TIMEIT_R, with
 //      one addition: The Copy-Constructor of the returned object will be called
 //      twice. The first call contributes to the measurement results, the second
 //      consequently does not. In order to encapusalte the function calls, an
 //      additional copy of the object is required within the process of returning
 //      values from the function.
 //
 //      For pointers as return value, either macro "PERF_COUNTER_TIMEIT_R" or
 //      "PERF_COUNTER_TIMEIT_O" can be used. - Both work the same way in this case.
 //
 // A single function call
 PERF_COUNTER_TIMEIT_V(
  printf("Some text A");
 );
 // A block sequence of function calls
 PERF_COUNTER_TIMEIT_V(
  printf("Some text B");
  printf("Some text C");
 );
 // Example of complex measurements
 b_start();
 // Return
 DBG_TRACE_EXPERT_MAIN_ONTIMER_RETURN; }




//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int f1() {
 Sleep(100);
 return(1); }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int f2() {
 Sleep(200);
 return(2); }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int f3() {
 Sleep(300);
 return(3); }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int g() {
 return(PERF_COUNTER_TIMEIT_R(f1() + f2() + f3() == 6) ?
        PERF_COUNTER_TIMEIT_R(f1() * f2()) : 0); }

//+------------------------------------------------------------------+
//| Service program start function                                   |
//+------------------------------------------------------------------+
void b_start() {
 if (PERF_COUNTER_TIMEIT_R(g()) == 2) {
  PERF_COUNTER_TIMEIT_V(
   Print(f3() == 3);
  ); }
 PERF_COUNTER_TIMEIT_V(
  Print(f1());
 );
 PERF_COUNTER_TIMEIT_V(
  Print(f2());
 );
 return; };







///////////////////////////////////////////////////////////////////////
//
// In call_sub_function we will use full tracing of the function call.
//
//  This example shows the difference for a function with
//  a return value.
//
//  Take notice of the used macros. - It is required to use a
//  different return macro for this type of function call.
//
//  Instead of using the macro "DBG_MSG_TRACE_RETURN" and "DBG_MSG_NOTRACE_RETURN"
//  here the macros "DBG_MSG_TRACE_RETURN_VAR(x)" and "DBG_MSG_NOTRACE_RETURN_VAR(x)"
//  are used.
//
//  For use of objects of type "struct", "class" or "interface", a separate
//  return value macro must be used. - (This implementation is new in MQL5)
//
//  Returning objects from functions, use following macros:
//      "DBG_MSG_TRACE_RETURN_OBJ(x)" and "DBG_MSG_NOTRACE_RETURN_OBJ(x)"
//
//  For use with pointers as return value, either macro can be used, preferably use
//      "DBG_MSG_TRACE_RETURN_VAR(x)".
//
//  IMPORTANT NOTICE:
//      Calling the macro with the parameter "NULL" requires!!! a cast operation.
//      (This functions return value is "int", "const int" or "int" doesnt make a difference)
//
//      Example:
//      DBG_MSG_TRACE_RETURN_VAR((int)NULL);
//
//      This cast operation can be included in the macro definition itself, like this:
//      #define DBG_TRACE_EXPERT_MAIN_CALL_SUB_FUNCTION_RETURN(x) DBG_MSG_TRACE_RETURN_VAR((int)x)
//      #define DBG_TRACE_EXPERT_MAIN_CALL_SUB_FUNCTION_RETURN(x) DBG_MSG_NOTRACE_RETURN_VAR(x)
//
//      or inside the function using the custom defined macro:
//      DBG_TRACE_EXPERT_MAIN_CALL_SUB_FUNCTION_RETURN((int)NULL);
//
//      See second function example below.
//      Here the cast operation is inside the functions body.
//      NOTE: The runtime macro does not require the cast operation.
//
// Again the enbale trace macro needs to be defined, so tracing
//  is enabled.

// Enable tracing of this function
#define DBG_TRACE_EXPERT_MAIN_CALL_SUB_FUNCTION

//+------------------------------------------------------------------+
//| Example function with return value                               |
//+------------------------------------------------------------------+
/////////////////////////////////////
// Function debug trace code
#ifdef DBG_TRACE_EXPERT_MAIN_CALL_SUB_FUNCTION
#undef DBG_TRACE_EXPERT_MAIN_CALL_SUB_FUNCTION
#define DBG_TRACE_EXPERT_MAIN_CALL_SUB_FUNCTION(x) x
#define DBG_TRACE_EXPERT_MAIN_CALL_SUB_FUNCTION_RETURN(x) DBG_MSG_TRACE_RETURN_VAR(x)

#else
#define DBG_TRACE_EXPERT_MAIN_CALL_SUB_FUNCTION(x)
#define DBG_TRACE_EXPERT_MAIN_CALL_SUB_FUNCTION_RETURN(x) DBG_MSG_NOTRACE_RETURN_VAR(x)

#endif
/////////////////////////////////////
const int call_sub_function() {
 DBG_TRACE_EXPERT_MAIN_CALL_SUB_FUNCTION(
  DBG_MSG_TRACE_BEGIN;
 );
 PERF_COUNTER_BEGIN;
 // Do some stuff
 if(MathRand() == 5) {
  DBG_TRACE_EXPERT_MAIN_CALL_SUB_FUNCTION_RETURN(5); }
 // Return
 DBG_TRACE_EXPERT_MAIN_CALL_SUB_FUNCTION_RETURN((int)NULL); }







// Enable tracing of this function
#define DBG_TRACE_EXPERT_MAIN_CALL_SUB2_FUNCTION

//+------------------------------------------------------------------+
//| Example function with return value                               |
//+------------------------------------------------------------------+
/////////////////////////////////////
// Function debug trace code
#ifdef DBG_TRACE_EXPERT_MAIN_CALL_SUB2_FUNCTION
#undef DBG_TRACE_EXPERT_MAIN_CALL_SUB2_FUNCTION
#define DBG_TRACE_EXPERT_MAIN_CALL_SUB2_FUNCTION(x) x
#define DBG_TRACE_EXPERT_MAIN_CALL_SUB2_FUNCTION_RETURN(x) DBG_MSG_TRACE_RETURN_VAR((int)x)

#else
#define DBG_TRACE_EXPERT_MAIN_CALL_SUB2_FUNCTION(x)
#define DBG_TRACE_EXPERT_MAIN_CALL_SUB2_FUNCTION_RETURN(x) DBG_MSG_NOTRACE_RETURN_VAR(x)

#endif
/////////////////////////////////////
const int call_sub2_function() {
 DBG_TRACE_EXPERT_MAIN_CALL_SUB2_FUNCTION(
  DBG_MSG_TRACE_BEGIN;
 );
 PERF_COUNTER_BEGIN;
 // Do some stuff
 if(MathRand() == 12) {
  DBG_TRACE_EXPERT_MAIN_CALL_SUB2_FUNCTION_RETURN(12); }
 // Return
 DBG_TRACE_EXPERT_MAIN_CALL_SUB2_FUNCTION_RETURN(NULL); }






class CObj {
public:
 int test;

 CObj() :
  test(NULL)
 { };

 CObj(const CObj& p_in) {
  test = p_in.test;
  printf("COPY"); };


};


// Enable tracing of this function
#define DBG_TRACE_EXPERT_MAIN_CALL_OBJ_FUNCTION

//+------------------------------------------------------------------+
//| Example function with return object                              |
//+------------------------------------------------------------------+
/////////////////////////////////////
// Function debug trace code
#ifdef DBG_TRACE_EXPERT_MAIN_CALL_OBJ_FUNCTION
#undef DBG_TRACE_EXPERT_MAIN_CALL_OBJ_FUNCTION
#define DBG_TRACE_EXPERT_MAIN_CALL_OBJ_FUNCTION(x) x
#define DBG_TRACE_EXPERT_MAIN_CALL_OBJ_FUNCTION_RETURN(x) DBG_MSG_TRACE_RETURN_OBJ(x)

#else
#define DBG_TRACE_EXPERT_MAIN_CALL_OBJ_FUNCTION(x)
#define DBG_TRACE_EXPERT_MAIN_CALL_OBJ_FUNCTION_RETURN(x) DBG_MSG_NOTRACE_RETURN_OBJ(x)

#endif
/////////////////////////////////////
CObj call_obj_function() {
 DBG_TRACE_EXPERT_MAIN_CALL_OBJ_FUNCTION(
  DBG_MSG_TRACE_BEGIN;
 );
 PERF_COUNTER_BEGIN;
 // Local init
 CObj    test_obj;
 CObj*   test_ptr = NULL;
 DBG_MSG_VAR(1);
 DBG_MSG_VAR(test_obj);
 DBG_MSG_VAR(test_ptr);
 // Do some stuff
 if(MathRand() == 12) {
  DBG_TRACE_EXPERT_MAIN_CALL_OBJ_FUNCTION_RETURN(test_obj); }
 // Return
 DBG_TRACE_EXPERT_MAIN_CALL_OBJ_FUNCTION_RETURN(test_obj); }


//+------------------------------------------------------------------+
