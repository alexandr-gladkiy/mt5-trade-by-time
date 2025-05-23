// TODO: Refactoring all files

//+------------------------------------------------------------------+
#property copyright ""
#property link      ""
#property version   "1.00"
#property strict

#define MSG_BEGIN_TRADE "Началась торговля по новости %s - '%s': %s"
#define MSG_UPDATE_TP "Усреднение позиций: %s"

#include "./Lib/ClassSymbols.mqh";
#include "./Lib/ClassTrade.mqh";
#include "./Lib/ClassOrders.mqh";
#include "./Lib/ClassNewsInfo.mqh";

#include <Controls\Dialog.mqh>


input string Group_1 = "";              // Expert Settings
input int    InpMagic = 1234;           // Expert ID
input int    InpTP = 100;               // Take Profit (pips)
input int    InpDistToOrder = 50;       // Distance to order open price
input double InpVolume = 0.5;           // Volume
input int    InpExpirationSec = 125;    // Expiration (sec)
input int    InpTimeToOpeningOrder = 5; // Time before news release to place an order

// input string Group_2 = "";         // Drawdown Controll Settings
// input int InpDistDD_1 = 300;       // Distance by last order 1
// input int InpDistDD_2 = 400;       // Distance by last order 2
// input int InpDistDD_3 = 500;       // Distance by last order 3
// input int InpDistDD_4 = 600;       // Distance by last order 4
// input double InpMultiVolume = 1.5; // Volume Multipli

input string Group_3 = "";             // Load Data For Trade Settings
input string InpFileName = "test.txt"; // File Name

ClassNewsInfo News;

NewsInfo news_data[];

//+------------------------------------------------------------------+
int OnInit()
  {   
   News.SetSuffix("rfd");
   News.LoadDataFromFile(InpFileName, news_data);
  
 //--- create timer
   EventSetTimer(1);
   
   
   return(INIT_SUCCEEDED);
  }
  
  
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//--- destroy timer
   EventKillTimer();
  }
  
//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+
void OnTimer()
  {
   //---- Сопровождение сделок, ушедших в просадку     
      
   //---- Открытие сделок по новостям, загруженным в массив
    datetime curr_dt;
    datetime delta_time;
        
    for(int i=0;i<ArraySize(news_data);i++)
    {
      if(ArraySize(news_data[i].symbol) == 0)
         continue;
         
      curr_dt = TimeCurrent();
      delta_time = news_data[i].dt - TimeCurrent();
      if(delta_time < 0 || delta_time > InpTimeToOpeningOrder)
         continue;
      
      for(int j=0; j<ArraySize(news_data[i].symbol); j++)
         OpenOrders(news_data[i].symbol[j], InpVolume, InpTP, InpMagic);
    } 
  }
  
//+------------------------------------------------------------------+
//| TradeTransaction function                                        |
//+------------------------------------------------------------------+
void OnTradeTransaction(const MqlTradeTransaction& trans,
                        const MqlTradeRequest& request,
                        const MqlTradeResult& result)
  {  
    if(trans.symbol == "")
      return; 
  
    ClassTrade Trade;
    ClassOrders Orders;
    
    if((request.type == ORDER_TYPE_BUY || request.type == ORDER_TYPE_SELL) && trans.type == TRADE_TRANSACTION_DEAL_ADD)
    {
      Orders.Init(trans.symbol, InpMagic);
      if (Orders.GetCountAllDeferred() == 1)
         Orders.DeleteDeferred();
      
      Trade.SetMagicNumber(int(request.magic));
      Trade.CloseAllOrders(trans.symbol);
    }
  }
  
  

//+------------------------------------------------------------------+
void OpenOrders(string _symbol, double _volume, int _tp, int _magic)
{
  /* Эту ф-ю нужно переписать под более универсальный вариант  */
  // Если есть открытые позиции и ордера, то выходим. Сделки не открываем. 
   ulong ticket;
   int total = OrdersTotal();
   for(int i=0;i<total;i++)
      if((ticket = OrderGetTicket(i)) > 0)
         if(OrderSelect(ticket))
            if(OrderGetString(ORDER_SYMBOL) == _symbol && OrderGetInteger(ORDER_MAGIC) == _magic)
               return;
               
   total = PositionsTotal();
   for(int i=0;i<total;i++)
      if((ticket = PositionGetTicket(i)) > 0)
         if(PositionGetString(POSITION_SYMBOL) == _symbol && PositionGetInteger(POSITION_MAGIC) == _magic)
            return;
               
   
  // Если оказались здесь, то устанавливаем 2 отложенных ордера. 
   CTrade Trade;
   double point = SymbolInfoDouble(_symbol, SYMBOL_POINT);
   double open_price_buy = SymbolInfoDouble(_symbol, SYMBOL_ASK) + InpDistToOrder*point;
   double open_price_sell = SymbolInfoDouble(_symbol, SYMBOL_BID) - InpDistToOrder*point;
   double tp_buy = open_price_buy + _tp * point;
   double tp_sell = open_price_sell - _tp * point;
                  
   string comment = StringFormat("Trade by news: %s", TimeToString(TimeCurrent()+60)); 
   datetime expiration = TimeCurrent() + InpExpirationSec;
   Trade.SetExpertMagicNumber(_magic);         
     
   Trade.BuyStop(_volume, open_price_buy, _symbol, 0, tp_buy, ORDER_TIME_GTC, 0, comment);
   if(InpExpirationSec > 0)
      Trade.OrderModify(Trade.ResultOrder(), open_price_buy, 0, tp_buy, ORDER_TIME_SPECIFIED, expiration);
   
   Trade.SellStop(_volume, open_price_sell, _symbol, 0, tp_sell, ORDER_TIME_GTC, 0, comment);
   if(InpExpirationSec > 0)
      Trade.OrderModify(Trade.ResultOrder(), open_price_sell, 0, tp_sell, ORDER_TIME_SPECIFIED, expiration);
}




//****************** Tracking Orders *******************   
//+------------------------------------------------------------------+
void DrawdownOut(int _tp, int _magic = NULL)
{
   
   
}

//+------------------------------------------------------------+
void GetSymbolsPosByMagic(int _magic, string &_symbol[])
{
   ArrayFree(_symbol);
   for(int i=0; i<PositionsTotal(); i++)
   {
      ulong ticket = PositionGetTicket(i);
      if(PositionGetInteger(POSITION_MAGIC) != _magic)
         continue;
         
      int s = ArraySize(_symbol);
      ArrayResize(_symbol, s+1);
      _symbol[s] = PositionGetString(POSITION_SYMBOL);
   }
}


//+------------------------------------------------------------+
void GetTickets(string _symbol, int _magic, ulong &_tickets[])
{
   ArrayFree(_tickets);
   for(int i=0; i<PositionsTotal(); i++)
   {
      ulong ticket = PositionGetTicket(i);
      if(!(PositionGetInteger(POSITION_MAGIC) == _magic && PositionGetString(POSITION_SYMBOL) == _symbol))
         continue;
         
      int s = ArraySize(_tickets);
      ArrayResize(_tickets, s+1);
      _tickets[s] = ticket;
   }
}
