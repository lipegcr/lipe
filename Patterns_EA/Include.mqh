//+------------------------------------------------------------------+
//|                                                      Include.mqh |
//|                        Copyright 2018, MetaQuotes Software Corp. |
//|                                                 https://mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, MetaQuotes Software Corp."
#property link      "https://mql5.com"
#property version   "1.00"
//+------------------------------------------------------------------+
//| Перечисление разрешённых типов позиций                           |
//+------------------------------------------------------------------+
enum ENUM_OPENED_MODE
  {
   OPENED_MODE_ANY,              // Qualquer posição
   OPENED_MODE_SWING,            // Sempre uma posição (swing)
   OPENED_MODE_BUY_ONE,          // Apenas uma posição de compra
   OPENED_MODE_BUY_MANY,         // Muitas posições de compra
   OPENED_MODE_SELL_ONE,         // Apenas uma posição de venda
   OPENED_MODE_SELL_MANY         // Muitas posições de venda
  };
//+------------------------------------------------------------------+
//| Перечисление типов ордеров для паттернов                         |
//+------------------------------------------------------------------+
enum ENUM_ORDER_TYPE_BY_PATTERN
  {
   ENUM_ORDER_TYPE_BY_PATT_BUY,  // Buy
   ENUM_ORDER_TYPE_BY_PATT_SELL  // Sell
  };
//+------------------------------------------------------------------+
//| Перечисление "Входной параметр On/Off"                           |
//+------------------------------------------------------------------+
enum ENUM_INPUT_ON_OFF
  {
   INPUT_ON    =  1,             // On
   INPUT_OFF   =  0              // Off
  };
//+------------------------------------------------------------------+
//| Перечисление "Входной параметр Yes/No"                           |
//+------------------------------------------------------------------+
enum ENUM_INPUT_YES_NO
  {
   INPUT_YES   =  1,             // Yes
   INPUT_NO    =  0              // No
  };
//+------------------------------------------------------------------+
//| Перечисление типов паттернов                                     |
//+------------------------------------------------------------------+
enum ENUM_PATTERN_TYPE
  {
   PATTERN_TYPE_DOUBLE_INSIDE,   // Double inside Bar
   PATTERN_TYPE_INSIDE,          // Inside Bar
   PATTERN_TYPE_OUTSIDE,         // Outside Bar
   PATTERN_TYPE_PINUP,           // Pin up
   PATTERN_TYPE_PINDOWN,         // Pin down
   PATTERN_TYPE_PPRUP,           // Pivot Point Reversal Up
   PATTERN_TYPE_PPRDN,           // Pivot Point Reversal Down
   PATTERN_TYPE_DBLHC,           // Double Bar Low With A Higher Close
   PATTERN_TYPE_DBHLC,           // Double Bar High With A Lower Close
   PATTERN_TYPE_CPRU,            // Close Price Reversal Up
   PATTERN_TYPE_CPRD,            // Close Price Reversal Down
   PATTERN_TYPE_NB,              // Neutral Bar
   PATTERN_TYPE_FBU,             // Force Bar Up
   PATTERN_TYPE_FBD,             // Force Bar Down
   PATTERN_TYPE_MB,              // Mirror Bar
   PATTERN_TYPE_HAMMER,          // Hammer Pattern
   PATTERN_TYPE_SHOOTSTAR,       // Shooting Star
   PATTERN_TYPE_EVSTAR,          // Evening Star
   PATTERN_TYPE_MORNSTAR,        // Morning Star
   PATTERN_TYPE_BEARHARAMI,      // Bearish Harami
   PATTERN_TYPE_BEARHARAMICROSS, // Bearish Harami Cross
   PATTERN_TYPE_BULLHARAMI,      // Bullish Harami
   PATTERN_TYPE_BULLHARAMICROSS, // Bullish Harami Cross
   PATTERN_TYPE_DARKCLOUD,       // Dark Cloud Cover
   PATTERN_TYPE_DOJISTAR,        // Doji Star
   PATTERN_TYPE_ENGBEARLINE,     // Engulfing Bearish Line
   PATTERN_TYPE_ENGBULLLINE,     // Engulfing Bullish Line
   PATTERN_TYPE_EVDJSTAR,        // Evening Doji Star
   PATTERN_TYPE_MORNDJSTAR,      // Morning Doji Star
   PATTERN_TYPE_NB2              // Two Neutral Bars
  };
#define TOTAL_PATTERNS           (30)
//+------------------------------------------------------------------+
//| Структура имён и флагов паттерна                                 |
//+------------------------------------------------------------------+
struct SDataNames
  {
   string            name_long;  // nome longo
   string            mame_short; // Nome curto
   bool              used_this;  // Bandeira de uso de padrão
   ENUM_ORDER_TYPE   order_type; // Tipo de pedido padrão
  };
//+------------------------------------------------------------------+
//| Структура входных данных паттерна                                |
//+------------------------------------------------------------------+
struct SDataInput
  {
   SDataNames  pattern[];        // Nomes e bandeiras
   bool        used_group1;      // Bandeira de uso do grupo 1
   bool        used_group2;      // Bandeira de uso do grupo 2
   bool        used_group3;      // Bandeira de uso do grupo 3
   double      equ_min;          // Valor mínimo de comparação
   string      font_name;        // Nome da fonte
   uint        font_size;        // Tamanho da fonte
   color       font_color;       // Cor da fonte
   bool        show_descript;    // Descrições de exibição
  };
//+------------------------------------------------------------------+
