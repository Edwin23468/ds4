using System;

namespace Laboratorio_94
{
    class Program
    {
        static void Main()
        {
            Aleatorios aleatorio = new Aleatorios();

            Console.Write("Ingresa el primer número (mínimo): ");
            int minimo = int.Parse(Console.ReadLine());

            Console.Write("Ingresa el segundo número (máximo): ");
            int maximo = int.Parse(Console.ReadLine());

            Console.Write("¿Cuántos números aleatorios quieres generar? ");
            int cantidad = int.Parse(Console.ReadLine());

            int[] numerosAleatorios = new int[cantidad];

            Console.WriteLine("\nNúmeros aleatorios generados sin repetir:");

            for (int i = 0; i < cantidad; i++)
            {
                int numeroX;
                bool repetido;

                do
                {
                  
                    numeroX = aleatorio.GenerarNumero(minimo, maximo);
                    repetido = false;

                   
                    for (int j = 0; j < i; j++)
                    {
                        if (numerosAleatorios[j] == numeroX)
                        {
                            repetido = true;
                            break;
                        }
                    }

                } while (repetido); 

             
                numerosAleatorios[i] = numeroX;
                Console.WriteLine(numeroX);
            }

            Console.ReadKey();
        }
    }
}