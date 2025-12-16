<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="SistemaGastos.Default" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <meta charset="utf-8" />
    <title>Inicio - Sistema de Gastos</title>
    <style>
        /* ==================================== */
        /* ESTILOS SIMPLES Y BÁSICOS */
        /* ==================================== */
        
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f5f5f5;
        }

        /* Encabezado */
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

        /* Menú de navegación */
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

        /* Contenedor principal */
        .container {
            max-width: 1200px;
            margin: 20px auto;
            padding: 0 20px;
        }

        /* Tarjetas de resumen */
        .cards {
            display: flex;
            gap: 20px;
            margin-bottom: 30px;
        }

        .card {
            flex: 1;
            background-color: white;
            border: 2px solid #ddd;
            padding: 20px;
            text-align: center;
        }

        .card.gastos {
            border-left: 5px solid #cc0000;
        }

        .card.ingresos {
            border-left: 5px solid #009900;
        }

        .card.balance {
            border-left: 5px solid #0066cc;
        }

        .card-titulo {
            font-size: 14px;
            color: #666;
            margin-bottom: 10px;
        }

        .card-valor {
            font-size: 32px;
            font-weight: bold;
            margin: 0;
        }

        .card-valor.gastos { color: #cc0000; }
        .card-valor.ingresos { color: #009900; }
        .card-valor.balance { color: #0066cc; }

        /* contenido */
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

        /* tablas */
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

        /* badges */
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

        /* botones */
        .botones {
            text-align: center;
            margin-top: 30px;
        }

        .boton {
            display: inline-block;
            padding: 12px 30px;
            margin: 0 10px;
            background-color: #0066cc;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            font-weight: bold;
        }

        .boton:hover {
            background-color: #004499;
        }

        /* footer */
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
            <h1>Sistema de Gastos Personales</h1>
        </div>

        <!-- MENÚ DE NAVEGACIÓN -->
        <div class="menu">
            <ul>
                <li><a href="Default.aspx" class="active">Inicio</a></li>
                <li><a href="Transacciones.aspx">Transacciones</a></li>
                <li><a href="Reportes.aspx">📊 Reportes</a></li>
                <li><a href="Flujo.aspx">Flujo de Caja</a></li>
            </ul>
        </div>

        
        <div class="container">
            
            
            <div class="cards">
                <div class="card gastos">
                    <div class="card-titulo">GASTOS DEL MES</div>
                    <asp:Label ID="lblTotalGastos" runat="server" CssClass="card-valor gastos" Text="$0.00"></asp:Label>
                </div>

                <div class="card ingresos">
                    <div class="card-titulo">INGRESOS DEL MES</div>
                    <asp:Label ID="lblTotalIngresos" runat="server" CssClass="card-valor ingresos" Text="$0.00"></asp:Label>
                </div>

                <div class="card balance">
                    <div class="card-titulo">BALANCE</div>
                    <asp:Label ID="lblBalance" runat="server" CssClass="card-valor balance" Text="$0.00"></asp:Label>
                </div>
            </div>

            <div class="seccion">
                <div class="seccion-titulo">Últimas 10 Transacciones</div>
                
                <asp:GridView ID="gvTransacciones" runat="server" 
                    CssClass="tabla"
                    AutoGenerateColumns="False"
                    GridLines="None">
                    <Columns>
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
                    </Columns>
                    <EmptyDataTemplate>
                        <p style="text-align:center; padding:20px; color:#999;">
                            No hay transacciones registradas
                        </p>
                    </EmptyDataTemplate>
                </asp:GridView>
            </div>

            <!-- BOTONES DE ACCESO RÁPIDO -->
            <div class="botones">
                <a href="Transacciones.aspx" class="boton">➕ Nueva Transacción</a>
                <a href="Reportes.aspx" class="boton">📊 Ver Reportes</a>
                <a href="Flujo.aspx" class="boton">💵 Flujo de Caja</a>
            </div>

        </div>

        <!-- FOOTER -->
        <div class="footer">
            <p>Sistema de Gastos Personales - Edwin Cisneros </p>
        </div>

    </form>
</body>
</html>