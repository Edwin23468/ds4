using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

namespace SistemaGastos
{
    public partial class Flujo : Page
    {
        string conexion = "Server=.\\SQLEXPRESS;Database=DB_SistemaGastos;Integrated Security=True;";

        private decimal _saldoInicial;
        private decimal _saldoFinal;
        private decimal _variacion;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                CargarAnios();
                ddlMes.SelectedValue = DateTime.Now.Month.ToString();
                ddlAño.SelectedValue = DateTime.Now.Year.ToString();
                AnalizarFlujo();
            }
        }

        private void CargarAnios()
        {
            int añoActual = DateTime.Now.Year;
            ddlAño.Items.Clear();

            for (int año = 2024; año <= añoActual + 1; año++)
            {
                ddlAño.Items.Add(año.ToString());
            }

            ddlAño.SelectedValue = añoActual.ToString();
        }

        protected void btnAnalizar_Click(object sender, EventArgs e)
        {
            AnalizarFlujo();
        }

        private void AnalizarFlujo()
        {
            try
            {
                int anio = Convert.ToInt32(ddlAño.SelectedValue);
                int mes = Convert.ToInt32(ddlMes.SelectedValue);

                DateTime fechaInicio = new DateTime(anio, mes, 1);
                DateTime fechaFin = fechaInicio.AddMonths(1).AddDays(-1);

                CalcularSaldos(anio, mes, fechaInicio, fechaFin);

                CargarFlujoMensual(fechaInicio, fechaFin);

                CargarDetallePorCategoria(fechaInicio, fechaFin);

                
            }
            catch (Exception ex)
            {
                Response.Write("<script>alert('Error: " + ex.Message + "');</script>");
            }
        }

        private void CalcularSaldos(int anio, int mes, DateTime fechaInicio, DateTime fechaFin)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(conexion))
                {
                    conn.Open();

                    string querySaldoInicial = @"
                        SELECT 
                            SUM(CASE WHEN TipoTransaccion = 'Ingreso' THEN Monto ELSE -Monto END) AS Saldo
                        FROM Transacciones
                        WHERE FechaTransaccion < @FechaInicio";

                    SqlCommand cmdInicial = new SqlCommand(querySaldoInicial, conn);
                    cmdInicial.Parameters.AddWithValue("@FechaInicio", fechaInicio);

                    object resultInicial = cmdInicial.ExecuteScalar();
                    decimal saldoInicial = resultInicial != DBNull.Value ? Convert.ToDecimal(resultInicial) : 0;

                    string queryMesActual = @"
                        SELECT 
                            SUM(CASE WHEN TipoTransaccion = 'Ingreso' THEN Monto ELSE -Monto END) AS Balance
                        FROM Transacciones
                        WHERE FechaTransaccion BETWEEN @FechaInicio AND @FechaFin";

                    SqlCommand cmdMes = new SqlCommand(queryMesActual, conn);
                    cmdMes.Parameters.AddWithValue("@FechaInicio", fechaInicio);
                    cmdMes.Parameters.AddWithValue("@FechaFin", fechaFin);

                    object resultMes = cmdMes.ExecuteScalar();
                    decimal balanceMes = resultMes != DBNull.Value ? Convert.ToDecimal(resultMes) : 0;

                    decimal saldoFinal = saldoInicial + balanceMes;
                    decimal variacion = saldoFinal - saldoInicial;

                    _saldoInicial = saldoInicial;
                    _saldoFinal = saldoFinal;
                    _variacion = variacion;

                    lblSaldoInicial.Text = saldoInicial.ToString("C2");
                    lblSaldoFinal.Text = saldoFinal.ToString("C2");
                    lblVariacion.Text = variacion.ToString("C2");

                    lblSaldoInicial.ForeColor = saldoInicial >= 0
                        ? System.Drawing.Color.Green
                        : System.Drawing.Color.Red;

                    lblSaldoFinal.ForeColor = saldoFinal >= 0
                        ? System.Drawing.Color.Green
                        : System.Drawing.Color.Red;

                    lblVariacion.ForeColor = variacion >= 0
                        ? System.Drawing.Color.Green
                        : System.Drawing.Color.Red;
                }
            }
            catch (Exception ex)
            {
                Response.Write("<script>alert('Error al calcular saldos: " + ex.Message + "');</script>");
            }
        }

        private void CargarFlujoMensual(DateTime fechaInicio, DateTime fechaFin)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(conexion))
                {
                    string query = @"
                        SELECT 
                            TipoTransaccion AS Concepto,
                            SUM(CASE WHEN TipoTransaccion = 'Ingreso' THEN Monto ELSE -Monto END) AS Monto
                        FROM Transacciones
                        WHERE FechaTransaccion BETWEEN @FechaInicio AND @FechaFin
                        GROUP BY TipoTransaccion
                        
                        UNION ALL
                        
                        SELECT 
                            'BALANCE' AS Concepto,
                            SUM(CASE WHEN TipoTransaccion = 'Ingreso' THEN Monto ELSE -Monto END) AS Monto
                        FROM Transacciones
                        WHERE FechaTransaccion BETWEEN @FechaInicio AND @FechaFin";

                    SqlDataAdapter adapter = new SqlDataAdapter(query, conn);
                    adapter.SelectCommand.Parameters.AddWithValue("@FechaInicio", fechaInicio);
                    adapter.SelectCommand.Parameters.AddWithValue("@FechaFin", fechaFin);

                    DataTable dt = new DataTable();
                    conn.Open();
                    adapter.Fill(dt);

                    gvFlujo.DataSource = dt;
                    gvFlujo.DataBind();
                }
            }
            catch (Exception ex)
            {
                Response.Write("<script>alert('Error al cargar flujo: " + ex.Message + "');</script>");
            }
        }

        private void CargarDetallePorCategoria(DateTime fechaInicio, DateTime fechaFin)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(conexion))
                {
                    string query = @"
                        SELECT 
                            c.NombreCategoria,
                            SUM(CASE WHEN t.TipoTransaccion = 'Ingreso' THEN t.Monto ELSE 0 END) AS TotalIngresos,
                            SUM(CASE WHEN t.TipoTransaccion = 'Gasto' THEN t.Monto ELSE 0 END) AS TotalGastos,
                            SUM(CASE WHEN t.TipoTransaccion = 'Ingreso' THEN t.Monto ELSE -t.Monto END) AS Diferencia
                        FROM Transacciones t
                        INNER JOIN Categorias c ON t.IdCategoria = c.IdCategoria
                        WHERE t.FechaTransaccion BETWEEN @FechaInicio AND @FechaFin
                        GROUP BY c.NombreCategoria
                        ORDER BY Diferencia DESC";

                    SqlDataAdapter adapter = new SqlDataAdapter(query, conn);
                    adapter.SelectCommand.Parameters.AddWithValue("@FechaInicio", fechaInicio);
                    adapter.SelectCommand.Parameters.AddWithValue("@FechaFin", fechaFin);

                    DataTable dt = new DataTable();
                    conn.Open();
                    adapter.Fill(dt);

                    gvCategoria.DataSource = dt;
                    gvCategoria.DataBind();
                }
            }
            catch (Exception ex)
            {
                Response.Write("<script>alert('Error al cargar categorías: " + ex.Message + "');</script>");
            }
        }

       
       
        }
    }
