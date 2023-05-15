//+------------------------------------------------------------------+
//|                                             AccountingOrders.mqh |
//|                                                                  |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright ""
#property link      ""
#property version   "1.00"
#include <Trade/PositionInfo.mqh>

struct Tickets
{
   ulong 
      buy[],
      sell[],
      buy_stop[],
      sell_stop[],
      buy_limit[],
      sell_limit[];
};


class ClassAccountingOrders
  {
      private:
        void AddTicket(ulong &tickets[], ulong ticket);
        
        void Clear();
         
      public:
        Tickets tickets;
         
                     ClassAccountingOrders();
                    ~ClassAccountingOrders();
                    void Init(string symbol=NULL, int magic = 0);
  };
  
  
//+------------------------------------------------------------------+
ClassAccountingOrders::ClassAccountingOrders()
  {
  }
  
  
//+------------------------------------------------------------------+
ClassAccountingOrders::~ClassAccountingOrders()
  {
  }
  
  
//+------------------------------------------------------------------+
void ClassAccountingOrders::Init(string symbol=NULL, int magic=0)
{
   this.Clear();
   ulong ticket = 0;
   for(int i=0; i<OrdersTotal(); i++)
   {
      ticket = OrderGetTicket(i);
      if(ticket == 0)
         continue;
         
      if(magic > 0 && OrderGetInteger(ORDER_MAGIC) != magic)
         continue;
         
      if(OrderGetString(ORDER_SYMBOL) != symbol)
         continue;
         
      if(OrderGetInteger(ORDER_TYPE) == ORDER_TYPE_BUY_STOP)
         this.AddTicket(this.tickets.buy_stop, ticket);
         
      if(OrderGetInteger(ORDER_TYPE) == ORDER_TYPE_SELL_STOP)
         this.AddTicket(this.tickets.sell_stop, ticket);
         
      if(OrderGetInteger(ORDER_TYPE) == ORDER_TYPE_BUY_LIMIT)
         this.AddTicket(this.tickets.buy_limit, ticket);
         
      if(OrderGetInteger(ORDER_TYPE) == ORDER_TYPE_SELL_LIMIT)
         this.AddTicket(this.tickets.sell_limit, ticket);
   }
   
   for(int i=0; i<PositionsTotal(); i++)
   {
      ticket = PositionGetTicket(i);
      if(ticket == 0)
         continue;
         
      if(magic > 0 && PositionGetInteger(POSITION_MAGIC) != magic)
         continue;
         
      if(PositionGetString(POSITION_SYMBOL) != symbol)
         continue;
         
      if(PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY)
         this.AddTicket(this.tickets.buy, ticket);
         
      if(PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_SELL)
         this.AddTicket(this.tickets.sell, ticket);
   }
}



//+----- Private Methods ------+
//+---------------------------------------------------------+
void ClassAccountingOrders::AddTicket(ulong &_tickets[], ulong _ticket)
{
   int s = ArraySize(_tickets);
   ArrayResize(_tickets, s+1);
   _tickets[s] = _ticket;
   
   ArraySort(_tickets);
   ArrayReverse(_tickets);
}


//+---------------------------------------------------------+
void ClassAccountingOrders::Clear(void)
{
   ArrayFree(this.tickets.buy);
   ArrayFree(this.tickets.sell);
   ArrayFree(this.tickets.buy_stop);
   ArrayFree(this.tickets.buy_limit);
   ArrayFree(this.tickets.sell_stop);
   ArrayFree(this.tickets.sell_limit);
}