using System;

namespace Laboratorio21
{
    public class Program
    {
        public static void Main()
        {
            //Asignando valor a variable estatica.
            MyClass.Valor = 1;
            Console.WriteLine(MyClass.Valor);
        }
    }
    public class MyClass
    {
        //Declarando variable estatica
        public static int Valor;
    }
}