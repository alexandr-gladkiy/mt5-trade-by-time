//+------------------------------------------------------------------+
//|                                                   ClassTrade.mqh |
//|                                                                  |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright ""
#property link      ""
#property version   "1.00"
#include <Trade/Trade.mqh>

class ClassTrade : public CTrade
  {
      private:
      int MagicNumber;
      
      public:
                     ClassTrade();
                    ~ClassTrade();
                    void SetMagicNumber(int magic);
                    void CloseAllOrders(string symbol = NULL);
                    void CloseOrdersForType(ENUM_ORDER_TYPE order_type, string symbol = NULL);
  };
  
  
//+------------------------------------------------------------------+
ClassTrade::ClassTrade()
  {
  }
  
  
//+------------------------------------------------------------------+
ClassTrade::~ClassTrade()
  {
  }
  
  
//+------------------------------------------------------------------+
void ClassTrade::SetMagicNumber(int magic)
{
   this.MagicNumber = magic;
}

  
//+------------------------------------------------------------------+
void ClassTrade::CloseAllOrders(string symbol=NULL)
   {
      ulong tickets[];
      for(int i=0; i<OrdersTotal(); i++)
        {
           ulong ticket = OrderGetTicket(i);
           if(this.MagicNumber > 0)
             if(OrderGetInteger(ORDER_MAGIC) != this.MagicNumber)
               continue;
               
           if(symbol != NULL)
             if(OrderGetString(ORDER_SYMBOL) != symbol)
               continue;
               
           int s = ArraySize(tickets);
           ArrayResize(tickets, s+1);
           tickets[s] = ticket;
        }
        
      for(int i=0; i<ArraySize(tickets); i++)
        this.OrderDelete(tickets[i]);
        //this.OrderDelete(tickets[i]);
   }
   

//+------------------------------------------------------------------+
void ClassTrade::CloseOrdersForType(ENUM_ORDER_TYPE order_type,string symbol=NULL)
   {
   
   }