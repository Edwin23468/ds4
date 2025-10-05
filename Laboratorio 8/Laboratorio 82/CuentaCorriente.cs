using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Laboratorio_82
{
    public class CuentaCorriente : Cuenta
    {
        public CuentaCorriente(string prmtIdCuenta) : base(prmtIdCuenta)
        {
        }

        public override void CalcularInteres()
        {
            System.Console.WriteLine("CuentaCorriente.CalcularInteres() efectuando para " + "la cuenta {0}", getIdcuenta());
        }
    }
}
