using System;

public class Program
{
    public static void Main(string[] args)
    {
        int lado1, lado2, lado3;

        Console.Write("Ingresa el primer lado:");
        lado1 = int.Parse(Console.ReadLine()!);

        Console.Write("Ingresa el segundo lado:");
        lado2 = int.Parse(Console.ReadLine());

        Console.Write("Ingresa el tercer lado:");
        lado3 = int.Parse(Console.ReadLine());

        if (lado1 + lado2 > lado3 && lado1 + lado3 > lado2 && lado2 + lado3 > lado1)
        {
            if (lado1 == lado2 && lado2 == lado3)
            {
                Console.WriteLine("Es un triángulo equilátero");
            }
            else if (lado1 == lado2 || lado1 == lado3 || lado2 == lado3)
            {
                Console.WriteLine("Es un triángulo isósceles");
            }
            else
            {
                Console.WriteLine("Es un triángulo escaleno");
            }
        }


        else
        {
            Console.WriteLine("No es un triangulo,dale de nuevo");
            Console.WriteLine("La suma de dos lados debe ser mayor que el tercero.");
        }



    }
}