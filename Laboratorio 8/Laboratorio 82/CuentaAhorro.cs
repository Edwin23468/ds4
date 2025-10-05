using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Laboratorio_82
{
    public class CuentaAhorro : Cuenta
    {
        public CuentaAhorro(string prmtIdCuenta) : base(prmtIdCuenta)
        {
        }
        public override void CalcularInteres()
        {
            System.Console.WriteLine("CuentaAhorro.CalcularInteres() efectuando para " + "la cuenta {0}", getIdcuenta());
        }
    }
}
