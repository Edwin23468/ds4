<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Transacciones.aspx.cs" Inherits="SistemaGastos.Transacciones" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <meta charset="utf-8" />
    <title>Transacciones - Sistema de Gastos</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f5f5f5;
        }

        .header {
            background-color: #0066cc;
            color: white;
            padding: 20px;
            text-align: center;
        }

        .header h1 {
            margin: 0;
            font-size: 28px;
        }

        .menu {
            background-color: #004499;
            padding: 0;
            margin: 0;
        }

        .menu ul {
            list-style: none;
            margin: 0;
            padding: 0;
            display: flex;
        }

        .menu li {
            flex: 1;
        }

        .menu a {
            display: block;
            color: white;
            text-decoration: none;
            padding: 15px;
            text-align: center;
        }

        .menu a:hover {
            background-color: #0066cc;
        }

        .menu a.active {
            background-color: #0066cc;
        }

        .container {
            max-width: 1200px;
            margin: 20px auto;
            padding: 0 20px;
        }

        .seccion {
            background-color: white;
            border: 2px solid #ddd;
            padding: 20px;
            margin-bottom: 20px;
        }

        .seccion-titulo {
            font-size: 20px;
            font-weight: bold;
            margin-bottom: 15px;
            color: #333;
            border-bottom: 2px solid #0066cc;
            padding-bottom: 10px;
        }

        /* Formulario */
        .form-group {
            margin-bottom: 15px;
        }

        .form-group label {
            display: block;
            font-weight: bold;
            margin-bottom: 5px;
            color: #333;
        }

        .form-control {
            width: 100%;
            padding: 8px;
            border: 1px solid #ccc;
            border-radius: 3px;
            font-size: 14px;
        }

        .form-row {
            display: flex;
            gap: 15px;
        }

        .form-row .form-group {
            flex: 1;
        }

        /* Botones */
        .botones {
            margin-top: 15px;
        }

        .btn {
            padding: 10px 20px;
            border: none;
            border-radius: 3px;
            font-weight: bold;
            cursor: pointer;
            margin-right: 10px;
        }

        .btn-guardar {
            background-color: #009900;
            color: white;
        }

        .btn-guardar:hover {
            background-color: #007700;
        }

        .btn-cancelar {
            background-color: #cc0000;
            color: white;
        }

        .btn-cancelar:hover {
            background-color: #aa0000;
        }

        

        /* Tabla */
        .tabla {
            width: 100%;
            border-collapse: collapse;
        }

        .tabla th {
            background-color: #0066cc;
            color: white;
            padding: 10px;
            text-align: left;
        }

        .tabla td {
            padding: 10px;
            border-bottom: 1px solid #ddd;
        }

        .tabla tr:hover {
            background-color: #f0f0f0;
        }

        .badge-gasto {
            background-color: #cc0000;
            color: white;
            padding: 3px 8px;
            border-radius: 3px;
            font-size: 12px;
        }

        .badge-ingreso {
            background-color: #009900;
            color: white;
            padding: 3px 8px;
            border-radius: 3px;
            font-size: 12px;
        }

        .btn-editar {
            background-color: #0066cc;
            color: white;
            padding: 5px 10px;
            border-radius: 3px;
            text-decoration: none;
            font-size: 12px;
        }

        .btn-eliminar {
            background-color: #cc0000;
            color: white;
            padding: 5px 10px;
            border-radius: 3px;
            text-decoration: none;
            font-size: 12px;
        }

        .mensaje {
            padding: 10px;
            margin-bottom: 15px;
            border-radius: 3px;
            text-align: center;
            font-weight: bold;
        }

        .mensaje-exito {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }

        .mensaje-error {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }

        .footer {
            background-color: #333;
            color: white;
            text-align: center;
            padding: 15px;
            margin-top: 30px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        
        <div class="header">
            <h1>📝 Transacciones</h1>
        </div>

        <div class="menu">
            <ul>
                <li><a href="Default.aspx">Inicio</a></li>
                <li><a href="Transacciones.aspx" class="active">Transacciones</a></li>
                <li><a href="Reportes.aspx">📊 Reportes</a></li>
                <li><a href="Flujo.aspx">Flujo de Caja</a></li>
            </ul>
        </div>

        <div class="container">
            
            
            <asp:Panel ID="pnlMensaje" runat="server" Visible="false">
                <asp:Label ID="lblMensaje" runat="server"></asp:Label>
            </asp:Panel>

           
            <div class="seccion">
                <div class="seccion-titulo">
                    <asp:Label ID="lblTituloForm" runat="server" Text="Nueva Transacción"></asp:Label>
                </div>

                <asp:HiddenField ID="hfIdTransaccion" runat="server" Value="0" />

                <div class="form-row">
                    <div class="form-group">
                        <label>Descripción *</label>
                        <asp:TextBox ID="txtDescripcion" runat="server" CssClass="form-control" 
                            placeholder="Ej: Quincena" MaxLength="200"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvDescripcion" runat="server" 
                            ControlToValidate="txtDescripcion" 
                            ErrorMessage="La descripción es obligatoria"
                            ForeColor="Red" Display="Dynamic" />
                    </div>

                    <div class="form-group">
                        <label>Monto *</label>
                        <asp:TextBox ID="txtMonto" runat="server" CssClass="form-control" 
                            placeholder="0.00" TextMode="Number" step="0.01"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvMonto" runat="server" 
                            ControlToValidate="txtMonto" 
                            ErrorMessage="El monto es obligatorio"
                            ForeColor="Red" Display="Dynamic" />
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label>Tipo *</label>
                        <asp:DropDownList ID="ddlTipo" runat="server" CssClass="form-control">
                            <asp:ListItem Value="">-- Seleccionar --</asp:ListItem>
                            <asp:ListItem Value="Gasto">Gasto</asp:ListItem>
                            <asp:ListItem Value="Ingreso">Ingreso</asp:ListItem>
                        </asp:DropDownList>
                        <asp:RequiredFieldValidator ID="rfvTipo" runat="server" 
                            ControlToValidate="ddlTipo" 
                            InitialValue=""
                            ErrorMessage="Debe seleccionar el tipo"
                            ForeColor="Red" Display="Dynamic" />
                    </div>

                    <div class="form-group">
                        <label>Categoría *</label>
                        <asp:DropDownList ID="ddlCategoria" runat="server" CssClass="form-control">
                            <asp:ListItem Value="0">-- Seleccionar --</asp:ListItem>
                        </asp:DropDownList>
                        <asp:RequiredFieldValidator ID="rfvCategoria" runat="server" 
                            ControlToValidate="ddlCategoria" 
                            InitialValue="0"
                            ErrorMessage="Debe seleccionar una categoría"
                            ForeColor="Red" Display="Dynamic" />
                    </div>

                    <div class="form-group">
                        <label>Fecha *</label>
                        <asp:TextBox ID="txtFecha" runat="server" CssClass="form-control" 
                            TextMode="Date"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvFecha" runat="server" 
                            ControlToValidate="txtFecha" 
                            ErrorMessage="La fecha es obligatoria"
                            ForeColor="Red" Display="Dynamic" />
                    </div>
                </div>

                <div class="form-group">
                    <label>Notas (opcional)</label>
                    <asp:TextBox ID="txtNotas" runat="server" CssClass="form-control" 
                        TextMode="MultiLine" Rows="2" MaxLength="500"
                        placeholder="Información adicional"></asp:TextBox>
                </div>

                <div class="botones">
                    <asp:Button ID="btnGuardar" runat="server" Text="💾 Guardar" 
                        CssClass="btn btn-guardar" OnClick="btnGuardar_Click" />
                    
                    <asp:Button ID="btnCancelar" runat="server" Text="❌ Cancelar" 
                        CssClass="btn btn-cancelar" OnClick="btnCancelar_Click" 
                        CausesValidation="False" />
                   
                </div>
            </div>

           
            <div class="seccion">
                <div class="seccion-titulo">Listado de Transacciones</div>

                <asp:GridView ID="gvTransacciones" runat="server" 
                    CssClass="tabla"
                    AutoGenerateColumns="False"
                    GridLines="None"
                    OnRowCommand="gvTransacciones_RowCommand">
                    <Columns>
                        <asp:BoundField DataField="IdTransaccion" HeaderText="ID" Visible="false" />
                        
                        <asp:BoundField DataField="FechaTransaccion" HeaderText="Fecha" 
                            DataFormatString="{0:dd/MM/yyyy}" />
                        
                        <asp:BoundField DataField="Descripcion" HeaderText="Descripción" />
                        
                        <asp:TemplateField HeaderText="Tipo">
                            <ItemTemplate>
                                <span class='<%# Eval("TipoTransaccion").ToString() == "Gasto" ? "badge-gasto" : "badge-ingreso" %>'>
                                    <%# Eval("TipoTransaccion") %>
                                </span>
                            </ItemTemplate>
                        </asp:TemplateField>
                        
                        <asp:BoundField DataField="NombreCategoria" HeaderText="Categoría" />
                        
                        <asp:BoundField DataField="Monto" HeaderText="Monto" 
                            DataFormatString="{0:C2}" />
                        
                        <asp:TemplateField HeaderText="Acciones">
                            <ItemTemplate>
                                <asp:LinkButton ID="btnEditar" runat="server" 
                                    CssClass="btn-editar"
                                    CommandName="Editar" 
                                    CommandArgument='<%# Eval("IdTransaccion") %>'
                                    CausesValidation="False">
                                     Editar
                                </asp:LinkButton>
                                
                                <asp:LinkButton ID="btnEliminar" runat="server" 
                                    CssClass="btn-eliminar"
                                    CommandName="Eliminar" 
                                    CommandArgument='<%# Eval("IdTransaccion") %>'
                                    CausesValidation="False"
                                    OnClientClick="return confirm('¿Está seguro de eliminar esta transacción?');">
                                     Eliminar
                                </asp:LinkButton>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                    <EmptyDataTemplate>
                        <p style="text-align:center; padding:20px; color:#999;">
                            No hay transacciones registradas
                        </p>
                    </EmptyDataTemplate>
                </asp:GridView>
            </div>

        </div>

        <div class="footer">
            <p>Sistema de Gastos Personales - Edwin Cisneros</p>
        </div>

    </form>
</body>
</html>
