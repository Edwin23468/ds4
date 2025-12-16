<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Flujo.aspx.cs" Inherits="SistemaGastos.Flujo" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <meta charset="utf-8" />
    <title>Flujo de Caja - Sistema de Gastos</title>
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
            align-items: flex-end;
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

        .indicadores {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 20px;
            margin-bottom: 30px;
        }

        .indicador {
            background-color: white;
            border: 2px solid #ddd;
            padding: 15px;
            text-align: center;
        }

        .indicador-titulo {
            font-size: 14px;
            color: #666;
            margin-bottom: 10px;
        }

        .indicador-valor {
            font-size: 24px;
            font-weight: bold;
            color: #0066cc;
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

        .tabla tr:hover { background-color: #f0f0f0; }

        .positivo { color: #009900; font-weight: bold; }
        .negativo { color: #cc0000; font-weight: bold; }

        .footer {
            background-color: #333;
            color: white;
            text-align: center;
            padding: 15px;
            margin-top: 30px;
        }

        .mensaje-info {
            background-color: #d4edda;
            border: 1px solid #c3e6cb;
            color: #155724;
            padding: 15px;
            border-radius: 3px;
            margin-bottom: 20px;
        }

        .mensaje-info strong { display: block; margin-bottom: 5px; }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        
        <div class="header">
            <h1>Flujo de Caja</h1>
        </div>

        <div class="menu">
            <ul>
                <li><a href="Default.aspx">Inicio</a></li>
                <li><a href="Transacciones.aspx">Transacciones</a></li>
                <li><a href="Reportes.aspx">📊 Reportes</a></li>
                <li><a href="Flujo.aspx" class="active">Flujo de Caja</a></li>
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
                    <div>
                        <asp:Button ID="btnAnalizar" runat="server" Text="📊 Analizar" 
                            CssClass="btn" OnClick="btnAnalizar_Click" />
                    </div>
                </div>
            </div>

            <!-- INDICADORES -->
            <div class="indicadores">
                <div class="indicador">
                    <div class="indicador-titulo">SALDO INICIAL</div>
                    <asp:Label ID="lblSaldoInicial" runat="server" CssClass="indicador-valor" Text="$0.00"></asp:Label>
                </div>

                <div class="indicador">
                    <div class="indicador-titulo">SALDO FINAL</div>
                    <asp:Label ID="lblSaldoFinal" runat="server" CssClass="indicador-valor" Text="$0.00"></asp:Label>
                </div>

                <div class="indicador">
                    <div class="indicador-titulo">VARIACIÓN</div>
                    <asp:Label ID="lblVariacion" runat="server" CssClass="indicador-valor" Text="$0.00"></asp:Label>
                </div>
            </div>

            <!-- FLUJO MENSUAL -->
            <div class="seccion">
                <div class="seccion-titulo"> Flujo del Mes</div>
                
                <asp:GridView ID="gvFlujo" runat="server" 
                    CssClass="tabla"
                    AutoGenerateColumns="False"
                    GridLines="None">
                    <Columns>
                        <asp:BoundField DataField="Concepto" HeaderText="Concepto" />
                        
                        <asp:TemplateField HeaderText="Monto">
                            <ItemTemplate>
                                <span class='<%# Convert.ToDecimal(Eval("Monto")) >= 0 ? "positivo" : "negativo" %>'>
                                    <%# Convert.ToDecimal(Eval("Monto")).ToString("C2") %>
                                </span>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                    <EmptyDataTemplate>
                        <p style="text-align:center; padding:20px; color:#999;">
                            No hay datos para el período seleccionado
                        </p>
                    </EmptyDataTemplate>
                </asp:GridView>
            </div>

            
            <div class="seccion">
                <div class="seccion-titulo">📊 Detalle por Categoría</div>
                
                <asp:GridView ID="gvCategoria" runat="server" 
                    CssClass="tabla"
                    AutoGenerateColumns="False"
                    GridLines="None">
                    <Columns>
                        <asp:BoundField DataField="NombreCategoria" HeaderText="Categoría" />
                        <asp:BoundField DataField="TotalIngresos" HeaderText="Ingresos" 
                            DataFormatString="{0:C2}" />
                        <asp:BoundField DataField="TotalGastos" HeaderText="Gastos" 
                            DataFormatString="{0:C2}" />
                        <asp:BoundField DataField="Diferencia" HeaderText="Diferencia" 
                            DataFormatString="{0:C2}" />
                    </Columns>
                </asp:GridView>
            </div>

        </div>

        <div class="footer">
            <p>Sistema de Gastos Personales - Edwin Cisneros</p>
        </div>

    </form>
</body>
</html>