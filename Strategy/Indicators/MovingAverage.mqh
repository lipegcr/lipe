//+------------------------------------------------------------------+
//|                                                MovingAverage.mqh |
//|                                 Copyright 2015, Vasiliy Sokolov. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2015, Vasiliy Sokolov."
#property link      "http://www.mql5.com"
#include <Strategy\Message.mqh>
#include <Strategy\Logs.mqh>
//+------------------------------------------------------------------+
//| defines                                                          |
//+------------------------------------------------------------------+
class CIndMovingAverage
  {
private:
   int               m_ma_handle;         // Indicator handle
   ENUM_TIMEFRAMES   m_timeframe;         // Timeframe
   int               m_ma_period;         // Period
   int               m_ma_shift;          // Shift
   string            m_symbol;            // Symbol
   ENUM_MA_METHOD    m_ma_method;         // Moving average method
   uint              m_applied_price;     // The handle of the indicator, on which you want to calculate the Moving Average value
                                          // or one of price values of ENUM_APPLIED_PRICE
   CLog*             m_log;               // Logging
   void              Init(void);
public:
                     CIndMovingAverage(void);

/*Params*/
   void              Timeframe(ENUM_TIMEFRAMES timeframe);
   void              MaPeriod(int ma_period);
   void              MaShift(int ma_shift);
   void              MaMethod(ENUM_MA_METHOD method);
   void              AppliedPrice(int source);
   void              Symbol(string symbol);

   ENUM_TIMEFRAMES   Timeframe(void);
   int               MaPeriod(void);
   int               MaShift(void);
   ENUM_MA_METHOD    MaMethod(void);
   uint              AppliedPrice(void);
   string            Symbol(void);

/*Out values*/
   double            OutValue(int index);
  };
//+------------------------------------------------------------------+
//| Default constructor.                                             |
//+------------------------------------------------------------------+
CIndMovingAverage::CIndMovingAverage(void) : m_ma_handle(INVALID_HANDLE),
                                             m_timeframe(PERIOD_CURRENT),
                                             m_ma_period(12),
                                             m_ma_shift(0),
                                             m_ma_method(MODE_SMA),
                                             m_applied_price(PRICE_CLOSE)
  {
   m_log=CLog::GetLog();
  }
//+------------------------------------------------------------------+
//| Initialization                                                   |
//+------------------------------------------------------------------+
void CIndMovingAverage::Init(void)
  {
   if(m_ma_handle!=INVALID_HANDLE)
     {
      bool res=IndicatorRelease(m_ma_handle);
      if(!res)
        {
         string text="Realise iMA indicator failed. Error ID: "+(string)GetLastError();
         CMessage *msg=new CMessage(MESSAGE_WARNING,__FUNCTION__,text);
         m_log.AddMessage(msg);
        }
     }
   m_ma_handle=iMA(m_symbol,m_timeframe,m_ma_period,m_ma_shift,m_ma_method,m_applied_price);
   if(m_ma_handle==INVALID_HANDLE)
     {
      string params="(Period:"+(string)m_ma_period+", Shift: "+(string)m_ma_shift+
                    ", MA Method:"+EnumToString(m_ma_method)+")";
      string text="Create iMA indicator failed"+params+". Error ID: "+(string)GetLastError();
      CMessage *msg=new CMessage(MESSAGE_ERROR,__FUNCTION__,text);
      m_log.AddMessage(msg);
     }
  }
//+------------------------------------------------------------------+
//| Setting timeframe.                                               |
//+------------------------------------------------------------------+
void CIndMovingAverage::Timeframe(ENUM_TIMEFRAMES tf)
  {
   m_timeframe=tf;
   if(m_ma_handle!=INVALID_HANDLE)
      Init();
  }
//+------------------------------------------------------------------+
//| Returns the current timeframe                                    |
//+------------------------------------------------------------------+
ENUM_TIMEFRAMES CIndMovingAverage::Timeframe(void)
  {
   return m_timeframe;
  }
//+------------------------------------------------------------------+
//| Sets the Moving Average averaging period.                        |
//+------------------------------------------------------------------+
void CIndMovingAverage::MaPeriod(int ma_period)
  {
   m_ma_period=ma_period;
   if(m_ma_handle!=INVALID_HANDLE)
      Init();
  }
//+------------------------------------------------------------------+
//| Returns the current averaging period of Moving Average.          |
//+------------------------------------------------------------------+
int CIndMovingAverage::MaPeriod(void)
  {
   return m_ma_period;
  }
//+------------------------------------------------------------------+
//| Sets the Moving Average type.                                    |
//+------------------------------------------------------------------+
void CIndMovingAverage::MaMethod(ENUM_MA_METHOD method)
  {
   m_ma_method=method;
   if(m_ma_handle!=INVALID_HANDLE)
      Init();
  }
//+------------------------------------------------------------------+
//| Returns the Moving Average type.                                 |
//+------------------------------------------------------------------+
ENUM_MA_METHOD CIndMovingAverage::MaMethod(void)
  {
   return m_ma_method;
  }
//+------------------------------------------------------------------+
//| Returns the Moving Average shift.                                |
//+------------------------------------------------------------------+
int CIndMovingAverage::MaShift(void)
  {
   return m_ma_shift;
  }
//+------------------------------------------------------------------+
//| Sets the Moving Average shhift.                                  |
//+------------------------------------------------------------------+
void CIndMovingAverage::MaShift(int ma_shift)
  {
   m_ma_shift=ma_shift;
   if(m_ma_handle!=INVALID_HANDLE)
      Init();
  }
//+------------------------------------------------------------------+
//| Sets the type of the price used for MA calculation.              |
//+------------------------------------------------------------------+
void CIndMovingAverage::AppliedPrice(int price)
  {
   m_applied_price = price;
   if(m_ma_handle != INVALID_HANDLE)
      Init();
  }
//+------------------------------------------------------------------+
//| Returns the type of the price used for MA calculation.           |
//+------------------------------------------------------------------+
uint CIndMovingAverage::AppliedPrice(void)
  {
   return m_applied_price;
  }
//+------------------------------------------------------------------+
//| Sets the symbol to calculate the indicator for                   |
//+------------------------------------------------------------------+
void CIndMovingAverage::Symbol(string symbol)
  {
   m_symbol=symbol;
   if(m_ma_handle!=INVALID_HANDLE)
      Init();
  }
//+------------------------------------------------------------------+
//| Returns the symbol the indicator is calculated for               |
//+------------------------------------------------------------------+
string CIndMovingAverage::Symbol(void)
  {
   return m_symbol;
  }
//+------------------------------------------------------------------+
//| Returns the value of the MA with index 'index'                   |
//+------------------------------------------------------------------+
double CIndMovingAverage::OutValue(int index)
  {
   if(m_ma_handle==INVALID_HANDLE)
      Init();
   double values[];
   if(CopyBuffer(m_ma_handle,0,index,1,values))
      return values[0];
   return EMPTY_VALUE;
  }
//+------------------------------------------------------------------+
