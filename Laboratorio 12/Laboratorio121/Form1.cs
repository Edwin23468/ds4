using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace Laboratorio121
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }

        private void Calcular(object sender, EventArgs e)
        {
            double velocidad = Convert.ToDouble(textBox1.Text);
            double tiempo = Convert.ToDouble(textBox2.Text);
            double distancia = velocidad * tiempo;
            textBox3.Text = "La distancia es:" + distancia.ToString("F2");
        }

        private void Limpiar(object sender, EventArgs e)
        {
            textBox1.Clear();
            textBox2.Clear();
            textBox3.Text = "";
        }

        private void Salir(object sender, EventArgs e)
        {
            Application.Exit();
        }
    }
}
