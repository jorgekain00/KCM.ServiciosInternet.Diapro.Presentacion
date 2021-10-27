using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using OfficeOpenXml;
using System.Data;
using System.Reflection;
using OfficeOpenXml.Style;
using System.Drawing;

namespace KCM.ServiciosInternet.Common.Library.Enumerable
{
    public class Excel
    {
        public static DataTable ConvertToDataTable<TSource>(IEnumerable<TSource> objSource, string strTableName = "Table")
        {
            PropertyInfo[] objProperties = typeof(TSource).GetProperties();
            DataTable objTable = new DataTable(strTableName);
            objTable.Columns.AddRange(objProperties.Select(prop => new DataColumn(prop.Name, prop.PropertyType)).ToArray());

            objSource.ToList().ForEach(objS => objTable.Rows.Add(objProperties.Select(p => p.GetValue(objS, null)).ToArray()));

            return objTable;
        }

        public static void GetExcelFromIEnumerable<TSource>(IEnumerable<TSource> objSource, ExcelPackage objEP, string strSheet)
        {
            DataTable objTable = Excel.ConvertToDataTable(objSource);

            int intRows = objTable.Rows.Count;
            int intCol = objTable.Columns.Count;
            char cRighLimit = (char)((int)'A' + intCol-1);

            ExcelWorksheet objWS = objEP.Workbook.Worksheets.Add(strSheet);

            //add all the content from the DataTable, starting at cell A1
            objWS.Cells["A1"].LoadFromDataTable(objTable, true);
            //Format headers
            // solid Blue for background
            objWS.Cells["A1:" + cRighLimit.ToString() + "1"].Style.Fill.PatternType = ExcelFillStyle.Solid;
            objWS.Cells["A1:" + cRighLimit.ToString() + "1"].Style.Fill.BackgroundColor.SetColor(Color.DarkBlue);
            // format the typographic
            objWS.Cells["A1:" + cRighLimit.ToString() + "1"].Style.Font.Size = 13;
            objWS.Cells["A1:" + cRighLimit.ToString() + "1"].Style.Font.Name = "Arial";
            objWS.Cells["A1:" + cRighLimit.ToString() + "1"].Style.Font.Bold = true;
            objWS.Cells["A1:" + cRighLimit.ToString() + "1"].Style.Font.Color.SetColor(Color.White);
            // black thin borders 
            objWS.Cells["A1:" + cRighLimit.ToString() + (intRows + 1)].Style.Border.Top.Style = ExcelBorderStyle.Thin;
            objWS.Cells["A1:" + cRighLimit.ToString() + (intRows + 1)].Style.Border.Right.Style = ExcelBorderStyle.Thin;
            objWS.Cells["A1:" + cRighLimit.ToString() + (intRows + 1)].Style.Border.Bottom.Style = ExcelBorderStyle.Thin;
            objWS.Cells["A1:" + cRighLimit.ToString() + (intRows + 1)].Style.Border.Left.Style = ExcelBorderStyle.Thin;

            // Autofit
            objWS.Cells["A1:" + cRighLimit.ToString() + (intRows + 1)].AutoFitColumns();
        }
    }
}
