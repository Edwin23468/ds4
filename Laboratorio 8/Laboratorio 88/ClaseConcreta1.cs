using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Laboratorio_88
{
    class ClaseConcretal : ClaseAbstracta
    {
        protected override string tomarValor()
        {
            return "ClaseConcretal";
        }

        public override string prefixValor(string prefix)
        {
            return $"{prefix}ClaseConcretal";
        }
    }
}
