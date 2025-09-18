internal class Program
{
    private static void Main(string[] args)
    {
        int Variable1, Variable2;

        Console.Write("Introduce el primer numero: ");
        Variable1 = Convert.ToInt32(Console.ReadLine());

        Console.Write("Introduce el segundo numero: ");
        Variable2 = Convert.ToInt32(Console.ReadLine());

        CalculosMatermaticos calculos = new CalculosMatermaticos();

        calculos.Variable1 = Variable1;
        calculos.Variable2 = Variable2;

        Console.WriteLine(calculos.Calcular());
    }
}
public class CalculosMatermaticos
{
    public int Variable1 { get; set; }
    public int Variable2 { get; set; }
    public int Calcular()
    {
        return (Variable1 + Variable2) * (Variable1 - Variable2);
    }
}
