//+------------------------------------------------------------------+
#property copyright ""
#property link      ""
#property version   "1.00"

struct NewsInfo
{
   datetime dt;
   string symbol[];
   string description;
};

class ClassNewsInfo
  {
   private:
      string Suffix;

   public:
                     ClassNewsInfo();
                    ~ClassNewsInfo();
                void SetSuffix(string suf);
                void LoadDataFromFile(string file_name, NewsInfo &_data[], string sep = ";");
  };
  
  
//+------------------------------------------------------------------+
ClassNewsInfo::ClassNewsInfo()
  {
  }
  
  
//+------------------------------------------------------------------+
ClassNewsInfo::~ClassNewsInfo()
  {
  }
  
  
//+------------------------------------------------------------------+
void ClassNewsInfo::SetSuffix(string suf){this.Suffix = suf;}

//+------------------------------------------------------------------+
void ClassNewsInfo::LoadDataFromFile(string file_name, NewsInfo &_data[], string sep = ";")
{
   //TODO: Use Json File
   ArrayFree(_data);
   int handler;
   if(FileIsExist(file_name))
      {
         handler = FileOpen(file_name, FILE_READ|FILE_TXT|FILE_ANSI);
         while(!FileIsEnding(handler))
           {
             string arr[];
             string line = FileReadString(handler);
             StringSplit(line, StringGetCharacter(sep,0), arr);
             
             int size = ArraySize(_data);
             ArrayResize(_data, size+1);
             _data[size].dt = StringToTime(arr[0]);
             
             StringSplit(arr[1], StringGetCharacter("|",0), _data[size].symbol);
             _data[size].dt = StringToTime(arr[0]);
             
             for(int i=0; i<ArraySize(_data[size].symbol); i++)
                _data[size].symbol[i] += this.Suffix;
                
             if(ArraySize(arr) > 2)
               _data[size].description = arr[2];
           }
         FileClose(handler);
      }
}