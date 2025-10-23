using System;
using System.Data;
using System.Data.SqlClient;
using System.Windows.Forms;

namespace Laboratorio13
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            string connectionString =
                @"Server=.\sqlexpress;Database=Northwind;TrustServerCertificate=true;Integrated Security=SSPI;";

            try
            {
                using (SqlConnection conexion = new SqlConnection(connectionString))
                {
                    conexion.Open();
                    MessageBox.Show("Conexión establecida con SQL Server.");

                    string query = "SELECT ProductName FROM [dbo].[Products]";
                    using (SqlCommand comando = new SqlCommand(query, conexion))
                    {
                        SqlDataReader lector = comando.ExecuteReader();
                        listBox1.Items.Clear();

                        while (lector.Read())
                        {
                            listBox1.Items.Add(lector["ProductName"].ToString());
                        }

                        lector.Close();
                    }

                    conexion.Close();
                    MessageBox.Show("Se cerró la conexión con SQL Server.");
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show("Error al conectar o leer los datos: " + ex.Message);
            }
        }

        private void listBox1_SelectedIndexChanged(object sender, EventArgs e)
        {
        }
    }
}
