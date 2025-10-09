using System;
using Laboratorio_94;

public class Program
{
    public static void Main(string[] args)
    {
        // Crear un objeto de la clase Aleatorios
        Aleatorios aleatorios = new Aleatorios();

        // Generar un número aleatorio entre 1 y 10
        int numero = aleatorios.GenerarNumero(1, 10);
        Console.WriteLine("Número aleatorio entre 1 y 10: " + numero);

        // Generar un arreglo de 5 números aleatorios entre 10 y 50
        int[] arreglo = aleatorios.GenerarArreglo(5, 10, 50);

        Console.WriteLine("Arreglo generado:");
        foreach (int n in arreglo)
        {
            Console.Write(n + "\t");
        }
    }
}