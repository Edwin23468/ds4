using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Laboratorio_88
{
    class ClaseConcretal2 : ClaseAbstracta
    {
        protected override string tomarValor()
        {
            return "ClaseConcretal2";
        }

        public override string prefixValor(string prefix)
        {
            return $"{prefix}ClaseConcretal2";
        }
    }
}
