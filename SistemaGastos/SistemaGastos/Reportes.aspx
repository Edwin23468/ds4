<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Reportes.aspx.cs" Inherits="SistemaGastos.Reportes" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <meta charset="utf-8" />
    <title>Reportes - Sistema de Gastos</title>
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

        .header h1 { margin: 0; font-size: 28px; }

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

        .menu li { flex: 1; }

        .menu a {
            display: block;
            color: white;
            text-decoration: none;
            padding: 15px;
            text-align: center;
        }

        .menu a:hover { background-color: #0066cc; }
        .menu a.active { background-color: #0066cc; }

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

        .filtros {
            display: flex;
            gap: 15px;
            margin-bottom: 20px;
        }

        .filtros label {
            display: block;
            font-weight: bold;
            margin-bottom: 5px;
        }

        .filtros select {
            padding: 8px;
            border: 1px solid #ccc;
            border-radius: 3px;
            width: 150px;
        }

        .btn {
            padding: 10px 20px;
            background-color: #0066cc;
            color: white;
            border: none;
            border-radius: 3px;
            font-weight: bold;
            cursor: pointer;
        }

        .btn:hover { background-color: #004499; }

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

        .card.gastos { border-left: 5px solid #cc0000; }
        .card.ingresos { border-left: 5px solid #009900; }
        .card.balance { border-left: 5px solid #0066cc; }

        .card-titulo {
            font-size: 14px;
            color: #666;
            margin-bottom: 10px;
        }

        .card-valor {
            font-size: 28px;
            font-weight: bold;
        }

        .card-valor.gastos { color: #cc0000; }
        .card-valor.ingresos { color: #009900; }
        .card-valor.balance { color: #0066cc; }

        .grafico {
            text-align: center;
            padding: 20px;
        }

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
            <h1>📊 Reportes</h1>
        </div>

        <div class="menu">
            <ul>
                <li><a href="Default.aspx">Inicio</a></li>
                <li><a href="Transacciones.aspx">Transacciones</a></li>
                <li><a href="Reportes.aspx" class="active">📊 Reportes</a></li>
                <li><a href="Flujo.aspx">Flujo de Caja</a></li>
            </ul>
        </div>

        <div class="container">
            
            <!-- FILTROS -->
            <div class="seccion">
                <div class="seccion-titulo">🔍 Seleccionar Período</div>
                
                <div class="filtros">
                    <div>
                        <label>Año:</label>
                        <asp:DropDownList ID="ddlAño" runat="server"></asp:DropDownList>
                    </div>
                    <div>
                        <label>Mes:</label>
                        <asp:DropDownList ID="ddlMes" runat="server">
                            <asp:ListItem Value="0">Todos los meses</asp:ListItem>
                            <asp:ListItem Value="1">Enero</asp:ListItem>
                            <asp:ListItem Value="2">Febrero</asp:ListItem>
                            <asp:ListItem Value="3">Marzo</asp:ListItem>
                            <asp:ListItem Value="4">Abril</asp:ListItem>
                            <asp:ListItem Value="5">Mayo</asp:ListItem>
                            <asp:ListItem Value="6">Junio</asp:ListItem>
                            <asp:ListItem Value="7">Julio</asp:ListItem>
                            <asp:ListItem Value="8">Agosto</asp:ListItem>
                            <asp:ListItem Value="9">Septiembre</asp:ListItem>
                            <asp:ListItem Value="10">Octubre</asp:ListItem>
                            <asp:ListItem Value="11">Noviembre</asp:ListItem>
                            <asp:ListItem Value="12">Diciembre</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                    <div style="align-self: flex-end;">
                        <asp:Button ID="btnFiltrar" runat="server" Text="🔍 Filtrar" 
                            CssClass="btn" OnClick="btnFiltrar_Click" />
                    </div>
                </div>
            </div>

            <!-- TARJETAS DE TOTALES -->
            <div class="cards">
                <div class="card gastos">
                    <div class="card-titulo">TOTAL GASTOS</div>
                    <asp:Label ID="lblGastos" runat="server" CssClass="card-valor gastos" Text="$0.00"></asp:Label>
                </div>

                <div class="card ingresos">
                    <div class="card-titulo">TOTAL INGRESOS</div>
                    <asp:Label ID="lblIngresos" runat="server" CssClass="card-valor ingresos" Text="$0.00"></asp:Label>
                </div>

                <div class="card balance">
                    <div class="card-titulo">BALANCE</div>
                    <asp:Label ID="lblBalance" runat="server" CssClass="card-valor balance" Text="$0.00"></asp:Label>
                </div>
            </div>

          
            <div class="seccion">
                <div class="seccion-titulo">Gastos por Categoría</div>
                <div class="grafico">
                    <canvas id="chartCategoria" style="max-height: 350px;"></canvas>
                </div>
            </div>

           
            <div class="seccion">
                <div class="seccion-titulo">Detalle por Categoría</div>
                
                <asp:GridView ID="gvResumen" runat="server" 
                    CssClass="tabla"
                    AutoGenerateColumns="False"
                    GridLines="None">
                    <Columns>
                        <asp:BoundField DataField="NombreCategoria" HeaderText="Categoría" />
                        <asp:BoundField DataField="TotalGastos" HeaderText="Total Gastos" 
                            DataFormatString="{0:C2}" />
                        <asp:BoundField DataField="TotalIngresos" HeaderText="Total Ingresos" 
                            DataFormatString="{0:C2}" />
                        <asp:BoundField DataField="Balance" HeaderText="Balance" 
                            DataFormatString="{0:C2}" />
                    </Columns>
                    <EmptyDataTemplate>
                        <p style="text-align:center; padding:20px; color:#999;">
                            No hay datos para el período seleccionado
                        </p>
                    </EmptyDataTemplate>
                </asp:GridView>
            </div>

        </div>

        <div class="footer">
            <p>Sistema de Gastos Personales - Edwin Cisneros</p>
        </div>

    </form>

   
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script>
        
        var datosJSON = '<%= ObtenerDatosGrafico() %>';
        var datos = JSON.parse(datosJSON);

        
        if (datos.categorias && datos.categorias.length > 0) {
            var ctx = document.getElementById('chartCategoria').getContext('2d');
            new Chart(ctx, {
                type: 'bar',
                data: {
                    labels: datos.categorias,
                    datasets: [{
                        label: 'Monto ($)',
                        data: datos.montos,
                        backgroundColor: '#0066cc'
                    }]
                },
                options: {
                    responsive: true,
                    plugins: {
                        legend: { display: false }
                    },
                    scales: {
                        y: { beginAtZero: true }
                    }
                }
            });
        } else {
            document.getElementById('chartCategoria').style.display = 'none';
        }
    </script>

</body>
</html>