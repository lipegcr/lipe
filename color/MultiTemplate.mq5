//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright   "Tech-Assistent - by transcendreamer"
#property description "Technical Trading Assistant"
#property description "trades by your trend lines and level lines"
#property description "while you are away from terminal"
#property strict
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
#ifdef __MQL5__
#include <Trade\Trade.mqh>
CTrade trading;
CPositionInfo position;
#endif
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
input double            Lot_Default       =0.01;
input int               Lot_Digits        =2;
input int               Stop_Loss         =0;
input int               Take_Profit       =0;
input int               Trail_Start       =0;
input int               Trail_Size        =0;
input int               Gap_Protect       =900;
input bool              Only_Bid          =true;
input bool              Show_Average      =true;
input color             Text_Color        =Magenta;
input ENUM_BASE_CORNER  Text_Corner       =CORNER_RIGHT_UPPER;
input int               Magic_Number      =777;
input string            Order_Comment     ="XXX";
input int               Retry_Delay       =1000;
input int               Retry_Times       =20;
input bool              Manual_Confirm    =true;
input bool              Auto_Alerts       =false;
input int               Hotkey_Sell       =219;
input int               Hotkey_Buy        =221;
input int               Hotkey_Close      =220;
input int               Source_Window     =0;
input string            Source_Bar_0      ="";
input string            Source_Bar_1      ="";
input string            Source_Bar_2      ="";
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int YMARGIN=4;
int FONTSIZE=8;
string FONTNAME="Fixedsys";
int STATUS_OFFSET=380;
int BUY_OFFSET=240;
int SELL_OFFSET=186;
int CLOSE_OFFSET=115;
string MOD_SYMBOL=":";
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double profit_total=0;
double volume_total=0;
double average_buy=0;
double average_sell=0;
double current_ask=EMPTY_VALUE;
double current_bid=EMPTY_VALUE;
double previous_ask=EMPTY_VALUE;
double previous_bid=EMPTY_VALUE;
double value_bar_0=EMPTY_VALUE;
double value_bar_1=EMPTY_VALUE;
double value_bar_2=EMPTY_VALUE;
string acc_currency=AccountInfoString(ACCOUNT_CURRENCY);
bool source_mode=false;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnInit()
  {
#ifdef __MQL5__
   trading.SetTypeFillingBySymbol(_Symbol);
   trading.SetExpertMagicNumber(Magic_Number);
   trading.SetDeviationInPoints(0);
   trading.SetMarginMode();
#endif
   PlaceLabel("BUTTON_SELL",BUY_OFFSET,YMARGIN,Text_Corner,"<SELL>",Text_Color,FONTNAME,FONTSIZE);
   PlaceLabel("BUTTON_BUY",SELL_OFFSET,YMARGIN,Text_Corner,"<BUY>",Text_Color,FONTNAME,FONTSIZE);
   PlaceLabel("BUTTON_CLOSE",CLOSE_OFFSET,YMARGIN,Text_Corner,"<CLOSE>",Text_Color,FONTNAME,FONTSIZE);
   UpdateStatus();
   source_mode=(Source_Window!=0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   ObjectDelete(0,"BUTTON_SELL");
   ObjectDelete(0,"BUTTON_BUY");
   ObjectDelete(0,"BUTTON_CLOSE");
   ObjectDelete(0,"STATUS_LINE");
   ObjectDelete(0,"AVERAGE_BUY");
   ObjectDelete(0,"AVERAGE_SELL");
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnTick()
  {
   RunTrailing();
   RunMonitoring();
   UpdateStatus();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,const long &lparam,const double &dparam,const string &sparam)
  {
   if(id==CHARTEVENT_OBJECT_CLICK)
     {
      ObjectSetInteger(0,sparam,OBJPROP_STATE,false);
      if(sparam=="BUTTON_BUY")
        {
         TradeBuy(Lot_Default,false);
         UpdateStatus();
        }
      if(sparam=="BUTTON_SELL")
        {
         TradeSell(Lot_Default,false);
         UpdateStatus();
        }
      if(sparam=="BUTTON_CLOSE")
        {
         TradeCloseAll(false);
         UpdateStatus();
        }
     }
   if(id==CHARTEVENT_KEYDOWN)
     {
      if(int(lparam)==Hotkey_Buy)
        {
         TradeBuy(Lot_Default,false);
         UpdateStatus();
        }
      if(int(lparam)==Hotkey_Sell)
        {
         TradeSell(Lot_Default,false);
         UpdateStatus();
        }
      if(int(lparam)==Hotkey_Close)
        {
         TradeCloseAll(false);
         UpdateStatus();
        }
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool GetValues()
  {

   previous_ask=current_ask;
   previous_bid=current_bid;

   if(source_mode)
     {
      value_bar_0=GlobalVariableGet(Source_Bar_0);
      value_bar_1=GlobalVariableGet(Source_Bar_1);
      value_bar_2=GlobalVariableGet(Source_Bar_2);
      current_ask=value_bar_0;
      current_bid=value_bar_0;
     }
   else
     {
      current_bid=SymbolInfoDouble(_Symbol,SYMBOL_BID);
      if(Only_Bid)
         current_ask=current_bid;
      else
         current_ask=SymbolInfoDouble(_Symbol,SYMBOL_ASK);
     }

   if(previous_ask==EMPTY_VALUE)
      return false;
   if(previous_bid==EMPTY_VALUE)
      return false;
   if(current_ask==EMPTY_VALUE)
      return false;
   if(current_bid==EMPTY_VALUE)
      return false;

   if(MathAbs(current_ask-previous_ask)>Gap_Protect*_Point)
      return false;
   if(MathAbs(current_bid-previous_bid)>Gap_Protect*_Point)
      return false;

   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void RunMonitoring()
  {

   if(!GetValues())
      return;

   for(int i=0; i<ObjectsTotal(0,Source_Window); i++)
     {
      string name=ObjectName(0,i,Source_Window);
      long type=ObjectGetInteger(0,name,OBJPROP_TYPE);
      if(type!=OBJ_TREND && type!=OBJ_HLINE)
         continue;
      string text=ObjectGetString(0,name,OBJPROP_TEXT);

      bool type_buy        =(StringFind(text,"BUY")!=-1);
      bool type_sell       =(StringFind(text,"SELL")!=-1);
      bool type_close      =(StringFind(text,"CLOSE")!=-1);
      bool type_upward     =(StringFind(text,"UPWARD")!=-1);
      bool type_downward   =(StringFind(text,"DOWNWARD")!=-1);
      bool type_fix        =(StringFind(text,"FIX")!=-1);
      bool type_alert      =(StringFind(text,"ALERT")!=-1);
      bool type_disable    =(StringFind(text,"DISABLE")!=-1);
      bool type_spike      =(StringFind(text,"SPIKE")!=-1);
      bool type_rollback   =(StringFind(text,"ROLLBACK")!=-1);

      double trigger0=0;
      double trigger1=0;
      double trigger2=0;
      double trigger3=0;
      double trigger4=0;
      double modifier=0;

      if(StringFind(name,"Entry-")!=-1)
        {
         modifier=MathAbs(StringToDouble(text));
         if(modifier>0)
            type_buy=true;
         if(modifier<0)
            type_sell=true;
        }

      if(!type_buy && !type_sell && !type_close && !type_spike && !type_rollback &&
         !type_upward && !type_downward && !type_alert && !type_disable)
         continue;

      if(type==OBJ_TREND)
        {
         trigger0=ObjectGetValueByTime(0,name,TimeCurrent());
         trigger1=ObjectGetValueByTime(0,name,iTime(_Symbol,PERIOD_CURRENT,1));
         trigger2=ObjectGetValueByTime(0,name,iTime(_Symbol,PERIOD_CURRENT,2));
         trigger3=ObjectGetValueByTime(0,name,iTime(_Symbol,PERIOD_CURRENT,3));
         trigger4=ObjectGetValueByTime(0,name,iTime(_Symbol,PERIOD_CURRENT,4));
        }
      if(type==OBJ_HLINE)
        {
         trigger0=ObjectGetDouble(0,name,OBJPROP_PRICE);
         trigger1=trigger0;
         trigger2=trigger0;
         trigger3=trigger0;
         trigger4=trigger0;
        }

      if(trigger0==0)
         return;

      if(modifier==0)
        {
         int length=StringLen(text);
         int index=StringFind(text,MOD_SYMBOL);
         if(index!=-1)
            modifier=StringToDouble(StringSubstr(text,index+1,length-index-1));
        }

      bool cross_up = (previous_ask<trigger1 && current_ask>=trigger0);
      bool cross_dn = (previous_bid>trigger1 && current_bid<=trigger0);
      
      if(!cross_up)
         if(!cross_dn)
            continue;

      if(type_buy)
        {
         string message=_Symbol+": BUY LEVEL TRIGGERED";
         if(Auto_Alerts)
            Alert(message);
         else
            Print(message);
         if(modifier==0)
            modifier=Lot_Default;
         double volume_trade=NormalizeDouble(modifier,Lot_Digits);
         TradeBuy(volume_trade,true);
         ObjectSetString(0,name,OBJPROP_TEXT,"LONG:"+DoubleToString(modifier,Lot_Digits));
        }

      if(type_sell)
        {
         string message=_Symbol+": SELL LEVEL TRIGGERED";
         if(Auto_Alerts)
            Alert(message);
         else
            Print(message);
         if(modifier==0)
            modifier=Lot_Default;
         double volume_trade=NormalizeDouble(modifier,Lot_Digits);
         TradeSell(volume_trade,true);
         ObjectSetString(0,name,OBJPROP_TEXT,"SHORT:"+DoubleToString(modifier,Lot_Digits));
        }

      if(type_spike)
        {
         bool bar0=(iOpen(_Symbol,PERIOD_CURRENT,0)>=trigger0);
         bool bar1=(iLow(_Symbol,PERIOD_CURRENT,1)<trigger1);
         bool bar2=(iLow(_Symbol,PERIOD_CURRENT,2)<trigger2);
         bool bar3=(iLow(_Symbol,PERIOD_CURRENT,3)>trigger3);
         bool bar4=(iLow(_Symbol,PERIOD_CURRENT,4)>trigger4);
         if(bar0 && (bar1 || bar2) && bar3 && bar4)
           {
            string message=_Symbol+": BUY SPIKE DETECTED";
            if(Auto_Alerts)
               Alert(message);
            else
               Print(message);
            if(modifier==0)
               modifier=Lot_Default;
            double volume_trade=NormalizeDouble(modifier,Lot_Digits);
            TradeBuy(volume_trade,true);
            ObjectSetString(0,name,OBJPROP_TEXT,"LONG:"+DoubleToString(modifier,Lot_Digits));
           }
        }

      if(type_spike)
        {
         bool bar0=(iOpen(_Symbol,PERIOD_CURRENT,0)<=trigger0);
         bool bar1=(iHigh(_Symbol,PERIOD_CURRENT,1)>trigger1);
         bool bar2=(iHigh(_Symbol,PERIOD_CURRENT,2)>trigger2);
         bool bar3=(iHigh(_Symbol,PERIOD_CURRENT,3)<trigger3);
         bool bar4=(iHigh(_Symbol,PERIOD_CURRENT,4)<trigger4);
         if(bar0 && (bar1 || bar2) && bar3 && bar4)
           {
            string message=_Symbol+": SELL SPIKE DETECTED";
            if(Auto_Alerts)
               Alert(message);
            else
               Print(message);
            if(modifier==0)
               modifier=Lot_Default;
            double volume_trade=NormalizeDouble(modifier,Lot_Digits);
            TradeSell(volume_trade,true);
            ObjectSetString(0,name,OBJPROP_TEXT,"SHORT:"+DoubleToString(modifier,Lot_Digits));
           }
        }

      if(type_rollback)
        {
         bool bar0=(value_bar_0>=trigger0);
         bool bar1=(value_bar_1<trigger1);
         bool bar2=(value_bar_2>trigger2);
         if(bar0 && bar1 && bar2)
           {
            string message=_Symbol+": BUY ROLLBACK DETECTED";
            if(Auto_Alerts)
               Alert(message);
            else
               Print(message);
            if(modifier==0)
               modifier=Lot_Default;
            double volume_trade=NormalizeDouble(modifier,Lot_Digits);
            TradeBuy(volume_trade,true);
            ObjectSetString(0,name,OBJPROP_TEXT,"LONG:"+DoubleToString(modifier,Lot_Digits));
           }
        }

      if(type_rollback)
        {
         bool bar0=(value_bar_0<=trigger0);
         bool bar1=(value_bar_1>trigger1);
         bool bar2=(value_bar_2<trigger2);
         if(bar0 && bar1 && bar2)
           {
            string message=_Symbol+": SELL ROLLBACK DETECTED";
            if(Auto_Alerts)
               Alert(message);
            else
               Print(message);
            if(modifier==0)
               modifier=Lot_Default;
            double volume_trade=NormalizeDouble(modifier,Lot_Digits);
            TradeSell(volume_trade,true);
            ObjectSetString(0,name,OBJPROP_TEXT,"SHORT:"+DoubleToString(modifier,Lot_Digits));
           }
        }

      volume_total=GetVolume();

      if(type_upward)
         if(volume_total<=0)
           {
            string message=_Symbol+": UPWARD LEVEL TRIGGERED";
            if(Auto_Alerts)
               Alert(message);
            else
               Print(message);
            if(modifier==0)
               modifier=1;
            double volume_trade=(volume_total==0)?Lot_Default:
                                NormalizeDouble(MathAbs(volume_total)*(1+modifier),Lot_Digits);
            TradeBuy(volume_trade,true);
           }

      if(type_downward)
         if(volume_total>=0)
           {
            string message=_Symbol+": DOWNWARD LEVEL TRIGGERED";
            if(Auto_Alerts)
               Alert(message);
            else
               Print(message);
            if(modifier==0)
               modifier=1;
            double volume_trade=(volume_total==0)?Lot_Default:
                                NormalizeDouble(MathAbs(volume_total)*(1+modifier),Lot_Digits);
            TradeSell(volume_trade,true);
           }

      if(type_close)
         if(volume_total!=0)
           {
            string message=_Symbol+": CLOSE LEVEL TRIGGERED";
            if(Auto_Alerts)
               Alert(message);
            else
               Print(message);
            TradeCloseAll(true);
            ObjectSetString(0,name,OBJPROP_TEXT,"EXIT");
           }

      if(type_fix)
         if(volume_total!=0)
           {
            string message=_Symbol+": FIX LEVEL TRIGGERED";
            if(Auto_Alerts)
               Alert(message);
            else
               Print(message);
            TradeCloseAll(true);
           }

      if(type_alert)
        {
         string message=_Symbol+": "+DoubleToString(trigger0,_Digits)+" LEVEL REACHED";
         if(Auto_Alerts)
            Alert(message);
         else
            Print(message);
         ObjectSetString(0,name,OBJPROP_TEXT,"LEVEL");
        }

      if(type_disable)
        {
         if(Auto_Alerts)
            Alert(_Symbol+": ALL LINES DISABLED");
         else
            Print(_Symbol+": ALL LINES DISABLED");
         DisableAllLines();
        }
     }

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void DisableAllLines()
  {
   for(int i=0; i<ObjectsTotal(0,Source_Window); i++)
     {
      string name=ObjectName(0,i,Source_Window);
      long type=ObjectGetInteger(0,name,OBJPROP_TYPE);
      if(type!=OBJ_TREND && type!=OBJ_HLINE)
         continue;
      string text=ObjectGetString(0,name,OBJPROP_TEXT);

      bool type_buy        =(StringFind(text,"BUY")!=-1);
      bool type_sell       =(StringFind(text,"SELL")!=-1);
      bool type_close      =(StringFind(text,"CLOSE")!=-1);
      bool type_upward     =(StringFind(text,"UPWARD")!=-1);
      bool type_downward   =(StringFind(text,"DOWNWARD")!=-1);
      bool type_fix        =(StringFind(text,"FIX")!=-1);
      bool type_alert      =(StringFind(text,"ALERT")!=-1);
      bool type_disable    =(StringFind(text,"DISABLE")!=-1);
      bool type_spike      =(StringFind(text,"SPIKE")!=-1);
      bool type_rollback   =(StringFind(text,"ROLLBACK")!=-1);

      double modifier=0;
      int length=StringLen(text);
      int index=StringFind(text,MOD_SYMBOL);
      if(index!=-1)
         modifier=StringToDouble(StringSubstr(text,index+1,length-index-1));

      if(type_buy)
         ObjectSetString(0,name,OBJPROP_TEXT,"buy:"+DoubleToString(modifier,Lot_Digits));
      if(type_sell)
         ObjectSetString(0,name,OBJPROP_TEXT,"sell:"+DoubleToString(modifier,Lot_Digits));
      if(type_close)
         ObjectSetString(0,name,OBJPROP_TEXT,"close");
      if(type_upward)
         ObjectSetString(0,name,OBJPROP_TEXT,"upward:"+DoubleToString(modifier,2));
      if(type_downward)
         ObjectSetString(0,name,OBJPROP_TEXT,"downward:"+DoubleToString(modifier,2));
      if(type_fix)
         ObjectSetString(0,name,OBJPROP_TEXT,"fix");
      if(type_disable)
         ObjectSetString(0,name,OBJPROP_TEXT,"disable");
      if(type_spike)
         ObjectSetString(0,name,OBJPROP_TEXT,"spike:"+DoubleToString(modifier,Lot_Digits));
      if(type_rollback)
         ObjectSetString(0,name,OBJPROP_TEXT,"rollback:"+DoubleToString(modifier,Lot_Digits));
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void UpdateStatus()
  {
   GetTradeData(profit_total,volume_total,average_buy,average_sell);

   string text=_Symbol+
               "   Volume: "+DoubleToString(volume_total,Lot_Digits)+
               "   Profit: "+DoubleToString(profit_total,2)+" "+acc_currency;
   PlaceLabel("STATUS_LINE",STATUS_OFFSET,YMARGIN,Text_Corner,text,Text_Color,FONTNAME,FONTSIZE);

   if(Show_Average)
     {
      if(average_buy!=0)
         PlaceHorizontal("AVERAGE_BUY",average_buy,Green,STYLE_DASHDOTDOT);
      else
         ObjectDelete(0,"AVERAGE_BUY");
      if(average_sell!=0)
         PlaceHorizontal("AVERAGE_SELL",average_sell,Green,STYLE_DASHDOTDOT);
      else
         ObjectDelete(0,"AVERAGE_SELL");
     }

   ChartRedraw(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void TradeBuy(double lot,bool auto)
  {

   bool check=false;

   if(!auto && Manual_Confirm)
     {
      string text="OPENING LONG: "+_Symbol+" "+DoubleToString(lot,Lot_Digits)+" LOTS";
      if(MessageBox(text,"",MB_OKCANCEL|MB_ICONINFORMATION)==IDCANCEL)
         return;
     }

#ifdef __MQL5__

   for(int i=0; i<Retry_Times; i++)
     {
      double price=SymbolInfoDouble(_Symbol,SYMBOL_ASK);
      double SL=(Stop_Loss==0)   ? 0 : NormalizeDouble(price-Stop_Loss*_Point,_Digits);
      double TP=(Take_Profit==0) ? 0 : NormalizeDouble(price+Take_Profit*_Point,_Digits);
      check=trading.Buy(lot,_Symbol,price,SL,TP,Order_Comment);
      if(check)
         break;
      Print("#",Magic_Number,": TRADING ERROR ",trading.ResultRetcode());
      Sleep(Retry_Delay);
     }

#else

   for(int i=0; i<Retry_Times; i++)
     {
      double price=SymbolInfoDouble(_Symbol,SYMBOL_ASK);
      double SL=(Stop_Loss==0)   ? 0 : NormalizeDouble(price-Stop_Loss*_Point,_Digits);
      double TP=(Take_Profit==0) ? 0 : NormalizeDouble(price+Take_Profit*_Point,_Digits);
      int ticket=OrderSend(_Symbol,OP_BUY,lot,price,0,SL,TP,Order_Comment,Magic_Number,0,clrLime);
      if(ticket!=-1)
        {
         check=true;
         break;
        }
      Print("#",Magic_Number,": TRADING ERROR ",GetLastError());
      Sleep(Retry_Delay);
     }

#endif

   if(!check)
      Alert("#",Magic_Number,": BUY OPERATION FAILED");

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void TradeSell(double lot,bool auto)
  {

   bool check=false;

   if(!auto && Manual_Confirm)
     {
      string text="OPENING SHORT: "+_Symbol+" "+DoubleToString(lot,Lot_Digits)+" LOTS";
      if(MessageBox(text,"",MB_OKCANCEL|MB_ICONINFORMATION)==IDCANCEL)
         return;
     }

#ifdef __MQL5__

   for(int i=0; i<Retry_Times; i++)
     {
      double price=SymbolInfoDouble(_Symbol,SYMBOL_BID);
      double SL=(Stop_Loss==0)   ? 0 : NormalizeDouble(price+Stop_Loss*_Point,_Digits);
      double TP=(Take_Profit==0) ? 0 : NormalizeDouble(price-Take_Profit*_Point,_Digits);
      check=trading.Sell(lot,_Symbol,price,SL,TP,Order_Comment);
      if(check)
         break;
      Print("#",Magic_Number,": TRADING ERROR ",trading.ResultRetcode());
      Sleep(Retry_Delay);
     }

#else

   for(int i=0; i<Retry_Times; i++)
     {
      double price=SymbolInfoDouble(_Symbol,SYMBOL_BID);
      double SL=(Stop_Loss==0)   ? 0 : NormalizeDouble(price+Stop_Loss*_Point,_Digits);
      double TP=(Take_Profit==0) ? 0 : NormalizeDouble(price-Take_Profit*_Point,_Digits);
      int ticket=OrderSend(_Symbol,OP_SELL,lot,price,0,SL,TP,Order_Comment,Magic_Number,0,clrRed);
      if(ticket!=-1)
        {
         check=true;
         break;
        }
      Print("#",Magic_Number,": TRADING ERROR ",GetLastError());
      Sleep(Retry_Delay);
     }

#endif

   if(!check)
      Alert("#",Magic_Number,": SELL OPERATION FAILED");
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void TradeCloseAll(bool auto)
  {

   if(!auto && Manual_Confirm)
     {
      string text="CLOSING ALL POSITIONS: "+_Symbol;
      if(MessageBox(text,"",MB_OKCANCEL|MB_ICONINFORMATION)==IDCANCEL)
         return;
     }

#ifdef __MQL5__

   for(int i=PositionsTotal()-1; i>=0; i--)
     {
      if(!position.SelectByIndex(i))
         continue;
      if(position.Magic()!=Magic_Number)
         continue;
      if(position.Symbol()!=_Symbol)
         continue;
      TradeClose(position.Ticket());
     }

#else

   for(int i=OrdersTotal()-1; i>=0; i--)
     {
      if(!OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
         continue;
      if(OrderMagicNumber()!=Magic_Number)
         continue;
      if(OrderSymbol()!=_Symbol)
         continue;
      TradeClose(OrderTicket());
     }

#endif

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void TradeClose(long ticket)
  {

   bool check=false;

#ifdef __MQL5__

   for(int i=0; i<Retry_Times; i++)
     {
      check=trading.PositionClose(ticket);
      if(check)
         break;
      Print("#",Magic_Number,": TRADING ERROR ",trading.ResultRetcode());
      Sleep(Retry_Delay);
     }

#else

   for(int i=0; i<Retry_Times; i++)
     {
      int type=OrderType();
      if(type==OP_BUY)
         check=OrderClose((int)ticket,OrderLots(),Bid,0,clrLime);
      if(type==OP_SELL)
         check=OrderClose((int)ticket,OrderLots(),Ask,0,clrRed);
      if(check)
         break;
      Print("#",Magic_Number,": TRADING ERROR ",GetLastError());
      Sleep(Retry_Delay);
     }

#endif

   if(!check)
      Alert("#",Magic_Number,": CLOSE OPERATION FAILED");

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void RunTrailing()
  {
   if(Trail_Start==0)
      return;
   if(Trail_Size==0)
      return;

#ifdef __MQL5__

   for(int i=PositionsTotal()-1; i>=0; i--)
     {
      if(!position.SelectByIndex(i))
         continue;
      if(position.Magic()!=Magic_Number)
         continue;
      if(position.Symbol()!=_Symbol)
         continue;

      double open=position.PriceOpen();
      double take=position.TakeProfit();
      double stop=position.StopLoss();
      int type=position.PositionType();

      if(type==POSITION_TYPE_BUY)
        {
         double price=SymbolInfoDouble(_Symbol,SYMBOL_BID);
         double trail=NormalizeDouble(price-Trail_Size*_Point,_Digits);
         double trigger=NormalizeDouble(open+Trail_Start*_Point,_Digits);
         if(price>=trigger)
            if(trail>stop || stop==0)
               TradeModify(position.Ticket(),open,trail,take);
        }
      if(type==POSITION_TYPE_SELL)
        {
         double price=SymbolInfoDouble(_Symbol,SYMBOL_ASK);
         double trail=NormalizeDouble(price+Trail_Size*_Point,_Digits);
         double trigger=NormalizeDouble(open-Trail_Start*_Point,_Digits);
         if(price<=trigger)
            if(trail<stop || stop==0)
               TradeModify(position.Ticket(),open,trail,take);
        }
     }

#else

   for(int i=OrdersTotal()-1; i>=0; i--)
     {
      if(!OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
         continue;
      if(OrderMagicNumber()!=Magic_Number)
         continue;
      if(OrderSymbol()!=_Symbol)
         continue;

      double open=OrderOpenPrice();
      double take=OrderTakeProfit();
      double stop=OrderStopLoss();
      int type=OrderType();

      if(type==OP_BUY)
        {
         double price=MarketInfo(_Symbol,MODE_BID);
         double trail=NormalizeDouble(price-Trail_Size*_Point,_Digits);
         double trigger=NormalizeDouble(open+Trail_Start*_Point,_Digits);
         if(price>=trigger)
            if(trail>stop || stop==0)
               TradeModify(OrderTicket(),open,trail,take);
        }
      if(type==OP_SELL)
        {
         double price=MarketInfo(_Symbol,MODE_ASK);
         double trail=NormalizeDouble(price+Trail_Size*_Point,_Digits);
         double trigger=NormalizeDouble(open-Trail_Start*_Point,_Digits);
         if(price<=trigger)
            if(trail<stop || stop==0)
               TradeModify(OrderTicket(),open,trail,take);
        }
     }

#endif

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void TradeModify(long ticket,double open,double stop,double take)
  {

   bool check=false;

#ifdef __MQL5__

   for(int i=0; i<Retry_Times; i++)
     {
      check=trading.PositionModify(ticket,stop,take);
      if(check)
         break;
      Print("#",Magic_Number,": TRADING ERROR ",trading.ResultRetcode());
      Sleep(Retry_Delay);
     }

#else

   for(int i=0; i<Retry_Times; i++)
     {
      check=OrderModify((int)ticket,open,stop,take,0,clrMagenta);
      if(check)
         break;
      Print("#",Magic_Number,": TRADING ERROR ",GetLastError());
      Sleep(Retry_Delay);
     }

#endif

   if(!check)
      Alert("#",Magic_Number,": MODIFY OPERATION FAILED");

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double GetVolume()
  {
   double total_volume=0;

#ifdef __MQL5__

   for(int i=0; i<PositionsTotal(); i++)
     {
      if(!position.SelectByIndex(i))
         continue;
      if(position.Magic()!=Magic_Number)
         continue;
      if(position.Symbol()!=_Symbol)
         continue;
      int type=position.PositionType();
      if(type==POSITION_TYPE_BUY)
         total_volume+=position.Volume();
      if(type==POSITION_TYPE_SELL)
         total_volume-=position.Volume();
     }

#else

   for(int i=0; i<OrdersTotal(); i++)
     {
      if(!OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
         continue;
      if(OrderSymbol()!=_Symbol)
         continue;
      if(OrderMagicNumber()!=Magic_Number)
         continue;
      int type=OrderType();
      if(type==OP_BUY)
         total_volume+=OrderLots();
      if(type==OP_SELL)
         total_volume-=OrderLots();
     }

#endif

   return total_volume;

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void GetTradeData(double &profit_loss,double &volume_all,double &average_long,double &average_short)
  {

   profit_loss=0;
   volume_all=0;
   average_long=0;
   average_short=0;

   double volume_buy=0;
   double volume_sell=0;

#ifdef __MQL5__

   for(int i=0; i<PositionsTotal(); i++)
     {
      if(!position.SelectByIndex(i))
         continue;
      if(position.Magic()!=Magic_Number)
         continue;
      if(position.Symbol()!=_Symbol)
         continue;
      int type=position.PositionType();
      if(type==POSITION_TYPE_BUY)
        {
         profit_loss+=position.Profit()+position.Swap()+position.Commission();
         volume_buy+=position.Volume();
         average_long+=position.PriceOpen()*position.Volume();
        }
      if(type==POSITION_TYPE_SELL)
        {
         profit_loss+=position.Profit()+position.Swap()+position.Commission();
         volume_sell+=position.Volume();
         average_short+=position.PriceOpen()*position.Volume();
        }
     }

#else

   for(int i=0; i<OrdersTotal(); i++)
     {
      if(!OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
         continue;
      if(OrderSymbol()!=_Symbol)
         continue;
      if(OrderMagicNumber()!=Magic_Number)
         continue;
      int type=OrderType();
      if(type==OP_BUY)
        {
         profit_loss+=OrderProfit()+OrderSwap()+OrderCommission();
         volume_buy+=OrderLots();
         average_long+=OrderOpenPrice()*OrderLots();
        }
      if(type==OP_SELL)
        {
         profit_loss+=OrderProfit()+OrderSwap()+OrderCommission();
         volume_sell+=OrderLots();
         average_short+=OrderOpenPrice()*OrderLots();
        }
     }

#endif

   if(volume_buy!=0)
      average_long/=volume_buy;
   if(volume_sell!=0)
      average_short/=volume_sell;
   volume_all=volume_buy-volume_sell;

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void PlaceLabel(string name,int x,int y,int corner,string text,int colour,string font,int size)
  {
   int anchor=0;
   if(corner==CORNER_LEFT_LOWER)
      anchor=ANCHOR_LEFT_LOWER;
   else
      if(corner==CORNER_LEFT_UPPER)
         anchor=ANCHOR_LEFT_UPPER;
      else
         if(corner==CORNER_RIGHT_LOWER)
            anchor=ANCHOR_RIGHT_LOWER;
         else
            if(corner==CORNER_RIGHT_UPPER)
               anchor=ANCHOR_RIGHT_UPPER;
   ObjectCreate(0,name,OBJ_LABEL,0,0,0);
   ObjectSetInteger(0,name,OBJPROP_CORNER,corner);
   ObjectSetInteger(0,name,OBJPROP_ANCHOR,anchor);
   ObjectSetInteger(0,name,OBJPROP_XDISTANCE,x);
   ObjectSetInteger(0,name,OBJPROP_YDISTANCE,y);
   ObjectSetString(0,name,OBJPROP_TEXT,text);
   ObjectSetString(0,name,OBJPROP_FONT,font);
   ObjectSetInteger(0,name,OBJPROP_COLOR,colour);
   ObjectSetInteger(0,name,OBJPROP_FONTSIZE,size);
   ObjectSetInteger(0,name,OBJPROP_SELECTABLE,false);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void PlaceVertical(string name,datetime time,int colour,int style)
  {
   ObjectCreate(0,name,OBJ_VLINE,0,time,0);
   ObjectSetInteger(0,name,OBJPROP_COLOR,colour);
   ObjectSetInteger(0,name,OBJPROP_STYLE,style);
   ObjectSetInteger(0,name,OBJPROP_BACK,true);
   ObjectSetInteger(0,name,OBJPROP_SELECTABLE,false);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void PlaceHorizontal(string name,double price,int colour,int style)
  {
   ObjectCreate(0,name,OBJ_HLINE,0,0,price);
   ObjectSetInteger(0,name,OBJPROP_COLOR,colour);
   ObjectSetInteger(0,name,OBJPROP_STYLE,style);
   ObjectSetInteger(0,name,OBJPROP_BACK,true);
   ObjectSetInteger(0,name,OBJPROP_SELECTABLE,false);
  }
//+------------------------------------------------------------------+
