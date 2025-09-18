internal class Program
{
    private static void Main(string[] args)
    {
        double lado1, lado2;

        Console.Write("Introduce el lado 1: ");
        lado1 = Convert.ToInt32(Console.ReadLine());

        Console.Write("Introduce el lado 2: ");
        lado2 = Convert.ToInt32(Console.ReadLine());

        CalculosMatermaticos calculos = new CalculosMatermaticos();

        calculos.lado1 = lado1;
        calculos.lado2 = lado2;

        Console.WriteLine(calculos.CalcularPerimetro());
    }
}

public class CalculosMatermaticos
{
    public double lado1 { get; set; }
    public double lado2 { get; set; }
    public double CalcularPerimetro()
    {
        return (lado1 * 2) + (lado2 * 2);
    }
}