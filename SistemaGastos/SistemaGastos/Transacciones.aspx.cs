using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace SistemaGastos
{
    public partial class Transacciones : Page
    {

        string conexion = "Server=.\\SQLEXPRESS;Database=DB_SistemaGastos;Integrated Security=True;";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                CargarCategorias();
                CargarTransacciones();
                txtFecha.Text = DateTime.Now.ToString("yyyy-MM-dd");
            }
        }

        private void CargarCategorias()
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(conexion))
                {
                    string query = "SELECT IdCategoria, NombreCategoria FROM Categorias ORDER BY NombreCategoria";
                    SqlCommand cmd = new SqlCommand(query, conn);

                    conn.Open();
                    SqlDataReader reader = cmd.ExecuteReader();

                    ddlCategoria.Items.Clear();
                    ddlCategoria.Items.Add(new ListItem("-- Seleccionar --", "0"));

                    while (reader.Read())
                    {
                        string id = reader["IdCategoria"].ToString();
                        string nombre = reader["NombreCategoria"].ToString();
                        ddlCategoria.Items.Add(new ListItem(nombre, id));
                    }

                    reader.Close();
                }
            }
            catch (Exception ex)
            {
                MostrarMensaje("Error al cargar categorías: " + ex.Message, false);
            }
        }

        private void CargarTransacciones()
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(conexion))
                {
                    string query = @"
                        SELECT 
                            t.IdTransaccion,
                            t.FechaTransaccion,
                            t.Descripcion,
                            t.TipoTransaccion,
                            c.NombreCategoria,
                            t.Monto
                        FROM Transacciones t
                        INNER JOIN Categorias c ON t.IdCategoria = c.IdCategoria
                        ORDER BY t.FechaTransaccion DESC";

                    SqlDataAdapter adapter = new SqlDataAdapter(query, conn);
                    DataTable dt = new DataTable();

                    conn.Open();
                    adapter.Fill(dt);

                    gvTransacciones.DataSource = dt;
                    gvTransacciones.DataBind();
                }
            }
            catch (Exception ex)
            {
                MostrarMensaje("Error al cargar transacciones: " + ex.Message, false);
            }
        }

        protected void btnGuardar_Click(object sender, EventArgs e)
        {
            try
            {
                
                string descripcion = txtDescripcion.Text.Trim();
                decimal monto = Convert.ToDecimal(txtMonto.Text);
                string tipo = ddlTipo.SelectedValue;
                int idCategoria = Convert.ToInt32(ddlCategoria.SelectedValue);
                DateTime fecha = Convert.ToDateTime(txtFecha.Text);
                string notas = txtNotas.Text.Trim();

                if (monto <= 0)
                {
                    MostrarMensaje("El monto debe ser mayor a 0", false);
                    return;
                }

                using (SqlConnection conn = new SqlConnection(conexion))
                {
                    conn.Open();
                    int idTransaccion = Convert.ToInt32(hfIdTransaccion.Value);

                    if (idTransaccion == 0)
                    {
                        string query = @"
                            INSERT INTO Transacciones (Descripcion, Monto, TipoTransaccion, IdCategoria, FechaTransaccion, Notas)
                            VALUES (@Descripcion, @Monto, @Tipo, @IdCategoria, @Fecha, @Notas)";

                        SqlCommand cmd = new SqlCommand(query, conn);
                        cmd.Parameters.AddWithValue("@Descripcion", descripcion);
                        cmd.Parameters.AddWithValue("@Monto", monto);
                        cmd.Parameters.AddWithValue("@Tipo", tipo);
                        cmd.Parameters.AddWithValue("@IdCategoria", idCategoria);
                        cmd.Parameters.AddWithValue("@Fecha", fecha);
                        cmd.Parameters.AddWithValue("@Notas", string.IsNullOrEmpty(notas) ? (object)DBNull.Value : notas);

                        cmd.ExecuteNonQuery();
                        MostrarMensaje("Transacción guardada exitosamente", true);
                    }
                    else
                    {
                        
                        string query = @"
                            UPDATE Transacciones 
                            SET Descripcion = @Descripcion,
                                Monto = @Monto,
                                TipoTransaccion = @Tipo,
                                IdCategoria = @IdCategoria,
                                FechaTransaccion = @Fecha,
                                Notas = @Notas
                            WHERE IdTransaccion = @IdTransaccion";

                        SqlCommand cmd = new SqlCommand(query, conn);
                        cmd.Parameters.AddWithValue("@IdTransaccion", idTransaccion);
                        cmd.Parameters.AddWithValue("@Descripcion", descripcion);
                        cmd.Parameters.AddWithValue("@Monto", monto);
                        cmd.Parameters.AddWithValue("@Tipo", tipo);
                        cmd.Parameters.AddWithValue("@IdCategoria", idCategoria);
                        cmd.Parameters.AddWithValue("@Fecha", fecha);
                        cmd.Parameters.AddWithValue("@Notas", string.IsNullOrEmpty(notas) ? (object)DBNull.Value : notas);

                        cmd.ExecuteNonQuery();
                        MostrarMensaje("Transacción actualizada exitosamente", true);
                    }
                }

                // Limpiar formulario y recargar
                LimpiarFormulario();
                CargarTransacciones();
            }
            catch (Exception ex)
            {
                MostrarMensaje("Error: " + ex.Message, false);
            }
        }

        protected void btnCancelar_Click(object sender, EventArgs e)
        {
            LimpiarFormulario();
        }

        protected void gvTransacciones_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int idTransaccion = Convert.ToInt32(e.CommandArgument);

            if (e.CommandName == "Editar")
            {
                CargarTransaccionParaEditar(idTransaccion);
            }
            else if (e.CommandName == "Eliminar")
            {
                EliminarTransaccion(idTransaccion);
            }
        }

        private void CargarTransaccionParaEditar(int idTransaccion)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(conexion))
                {
                    string query = @"
                        SELECT IdTransaccion, Descripcion, Monto, TipoTransaccion, 
                               IdCategoria, FechaTransaccion, Notas
                        FROM Transacciones
                        WHERE IdTransaccion = @IdTransaccion";

                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@IdTransaccion", idTransaccion);

                    conn.Open();
                    SqlDataReader reader = cmd.ExecuteReader();

                    if (reader.Read())
                    {
                        
                        hfIdTransaccion.Value = reader["IdTransaccion"].ToString();
                        txtDescripcion.Text = reader["Descripcion"].ToString();
                        txtMonto.Text = reader["Monto"].ToString();
                        ddlTipo.SelectedValue = reader["TipoTransaccion"].ToString();
                        ddlCategoria.SelectedValue = reader["IdCategoria"].ToString();
                        txtFecha.Text = Convert.ToDateTime(reader["FechaTransaccion"]).ToString("yyyy-MM-dd");
                        txtNotas.Text = reader["Notas"] != DBNull.Value ? reader["Notas"].ToString() : "";

                        lblTituloForm.Text = "Editar Transacción";
                    }

                    reader.Close();
                }
            }
            catch (Exception ex)
            {
                MostrarMensaje("Error al cargar transacción: " + ex.Message, false);
            }
        }

        private void EliminarTransaccion(int idTransaccion)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(conexion))
                {
                    string query = "DELETE FROM Transacciones WHERE IdTransaccion = @IdTransaccion";
                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@IdTransaccion", idTransaccion);

                    conn.Open();
                    cmd.ExecuteNonQuery();

                    MostrarMensaje("Transacción eliminada ", true);
                    CargarTransacciones();
                }
            }
            catch (Exception ex)
            {
                MostrarMensaje("Error al eliminar: " + ex.Message, false);
            }
        }

        private void LimpiarFormulario()
        {
            hfIdTransaccion.Value = "0";
            txtDescripcion.Text = "";
            txtMonto.Text = "";
            ddlTipo.SelectedIndex = 0;
            ddlCategoria.SelectedIndex = 0;
            txtFecha.Text = DateTime.Now.ToString("yyyy-MM-dd");
            txtNotas.Text = "";
            lblTituloForm.Text = "Nueva Transacción";
            pnlMensaje.Visible = false;
        }

        private void MostrarMensaje(string mensaje, bool esExito)
        {
            lblMensaje.Text = mensaje;
            lblMensaje.CssClass = esExito ? "mensaje mensaje-exito" : "mensaje mensaje-error";
            pnlMensaje.Visible = true;
        }
    }
}