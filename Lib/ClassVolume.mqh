
class ClassVolume
{
   private:
      double
         BaseBalance,
         BaseVolume;
   
   

   void ClassVolume();
   void ~ClassVolume();
   
   void SetBaseBalance(double base_balance);
   void SetBaseVolume(double base_volume);
   
   double CalculateVolume()
}


//+----------------------------------------------------+
void ClassVolume::ClassVolume(void)
{
   this.BaseVolume = 0.1;
   this.BaseBalance = 0;
}

//+----------------------------------------------------+
void ClassVolume::SetBaseBalance(double base_balance)
{
   this.BaseBalance = base_balance;
}

//+----------------------------------------------------+
void ClassVolume::SetBaseVolume(double base_volume)
{
   this.BaseVolume = base_volume;
}

//+----------------------------------------------------+
double ClassVolume::CalculateVolume(void)
{
   if(this.BaseBalance == 0)
     {
      return this.BaseVolume;
     }
   double balance = AccountInfoDouble(ACCOUNT_BALANCE);
   double volume = NormalizeDouble(balance / this.BaseBalance * this.BaseVolume, 2);
}