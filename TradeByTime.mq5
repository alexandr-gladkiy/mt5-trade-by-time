//+------------------------------------------------------------------+
//|                                                  TradeByTime.mq5 |
//|                                                            AlexG |
//|                                                                  |
//+------------------------------------------------------------------+

input int InpMagic = 1234;     // Magic
input int InpTakeProfit = 150; // Take Profit
input double InpVolume = 0.1;  // Volume

input int InpTimeSetOrder = 5; // Time for Set Order (seconds)
input int InpDistanceToOrder = 100; // Distance to orders

//+------------------------------------------------------------------+
int OnInit()
  {
//--- create timer
   EventSetTimer(1);
   
//---
   return(INIT_SUCCEEDED);
  }
  
  
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//--- destroy timer
   EventKillTimer();
   
  }
  
  
//+------------------------------------------------------------------+
void OnTick()
  {
//---
   
  }
  
  
//+------------------------------------------------------------------+
void OnTimer()
  {
//---
   
  }
  
  
//+------------------------------------------------------------------+
void OnTrade()
  {
//---
   
  }
  
  
//+------------------------------------------------------------------+
void OnTradeTransaction(const MqlTradeTransaction& trans,
                        const MqlTradeRequest& request,
                        const MqlTradeResult& result)
  {
//---
   
  }
//+------------------------------------------------------------------+
