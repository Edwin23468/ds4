using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

namespace SistemaGastos
{
    public partial class Default : Page
    {
        string conexion = "Server=.\\SQLEXPRESS;Database=DB_SistemaGastos;Integrated Security=True;";

     
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)  
            {
                CargarResumen();
                CargarUltimasTransacciones();
            }
        }

    
        private void CargarResumen()
        {
            try
            {
                
                DateTime primerDia = new DateTime(DateTime.Now.Year, DateTime.Now.Month, 1);
                DateTime ultimoDia = primerDia.AddMonths(1).AddDays(-1);

                
                using (SqlConnection conn = new SqlConnection(conexion))
                {
                    
                    string query = @"
                        SELECT 
                            SUM(CASE WHEN TipoTransaccion = 'Gasto' THEN Monto ELSE 0 END) AS TotalGastos,
                            SUM(CASE WHEN TipoTransaccion = 'Ingreso' THEN Monto ELSE 0 END) AS TotalIngresos
                        FROM Transacciones
                        WHERE FechaTransaccion BETWEEN @FechaInicio AND @FechaFin";

                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@FechaInicio", primerDia);
                    cmd.Parameters.AddWithValue("@FechaFin", ultimoDia);

                    
                    conn.Open();
                    SqlDataReader reader = cmd.ExecuteReader();

                    if (reader.Read())
                    {
                        
                        decimal totalGastos = reader.IsDBNull(0) ? 0 : reader.GetDecimal(0);
                        decimal totalIngresos = reader.IsDBNull(1) ? 0 : reader.GetDecimal(1);
                        decimal balance = totalIngresos - totalGastos;

                       
                        lblTotalGastos.Text = totalGastos.ToString("C2");  
                        lblTotalIngresos.Text = totalIngresos.ToString("C2");
                        lblBalance.Text = balance.ToString("C2");

                        
                        if (balance >= 0)
                            lblBalance.ForeColor = System.Drawing.Color.Green;
                        else
                            lblBalance.ForeColor = System.Drawing.Color.Red;
                    }

                    reader.Close();
                }
            }
            catch (Exception ex)
            {
                
                Response.Write("<script>alert('Error al cargar resumen: " + ex.Message + "');</script>");
            }
        }

    
        private void CargarUltimasTransacciones()
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(conexion))
                {
                   
                    string query = @"
                        SELECT TOP 10
                            t.FechaTransaccion,
                            t.Descripcion,
                            t.TipoTransaccion,
                            c.NombreCategoria,
                            t.Monto
                        FROM Transacciones t
                        INNER JOIN Categorias c ON t.IdCategoria = c.IdCategoria
                        ORDER BY t.FechaTransaccion DESC";

                    SqlCommand cmd = new SqlCommand(query, conn);

                    
                    SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();

                    conn.Open();
                    adapter.Fill(dt);

                   
                    gvTransacciones.DataSource = dt;
                    gvTransacciones.DataBind();
                }
            }
            catch (Exception ex)
            {
                Response.Write("<script>alert('Error al cargar transacciones: " + ex.Message + "');</script>");
            }
        }
    }
}