using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.Script.Serialization;
using System.Web.UI;

namespace SistemaGastos
{
    public partial class Reportes : Page
    {
        string conexion = "Server=.\\SQLEXPRESS;Database=DB_SistemaGastos;Integrated Security=True;";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                CargarAños();
                ddlMes.SelectedValue = DateTime.Now.Month.ToString();
                ddlAño.SelectedValue = DateTime.Now.Year.ToString();
                CargarDatos();
            }
        }

     
        private void CargarAños()
        {
         
            int añoActual = DateTime.Now.Year;
            ddlAño.Items.Clear();

            for (int año = 2024; año <= añoActual + 1;año++)
            {
                ddlAño.Items.Add(año.ToString());
            }

            ddlAño.SelectedValue = añoActual.ToString();
        }

      
        protected void btnFiltrar_Click(object sender, EventArgs e)
        {
            CargarDatos();
        }

        private void CargarDatos()
        {
            try
            {
                int año = Convert.ToInt32(ddlAño.SelectedValue);
                int mes = Convert.ToInt32(ddlMes.SelectedValue);

                DateTime fechaInicio, fechaFin;

                if (mes == 0)  
                {
                    fechaInicio = new DateTime(año, 1, 1);
                    fechaFin = new DateTime(año, 12, 31);
                }
                else  
                {
                    fechaInicio = new DateTime(año, mes, 1);
                    fechaFin = fechaInicio.AddMonths(1).AddDays(-1);
                }

                
                CargarTotales(fechaInicio, fechaFin);

                
                CargarResumenPorCategoria(fechaInicio, fechaFin);
            }
            catch (Exception ex)
            {
                Response.Write("<script>alert('Error: " + ex.Message + "');</script>");
            }
        }

        private void CargarTotales(DateTime fechaInicio, DateTime fechaFin)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(conexion))
                {
                    string query = @"
                        SELECT 
                            SUM(CASE WHEN TipoTransaccion = 'Gasto' THEN Monto ELSE 0 END) AS TotalGastos,
                            SUM(CASE WHEN TipoTransaccion = 'Ingreso' THEN Monto ELSE 0 END) AS TotalIngresos
                        FROM Transacciones
                        WHERE FechaTransaccion BETWEEN @FechaInicio AND @FechaFin";

                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@FechaInicio", fechaInicio);
                    cmd.Parameters.AddWithValue("@FechaFin", fechaFin);

                    conn.Open();
                    SqlDataReader reader = cmd.ExecuteReader();

                    if (reader.Read())
                    {
                        decimal gastos = reader.IsDBNull(0) ? 0 : reader.GetDecimal(0);
                        decimal ingresos = reader.IsDBNull(1) ? 0 : reader.GetDecimal(1);
                        decimal balance = ingresos - gastos;

                        lblGastos.Text = gastos.ToString("C2");
                        lblIngresos.Text = ingresos.ToString("C2");
                        lblBalance.Text = balance.ToString("C2");

                        lblBalance.ForeColor = balance >= 0
                            ? System.Drawing.Color.Green
                            : System.Drawing.Color.Red;
                    }

                    reader.Close();
                }
            }
            catch (Exception ex)
            {
                Response.Write("<script>alert('Error al cargar totales: " + ex.Message + "');</script>");
            }
        }

       
        private void CargarResumenPorCategoria(DateTime fechaInicio, DateTime fechaFin)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(conexion))
                {
                    string query = @"
                        SELECT 
                            c.NombreCategoria,
                            SUM(CASE WHEN t.TipoTransaccion = 'Gasto' THEN t.Monto ELSE 0 END) AS TotalGastos,
                            SUM(CASE WHEN t.TipoTransaccion = 'Ingreso' THEN t.Monto ELSE 0 END) AS TotalIngresos,
                            SUM(CASE WHEN t.TipoTransaccion = 'Ingreso' THEN t.Monto ELSE -t.Monto END) AS Balance
                        FROM Transacciones t
                        INNER JOIN Categorias c ON t.IdCategoria = c.IdCategoria
                        WHERE t.FechaTransaccion BETWEEN @FechaInicio AND @FechaFin
                        GROUP BY c.NombreCategoria
                        ORDER BY TotalGastos DESC";

                    SqlDataAdapter adapter = new SqlDataAdapter(query, conn);
                    adapter.SelectCommand.Parameters.AddWithValue("@FechaInicio", fechaInicio);
                    adapter.SelectCommand.Parameters.AddWithValue("@FechaFin", fechaFin);

                    DataTable dt = new DataTable();
                    conn.Open();
                    adapter.Fill(dt);

                    gvResumen.DataSource = dt;
                    gvResumen.DataBind();
                }
            }
            catch (Exception ex)
            {
                Response.Write("<script>alert('Error al cargar resumen: " + ex.Message + "');</script>");
            }
        }

        public string ObtenerDatosGrafico()
        {
            try
            {
                int año = Convert.ToInt32(ddlAño.SelectedValue);
                int mes = Convert.ToInt32(ddlMes.SelectedValue);

                DateTime fechaInicio, fechaFin;

                if (mes == 0)
                {
                    fechaInicio = new DateTime(año, 1, 1);
                    fechaFin = new DateTime(año, 12, 31);
                }
                else
                {
                    fechaInicio = new DateTime(año, mes, 1);
                    fechaFin = fechaInicio.AddMonths(1).AddDays(-1);
                }

                List<string> categorias = new List<string>();
                List<decimal> montos = new List<decimal>();

                using (SqlConnection conn = new SqlConnection(conexion))
                {
                    string query = @"
                        SELECT 
                            c.NombreCategoria,
                            SUM(t.Monto) AS TotalGastado
                        FROM Transacciones t
                        INNER JOIN Categorias c ON t.IdCategoria = c.IdCategoria
                        WHERE t.TipoTransaccion = 'Gasto'
                          AND t.FechaTransaccion BETWEEN @FechaInicio AND @FechaFin
                        GROUP BY c.NombreCategoria
                        ORDER BY TotalGastado DESC";

                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@FechaInicio", fechaInicio);
                    cmd.Parameters.AddWithValue("@FechaFin", fechaFin);

                    conn.Open();
                    SqlDataReader reader = cmd.ExecuteReader();

                    while (reader.Read())
                    {
                        categorias.Add(reader.GetString(0));
                        montos.Add(reader.GetDecimal(1));
                    }

                    reader.Close();
                }

                var datos = new { categorias = categorias, montos = montos };
                JavaScriptSerializer serializer = new JavaScriptSerializer();
                return serializer.Serialize(datos);
            }
            catch (Exception)
            {
                return "{ categorias: [], montos: [] }";
            }
        }
    }
}