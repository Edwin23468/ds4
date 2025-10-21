using System;
using System.Windows.Forms;

namespace Laboratorio123
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }

        private void btnSemiperimetro_Click(object sender, EventArgs e)
        {
            double ladoA = Convert.ToDouble(txtLadoA.Text);
            double ladoB = Convert.ToDouble(txtLadoB.Text);
            double ladoC = Convert.ToDouble(txtLadoC.Text);

            double semiperimetro = (ladoA + ladoB + ladoC) / 2;

            txtSemiperimetro.Text = semiperimetro.ToString("F2");
        }

        private void btnArea_Click(object sender, EventArgs e)
        {
            double ladoA = Convert.ToDouble(txtLadoA.Text);
            double ladoB = Convert.ToDouble(txtLadoB.Text);
            double ladoC = Convert.ToDouble(txtLadoC.Text);

            double s = (ladoA + ladoB + ladoC) / 2;

            double area = Math.Sqrt(s * (s - ladoA) * (s - ladoB) * (s - ladoC));

            txtArea.Text = area.ToString("F2");
        }

        private void btnReset_Click(object sender, EventArgs e)
        {
            txtLadoA.Clear();
            txtLadoB.Clear();
            txtLadoC.Clear();
            txtSemiperimetro.Clear();
            txtArea.Clear();
        }

        private void btnSalida_Click(object sender, EventArgs e)
        {
            Application.Exit();
        }
    }
}