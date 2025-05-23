//+------------------------------------------------------------------+
#property copyright ""
#property link      ""
#property version   "1.00"

class ClassSymbols
  {
      private:
         string PathFilters,
                OutcludeSymbols,
                CurrencyBaseFilter,
                CurrencyProfitFilter,
                Sufix;

      public:
                     ClassSymbols();
                    ~ClassSymbols();
                    void AddPathFilter(string PathNameP);
                    void AddOutcludeSymbolFilter(string SymbolP);
                    void AddCurrencyBaseFilter(string CurrencyP);
                    void AddCurrencyProfitFilter(string CurrencyP);
                    void SetSufix(string SufixP);
                    void GetSumbols(string &symbols[]);
  };
  
  
//+------------------------------------------------------------------+
ClassSymbols::ClassSymbols()
  {
   this.CurrencyBaseFilter = "";
   this.CurrencyProfitFilter = "";
   this.PathFilters = "";
   this.OutcludeSymbols = "";
  }
  
  
//+------------------------------------------------------------------+
ClassSymbols::~ClassSymbols()
  {
  }
  
  
//+------------------------------------------------------------------+
void ClassSymbols::AddPathFilter(string PathNameP)
   {
      StringToUpper(PathNameP);
      if(this.PathFilters != "")
         this.PathFilters += "|";
      this.PathFilters += PathNameP;
   }
   
//+------------------------------------------------------------------+
void ClassSymbols::AddOutcludeSymbolFilter(string SymbolP)
   {
      StringToUpper(SymbolP);
      if(this.OutcludeSymbols != "")
         this.OutcludeSymbols += "|";
      this.OutcludeSymbols += SymbolP + this.Sufix;
   }


//+------------------------------------------------------------------+
void ClassSymbols::AddCurrencyBaseFilter(string CurrencyP)
   {
      StringToUpper(CurrencyP);
      if(this.CurrencyBaseFilter != "")
         this.CurrencyBaseFilter += "|";
      this.CurrencyBaseFilter += CurrencyP;
   }
   
   
//+------------------------------------------------------------------+
void ClassSymbols::AddCurrencyProfitFilter(string CurrencyP)
   {
      StringToUpper(CurrencyP);
      if(this.CurrencyProfitFilter != "")
         this.CurrencyProfitFilter += "|";
      this.CurrencyProfitFilter += CurrencyP;
   }
     

//+------------------------------------------------------------------+
void ClassSymbols::SetSufix(string SufixP)
   {
      this.Sufix = SufixP;
   }
     
//+------------------------------------------------------------------+   
void ClassSymbols::GetSumbols(string &symbols[])
   {
      ArrayFree(symbols);
      for(int i=0; i<SymbolsTotal(false); i++)
        {
         string name = SymbolName(i, false);
         if(SymbolInfoInteger(name, SYMBOL_TRADE_MODE) != SYMBOL_TRADE_MODE_FULL)
            continue;
         
         //--- Проверка символов-сключений
         if(this.OutcludeSymbols != "")
            if(StringFind(this.OutcludeSymbols, name) > -1)
               continue;
          
         //--- Проверка фильтров по базовой и профитной валюте   
         string curr_base = SymbolInfoString(name,SYMBOL_CURRENCY_BASE);   
         string curr_profit = SymbolInfoString(name,SYMBOL_CURRENCY_PROFIT);
         
         if(this.CurrencyBaseFilter != "")
            if(StringFind(this.CurrencyBaseFilter, curr_base) > -1)
               continue;            
            
         if(this.OutcludeSymbols != "")
            if(StringFind(this.OutcludeSymbols, curr_profit) > -1)
               continue;
         
         //--- Проверка путей, по которым располагаются фильтры
         string elem[];
         string category;
         StringSplit(SymbolInfoString(name, SYMBOL_PATH), StringGetCharacter("\\",0), elem);
         if(ArraySize(elem) > 2)
            category = elem[ArraySize(elem)-2];
         StringToUpper(category);
         
         if(StringFind(this.PathFilters, category) == -1)
            continue;
            
         int s = ArraySize(symbols);
         ArrayResize(symbols, s+1);
         symbols[s] = name;
        }
   }