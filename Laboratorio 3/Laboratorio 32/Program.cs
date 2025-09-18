internal class Program
{
    private static void Main(string[] args)
    {
        double radio;

        Console.Write("Introduce el radio del circulo: ");
        radio = Convert.ToInt32(Console.ReadLine());

        CalculosMatermaticos calculos = new CalculosMatermaticos();

        calculos.radio = radio;

        Console.WriteLine(calculos.CalcularArea());
    }
}
public class CalculosMatermaticos
{
    public double radio { get; set; }
    public double CalcularArea() { 
        return Math.PI * radio * radio;
    }
}