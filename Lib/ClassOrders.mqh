//+------------------------------------------------------------------+
//|                                                  ClassOrders.mqh |
//|                                                            AlexG |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "AlexG"
#property link      ""
#property version   "1.00"
#include <Trade/Trade.mqh>


struct Tickets
{
   ulong 
      Buy[],
      Sell[],
      BuyStop[],
      SellStop[],
      BuyLimit[],
      SellLimit[];
};


class ClassOrders : CTrade
  {
protected:
   ulong Magic;
   Tickets Tickets;
   
   string Symbol;
      
   bool
      SymbolIsSet,
      MagicIsSet;
      
                     void AddTicketToArray(ulong ticket, ulong &ticketsArray[]);
                     void CloseMarketOrdersByTicketsArray(ulong &TicketsArray[]);
                     void DeleteDeferredOrderByTicketsArray(ulong &TicketsArray[]);
   
public:
                     ClassOrders();
                     ClassOrders(string symbol, long magic);
                    ~ClassOrders();
                    
                    void Init();
                    void Init(string symbol, long magic);
                    void Clear();
                    
                    void SetMagic(long magic);
                    void SetSymbol(string symbol);
                    
                    int GetCountBuy();
                    int GetCountBuyLimit();
                    int GetCountBuyStop();
                    int GetCountSell();
                    int GetCountSellLimit();
                    int GetCountSellStop();
                    int GetCountAllMarket();
                    int GetCountAllDeferred();
                    int GetCountBuyDeferred();
                    int GetCountSellDeferred();
                    int GetCountAll();
                    
                    void CloseBuy();
                    void CloseSell();
                    void CloseMarket();
                
                    void DeleteBuyLimit();
                    void DeleteBuyStop();
                    void DeleteSellLimit();
                    void DeleteSellStop();
                    void DeleteSellDeferred();
                    void DeleteBuyDeferred();
                    void DeleteDeferred();
                    
                    void CloseAll();
  };
  
//+------------------------------------------------------------------+
ClassOrders::ClassOrders()
  {
  }
  
 //+------------------------------------------------------------------+
 ClassOrders::ClassOrders(string symbol, long magic)
 {
   this.SetMagic(magic);
   this.SetSymbol(symbol);
 }
  
  
//+------------------------------------------------------------------+
ClassOrders::~ClassOrders()
  {
  
  }
  
//+------------------------------------------------------------------+
void ClassOrders::Init()
{
   ulong ticket;
   string symbol;
   long magic;
   
   if(!this.SymbolIsSet)
      printf(" %s: Symbol is not set: function call = ", __FUNCTION__);
   
   this.Clear();
   for(int i=0; i<OrdersTotal(); i++)
   {
      ticket = OrderGetTicket(i);
      if(OrderSelect(ticket)) 
      {         
         magic = OrderGetInteger(ORDER_MAGIC);
         symbol = OrderGetString(ORDER_SYMBOL);
         
         if(magic == this.Magic && symbol == this.Symbol)
         switch(int(OrderGetInteger(ORDER_TYPE)))
           {
            case ORDER_TYPE_BUY : 
               this.AddTicketToArray(ticket, this.Tickets.Buy);
            case ORDER_TYPE_SELL : 
               this.AddTicketToArray(ticket, this.Tickets.Sell);
            case ORDER_TYPE_BUY_STOP : 
               this.AddTicketToArray(ticket, this.Tickets.BuyStop);
            case ORDER_TYPE_SELL_STOP : 
               this.AddTicketToArray(ticket, this.Tickets.SellStop);
            case ORDER_TYPE_BUY_LIMIT : 
               this.AddTicketToArray(ticket, this.Tickets.BuyLimit);
            case ORDER_TYPE_SELL_LIMIT : 
               this.AddTicketToArray(ticket, this.Tickets.SellLimit);   
           }
        }
   }
}

//+------------------------------------------------------------------+
void ClassOrders::Init(string symbol, long magic)
{
   this.SetMagic(magic);
   this.SetSymbol(symbol);
   this.Init();
}

//+------------------------------------------------------------------+
void ClassOrders::Clear(void)
{
   ArrayFree(this.Tickets.Buy);
   ArrayFree(this.Tickets.Sell);
   ArrayFree(this.Tickets.BuyStop);
   ArrayFree(this.Tickets.SellStop);
   ArrayFree(this.Tickets.BuyLimit);
   ArrayFree(this.Tickets.SellLimit);
}

//+------------------------------------------------------------------+
void ClassOrders::AddTicketToArray(ulong ticket,ulong &ticketsArray[])
{
   //TODO: move to Array Class
   int size;
   size = ArraySize(ticketsArray);
   ArrayResize(ticketsArray, size+1);
   ticketsArray[size] = ticket;
}

//+------------------------------------------------------------------+
void ClassOrders::SetMagic(long magic)
{
   this.Magic = magic;
   this.MagicIsSet = true;
}

//+------------------------------------------------------------------+
void ClassOrders::SetSymbol(string symbol)
{
   this.Symbol = symbol;
   this.SymbolIsSet = true;
}

//+------------------------------------------------------------------+
int ClassOrders::GetCountBuy()
{
   return ArraySize(this.Tickets.Buy);
}

//+------------------------------------------------------------------+
int ClassOrders::GetCountBuyLimit()
{
   return ArraySize(this.Tickets.BuyLimit);
}

//+------------------------------------------------------------------+
int ClassOrders::GetCountBuyStop()
{
   return ArraySize(this.Tickets.BuyStop);
}

//+------------------------------------------------------------------+
int ClassOrders::GetCountSell()
{
   return ArraySize(this.Tickets.Sell);
}

//+------------------------------------------------------------------+
int ClassOrders::GetCountSellLimit()
{
   return ArraySize(this.Tickets.SellLimit);
}

//+------------------------------------------------------------------+
int ClassOrders::GetCountSellStop()
{
   return ArraySize(this.Tickets.SellStop);
}

//+------------------------------------------------------------------+
int ClassOrders::GetCountAllMarket()
{
   return this.GetCountBuy() + this.GetCountSell();
};

//+------------------------------------------------------------------+
int ClassOrders::GetCountBuyDeferred()
{
   return this.GetCountBuyLimit() + this.GetCountBuyStop();
}

//+------------------------------------------------------------------+
int ClassOrders::GetCountSellDeferred()
{
   return this.GetCountSellLimit() + this.GetCountSellStop();
}

//+------------------------------------------------------------------+
int ClassOrders::GetCountAllDeferred()
{
   return this.GetCountBuyDeferred() + this.GetCountSellDeferred();
}

//+------------------------------------------------------------------+
int ClassOrders::GetCountAll()
{
   return this.GetCountAllDeferred() + this.GetCountAllMarket();
}

//+------------------------------------------------------------------+
void ClassOrders::CloseBuy()
{
   this.CloseMarketOrdersByTicketsArray(this.Tickets.Buy);
}

//+------------------------------------------------------------------+
void ClassOrders::CloseSell()
{
   this.CloseMarketOrdersByTicketsArray(this.Tickets.Sell);
}

//+------------------------------------------------------------------+
void ClassOrders::CloseMarket()
{
   this.CloseBuy();
   this.CloseSell();
}
                
//+------------------------------------------------------------------+                
void ClassOrders::DeleteBuyLimit()
{
   this.DeleteDeferredOrderByTicketsArray(this.Tickets.BuyLimit);
}

//+------------------------------------------------------------------+
void ClassOrders::DeleteBuyStop()
{
   this.DeleteDeferredOrderByTicketsArray(this.Tickets.BuyStop);
}

//+------------------------------------------------------------------+
void ClassOrders::DeleteBuyDeferred()
{
   this.DeleteBuyLimit();
   this.DeleteBuyStop();
}

//+------------------------------------------------------------------+
void ClassOrders::DeleteSellLimit()
{
   this.DeleteDeferredOrderByTicketsArray(this.Tickets.SellLimit);
}

//+------------------------------------------------------------------+
void ClassOrders::DeleteSellStop()
{
   this.DeleteDeferredOrderByTicketsArray(this.Tickets.SellStop);
}

//+------------------------------------------------------------------+
void ClassOrders::DeleteSellDeferred()
{
   this.DeleteSellLimit();
   this.DeleteSellStop();
}
 
//+------------------------------------------------------------------+
void ClassOrders::DeleteDeferred()
{
   this.CloseMarketOrdersByTicketsArray(this.Tickets.Buy);
}

//+------------------------------------------------------------------+
void ClassOrders::CloseAll()
{
   this.DeleteBuyDeferred();
   this.DeleteSellDeferred();
}

//+------------------------------------------------------------------+
void ClassOrders::CloseMarketOrdersByTicketsArray(ulong &TicketsArray[])
{
   ArraySort(TicketsArray);
   for(int i=0; i<ArraySize(TicketsArray); i++)
        this.PositionClose(TicketsArray[i]);           
}

void ClassOrders::DeleteDeferredOrderByTicketsArray(ulong &TicketsArray[])
{
   ArraySort(TicketsArray);
   for(int i=0; i<ArraySize(TicketsArray); i++)
        this.OrderDelete(TicketsArray[i]);
}




