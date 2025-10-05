using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Laboratorio_82
{
    public class Cuenta
    {
        private string idCuenta;

        public Cuenta(string prmtIdCuenta)
        {
            this.idCuenta = prmtIdCuenta;
            System.Console.WriteLine("Constructor Clase Base  para cuenta {0}", prmtIdCuenta);
        }

        public virtual void CalcularInteres()
        {
            System.Console.WriteLine("Cuenta.CalcularInteres() efectuando para " + "la cuenta {0}", getIdcuenta());
        }

        public string getIdcuenta()
        {
            return this.idCuenta;
        }



    }
}
