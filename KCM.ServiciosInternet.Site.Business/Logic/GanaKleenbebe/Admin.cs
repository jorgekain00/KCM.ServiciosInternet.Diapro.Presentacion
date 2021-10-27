using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Text;
using System.Threading.Tasks;
using System.Web.Script.Serialization;
using KCM.ServiciosInternet.Common.Library.Log;
using KCM.ServiciosInternet.Google.Services;
using KCM.ServiciosInternet.Site.Entity.Config;
using GlobalConfig = KCM.ServiciosInternet.Site.Entity.Config;
using KCM.ServiciosInternet.Site.Entity.www.gana.kleenbebe.com_1.Data;
using KCM.ServiciosInternet.Site.Entity.www.gana.kleenbebe.com_1.Formularios;
using ContextDB = KCM.ServiciosInternet.Site.Entity.www.gana.kleenbebe.com_1.BD.EF;
using Newtonsoft.Json;
using SSOData = KCM.ServiciosInternet.Site.Entity.SSO;
using System.Data.Entity;
using System.Drawing;
using System.Drawing.Imaging;
using KCM.ServiciosInternet.Site.Entity.www.gana.kleenbebe.com_1.BD.EF;
using System.Data.Entity.Core.Objects;
using KCM.ServiciosInternet.Common.Library.Enumerable;
using Microsoft.Reporting.WinForms;
using OfficeOpenXml;
using System.IO.Compression;
using ICSharpCode.SharpZipLib.Zip;

namespace KCM.ServiciosInternet.Site.Business.Logic.GanaKleenbebe
{
    public class Admin : IDisposable
    {
        private string _strKeyLog = DateTime.Now.ToString();
        public Admin()
        {

        }

        #region Winners
        internal Data WinnersGetRangeDates(Data objData)
        {
            clsEscribirLog.EscribeDebug(this._strKeyLog, clsEscribirLog.enumTipoMensaje.Informativo, "KCM.ServiciosInternet.Site.Business.Logic.GanaKleenbebe.Admin.WinnersGetRangeDates", "Begin process");
            using (ContextDB.GanaKleenbebe objCtx = new ContextDB.GanaKleenbebe())
            {
                objData.Body = objCtx.Winners_GetRangeDates(DateTime.Now).AsEnumerable().ToList();
            }
            clsEscribirLog.EscribeDebug(this._strKeyLog, clsEscribirLog.enumTipoMensaje.Informativo, "KCM.ServiciosInternet.Site.Business.Logic.GanaKleenbebe.Admin.WinnersGetRangeDates", string.Format("End process - Numbers of pivots:'{0}'", (objData.Body as List<Winners_GetRangeDates_Result>).Count));
            return objData;
        }
        internal Data WinnersGetTickets(Data objData)
        {
            clsEscribirLog.EscribeDebug(this._strKeyLog, clsEscribirLog.enumTipoMensaje.Informativo, "KCM.ServiciosInternet.Site.Business.Logic.GanaKleenbebe.Admin.WinnersGetTickets", string.Format("Begin process - row : '{0}'", objData.strUID));
            using (ContextDB.GanaKleenbebe objCtx = new ContextDB.GanaKleenbebe())
            {
                Winners_GetRangeDates_Result objPivot = JsonConvert.DeserializeObject<Winners_GetRangeDates_Result>(objData.Body.ToString());
                if (objPivot != null)
                {
                    objData.Body = objCtx.Winners_GetTickets(GlobalConfig.Global.intAdminRowsByPage, objData.strUID, objPivot.Id).AsEnumerable().ToList();
                }
                else
                {
                    throw new Exception("No valid Winners_GetRangeDates_Result object into objData.Body");
                }
            }
            clsEscribirLog.EscribeDebug(this._strKeyLog, clsEscribirLog.enumTipoMensaje.Informativo, "KCM.ServiciosInternet.Site.Business.Logic.GanaKleenbebe.Admin.WinnersGetTickets", string.Format("End process - Numbers of pivots:'{0}'", (objData.Body as List<Winners_GetTickets_Result>).Count));
            return objData;
        }
        internal Data WinnersUpdateTicketByPivotDay(Data objData)
        {
            clsEscribirLog.EscribeDebug(this._strKeyLog, clsEscribirLog.enumTipoMensaje.Informativo, "KCM.ServiciosInternet.Site.Business.Logic.GanaKleenbebe.Admin.WinnersUpdateTicketByPivotDay", "Begin process");
            using (ContextDB.GanaKleenbebe objCtx = new ContextDB.GanaKleenbebe())
            {
                using (DbContextTransaction objTrans = objCtx.Database.BeginTransaction())
                {
                    try
                    {
                        Winners_GetRangeDates_Result objPivot = JsonConvert.DeserializeObject<Winners_GetRangeDates_Result>(objData.Body.ToString());
                        if (objPivot != null)
                        {
                            clsEscribirLog.EscribeDebug(this._strKeyLog, clsEscribirLog.enumTipoMensaje.Informativo, "KCM.ServiciosInternet.Site.Business.Logic.GanaKleenbebe.Admin.WinnersUpdateTicketByPivotDay", string.Format("Update pivot '{0}'", objPivot.Id));
                            int intNumberRows = objCtx.Winners_UpdateTicketByPivotDay(objPivot.Id).AsEnumerable().First().Value;
                            if (intNumberRows > 0)
                            {
                                objData.Body = objCtx.Winners_GetTickets(GlobalConfig.Global.intAdminRowsByPage, string.Empty, objPivot.Id).AsEnumerable().ToList();
                            }
                            else
                            {
                                objData.Body = new List<Winners_GetTickets_Result>();
                            }
                            objTrans.Commit();
                            objData.IsSuccessful = true;
                        }
                        else
                        {
                            throw new Exception("No valid Winners_GetRangeDates_Result object into objData.Body");
                        }
                    }
                    catch (Exception ex)
                    {
                        objTrans.Rollback();
                        objData.IsSuccessful = false;
                        objData.strErrorMessage = "No se pudo cargar los tickets del corte seleccionado, favor de contactar al administrador";
                        clsEscribirLog.EscribeLog(DateTime.Now.ToString(), clsEscribirLog.enumTipoMensaje.Informativo, "KCM.ServiciosInternet.Site.Business.Logic.GanaKleenbebe.GanaKleenbebe.Admin.WinnersUpdateTicketByPivotDay", "An exception ocurred");
                        clsEscribirLog.EscribeLog(DateTime.Now.ToString(), clsEscribirLog.enumTipoMensaje.Excepcion, "KCM.ServiciosInternet.Site.Business.Logic.GanaKleenbebe.GanaKleenbebe.Admin.WinnersUpdateTicketByPivotDay", ex, true);
                    }
                }
            }
            clsEscribirLog.EscribeDebug(this._strKeyLog, clsEscribirLog.enumTipoMensaje.Informativo, "KCM.ServiciosInternet.Site.Business.Logic.GanaKleenbebe.Admin.WinnersUpdateTicketByPivotDay", string.Format("End process - IsSuccesful:'{0}'", objData.IsSuccessful));
            return objData;
        }

        internal Data sendAdminCredentials(Data objData)
        {

            clsEscribirLog.EscribeDebug(this._strKeyLog, clsEscribirLog.enumTipoMensaje.Informativo, "KCM.ServiciosInternet.Site.Business.Logic.GanaKleenbebe.Admin.sendAdminCredentials", "Begin process");

            if (BussinessGoogle.isExpiredReCaptcha(strCatchapSecretKey: Global.strRecaptchaSecretKey, strCaptchaToken: objData.Body.ToString(), strProviderUrlValidator: Global.strRecaptchaUrlValidator))
            {
                objData.IsSuccessful = false;
                objData.strErrorMessage = "Recaptcha Inválido";
                objData.Body = string.Empty;
            }
            else
            {
                using (ContextDB.GanaKleenbebe objCtx = new ContextDB.GanaKleenbebe())
                {
                    dynamic objRequest = JsonConvert.DeserializeObject(objData.strUID);
                    string strEmail = objRequest.email;
                    Session_GetAdminUser_Result objResult = objCtx.Session_GetAdminUser(strEmail).FirstOrDefault();
                    if (objResult != null && objRequest.password == objResult.Password)
                    {
                        objData.IsSuccessful = true;
                        objResult.Password = string.Empty;
                        objData.Body = objResult;
                    }
                    else
                    {
                        objData.IsSuccessful = false;
                        objData.strErrorMessage = "Contraseña o password inválidos";
                    }
                }
            }
            clsEscribirLog.EscribeDebug(this._strKeyLog, clsEscribirLog.enumTipoMensaje.Informativo, "KCM.ServiciosInternet.Site.Business.Logic.GanaKleenbebe.Admin.sendAdminCredentials", "End process");
            return objData;
        }

        internal Data WinnersGetTicketImage(Data objData)
        {
            clsEscribirLog.EscribeDebug(this._strKeyLog, clsEscribirLog.enumTipoMensaje.Informativo, "KCM.ServiciosInternet.Site.Business.Logic.GanaKleenbebe.Admin.WinnersGetTicketImage", string.Format("Begin process - UID : '{0}' - Ticket : '{1}'", objData.strUID, objData.Body.ToString()));
            string strPath = GlobalConfig.Global.strDataPath + @"\Tickets\" + objData.strUID;
            string[] strFilesCollection = Directory.GetFiles(strPath, objData.Body.ToString().Trim() + ".*", SearchOption.TopDirectoryOnly);
            string strExtension = Path.GetExtension(strFilesCollection[0]);

            string strBase64 = string.Empty;
            string strType = string.Empty;

            using (System.Drawing.Image image = System.Drawing.Image.FromFile(strFilesCollection[0]))
            {
                using (MemoryStream m = new MemoryStream())
                {
                    image.Save(m, image.RawFormat);
                    byte[] imageBytes = m.ToArray();
                    strBase64 = Convert.ToBase64String(imageBytes);
                    if (strExtension == ".png")
                    {
                        strType = "data:image/png;base64,";
                    }
                    else
                    {
                        strType = "data:image/jpeg;base64,";
                    }
                    objData.Body = string.Concat(strType, strBase64);
                }
            }
            objData.IsSuccessful = true;
            clsEscribirLog.EscribeDebug(this._strKeyLog, clsEscribirLog.enumTipoMensaje.Informativo, "KCM.ServiciosInternet.Site.Business.Logic.GanaKleenbebe.Admin.WinnersGetTicketImage", string.Format("End process - IsSuccesfull: '{0}'", objData.IsSuccessful));
            return objData;
        }

        internal Data WinnersUpdateLockPivotDay(Data objData, string strEmail)
        {
            clsEscribirLog.EscribeDebug(this._strKeyLog, clsEscribirLog.enumTipoMensaje.Informativo, "KCM.ServiciosInternet.Site.Business.Logic.GanaKleenbebe.Admin.WinnersUpdateLockPivotDay", "Begin process");
            using (ContextDB.GanaKleenbebe objCtx = new ContextDB.GanaKleenbebe())
            {
                using (DbContextTransaction objTrans = objCtx.Database.BeginTransaction())
                {
                    try
                    {
                        Winners_GetRangeDates_Result objPivot = JsonConvert.DeserializeObject<Winners_GetRangeDates_Result>(objData.Body.ToString());
                        if (objPivot != null)
                        {
                            clsEscribirLog.EscribeDebug(this._strKeyLog, clsEscribirLog.enumTipoMensaje.Informativo, "KCM.ServiciosInternet.Site.Business.Logic.GanaKleenbebe.Admin.WinnersUpdateLockPivotDay", string.Format("Lock pivot day for '{0}'", objPivot.Id));
                            objData.strErrorMessage = objCtx.Winners_UpdateLockPivotDay(objPivot.Id, strEmail).AsEnumerable().First();
                            if (string.IsNullOrEmpty(objData.strErrorMessage))
                            {
                                objTrans.Commit();
                                objData.IsSuccessful = true;
                            }
                            else
                            {
                                objTrans.Rollback();
                                objData.IsSuccessful = false;
                            }
                        }
                        else
                        {
                            throw new Exception("No valid Winners_GetRangeDates_Result object into objData.Body");
                        }
                    }
                    catch (Exception ex)
                    {
                        objTrans.Rollback();
                        objData.IsSuccessful = false;
                        objData.strErrorMessage = "No se actualizar los tickets. Favor de contactar al administrador";
                        clsEscribirLog.EscribeLog(DateTime.Now.ToString(), clsEscribirLog.enumTipoMensaje.Informativo, "KCM.ServiciosInternet.Site.Business.Logic.GanaKleenbebe.GanaKleenbebe.Admin.WinnersUpdateLockPivotDay", "An exception ocurred");
                        clsEscribirLog.EscribeLog(DateTime.Now.ToString(), clsEscribirLog.enumTipoMensaje.Excepcion, "KCM.ServiciosInternet.Site.Business.Logic.GanaKleenbebe.GanaKleenbebe.Admin.WinnersUpdateLockPivotDay", ex, true);
                    }
                }
            }
            clsEscribirLog.EscribeDebug(this._strKeyLog, clsEscribirLog.enumTipoMensaje.Informativo, "KCM.ServiciosInternet.Site.Business.Logic.GanaKleenbebe.Admin.WinnersUpdateLockPivotDay", string.Format("End process - IsSuccesful:'{0}'", objData.IsSuccessful));
            return objData;
        }

        internal Data WinnersUpdateTickets(Data objData, string strEmail)
        {
            clsEscribirLog.EscribeDebug(this._strKeyLog, clsEscribirLog.enumTipoMensaje.Informativo, "KCM.ServiciosInternet.Site.Business.Logic.GanaKleenbebe.Admin.WinnersUpdateTickets", "Begin process");
            using (ContextDB.GanaKleenbebe objCtx = new ContextDB.GanaKleenbebe())
            {
                using (DbContextTransaction objTrans = objCtx.Database.BeginTransaction())
                {
                    try
                    {
                        Winners_GetRangeDates_Result objPivot = JsonConvert.DeserializeObject<Winners_GetRangeDates_Result>(objData.Body.ToString());
                        if (objPivot != null)
                        {
                            clsEscribirLog.EscribeDebug(this._strKeyLog, clsEscribirLog.enumTipoMensaje.Informativo, "KCM.ServiciosInternet.Site.Business.Logic.GanaKleenbebe.Admin.WinnersUpdateTickets", string.Format("Update tickets from pivot '{0}'", objPivot.Id));
                            int intNumberRows = objCtx.Winners_UpdateTickets(objPivot.Id, objData.strUID, strEmail);
                            objTrans.Commit();
                            objData.IsSuccessful = true;
                        }
                        else
                        {
                            throw new Exception("No valid Winners_GetRangeDates_Result object into objData.Body");
                        }
                    }
                    catch (Exception ex)
                    {
                        objTrans.Rollback();
                        objData.IsSuccessful = false;
                        objData.strErrorMessage = "No se actualizar los tickets. Favor de contactar al administrador";
                        clsEscribirLog.EscribeLog(DateTime.Now.ToString(), clsEscribirLog.enumTipoMensaje.Informativo, "KCM.ServiciosInternet.Site.Business.Logic.GanaKleenbebe.GanaKleenbebe.Admin.WinnersUpdateTickets", "An exception ocurred");
                        clsEscribirLog.EscribeLog(DateTime.Now.ToString(), clsEscribirLog.enumTipoMensaje.Excepcion, "KCM.ServiciosInternet.Site.Business.Logic.GanaKleenbebe.GanaKleenbebe.Admin.WinnersUpdateTickets", ex, true);
                    }
                }
            }
            clsEscribirLog.EscribeDebug(this._strKeyLog, clsEscribirLog.enumTipoMensaje.Informativo, "KCM.ServiciosInternet.Site.Business.Logic.GanaKleenbebe.Admin.WinnersUpdateTickets", string.Format("End process - IsSuccesful:'{0}'", objData.IsSuccessful));
            return objData;
        }

        internal Data WinnersGetGamesByTicket(Data objData)
        {
            clsEscribirLog.EscribeDebug(this._strKeyLog, clsEscribirLog.enumTipoMensaje.Informativo, "KCM.ServiciosInternet.Site.Business.Logic.GanaKleenbebe.Admin.WinnersGetGamesByTicket", string.Format("Begin process - ticket : '{0}'", objData.strUID));
            using (ContextDB.GanaKleenbebe objCtx = new ContextDB.GanaKleenbebe())
            {
                Winners_GetRangeDates_Result objPivot = JsonConvert.DeserializeObject<Winners_GetRangeDates_Result>(objData.Body.ToString());
                if (objPivot != null)
                {
                    // the ticketID is in objData.strUID 
                    objData.Body = objCtx.Winners_GetGamesByTicket(objData.strUID, objPivot.Id).AsEnumerable().ToList();
                }
                else
                {
                    throw new Exception("No valid Winners_GetRangeDates_Result object into objData.Body");
                }
            }
            clsEscribirLog.EscribeDebug(this._strKeyLog, clsEscribirLog.enumTipoMensaje.Informativo, "KCM.ServiciosInternet.Site.Business.Logic.GanaKleenbebe.Admin.WinnersGetGamesByTicket", string.Format("End process - Numbers of games:'{0}'", (objData.Body as List<Winners_GetGamesByTicket_Result>).Count));
            return objData;
        }

        internal Data WinnersGetAllTicketsInExcel(Data objData)
        {
            clsEscribirLog.EscribeDebug(this._strKeyLog, clsEscribirLog.enumTipoMensaje.Informativo, "KCM.ServiciosInternet.Site.Business.Logic.GanaKleenbebe.Admin.WinnersGetAllTicketsInExcel", "Begin process");
            using (ContextDB.GanaKleenbebe objCtx = new ContextDB.GanaKleenbebe())
            {
                Winners_GetRangeDates_Result objPivot = JsonConvert.DeserializeObject<Winners_GetRangeDates_Result>(objData.Body.ToString());
                if (objPivot != null)
                {
                    List<Winners_GetTickets_Result> objLstTickets = objCtx.Winners_GetAllTickets(objPivot.Id).AsEnumerable().ToList();
                    if (objLstTickets.Count > 0)
                    {
                        Stream objStrm = new MemoryStream();

                        using (ExcelPackage objEP = new ExcelPackage(objStrm))
                        {
                            Excel.GetExcelFromIEnumerable(objLstTickets, objEP, "Tickets");
                            objEP.Save();
                        }
                        objData.IsSuccessful = true;
                        objData.Body = objStrm;
                    }
                    else
                    {
                        objData.IsSuccessful = false;
                        objData.strErrorMessage = "No hay datos que mostrar, favor de contactar al administrador";
                    }
                }
                else
                {
                    throw new Exception("No valid Winners_GetRangeDates_Result object into objData.Body");
                }
            }
            clsEscribirLog.EscribeDebug(this._strKeyLog, clsEscribirLog.enumTipoMensaje.Informativo, "KCM.ServiciosInternet.Site.Business.Logic.GanaKleenbebe.Admin.WinnersGetAllTicketsInExcel", string.Format("End process - IsSuccesful:'{0}'", objData.IsSuccessful));
            return objData;
        }

        internal Data WinnersGetUserRecords(Data objData)
        {
            clsEscribirLog.EscribeDebug(this._strKeyLog, clsEscribirLog.enumTipoMensaje.Informativo, "KCM.ServiciosInternet.Site.Business.Logic.GanaKleenbebe.Admin.WinnersGetUserRecords", "Begin process");
            using (ContextDB.GanaKleenbebe objCtx = new ContextDB.GanaKleenbebe())
            {
                string strReportPath = GlobalConfig.Global.strDataPath + @"\Tickets\" + objData.strUID;
                string strRptXlsx = strReportPath + @"\UserRecord.xlsx";
                string strZipfile = strReportPath + @"\UserRecord.zip";

                List<Winners_GetUserRecords_Result> objLstTickets = objCtx.Winners_GetUserRecords(objData.strUID).ToList();
                if (objLstTickets.Count > 0)
                {
                    using (StreamWriter objWR = new StreamWriter(strRptXlsx))
                    {
                        string strMimeType, strEncoding, strExtension;
                        string[] arrStrStreamids;
                        Warning[] arrObjWarnings;

                        LocalReport objReporte = new LocalReport();
                        objReporte.ReportPath = GlobalConfig.Global.strDataPath + @"\Reports\UserRecords\UserRecords.rdlc";

                        ReportDataSource objRdsReporte = new ReportDataSource("UserRecords", objLstTickets);
                        objReporte.DataSources.Add(objRdsReporte);

                        byte[] bytes = objReporte.Render("EXCELOPENXML", null, out strMimeType, out strEncoding, out strExtension, out arrStrStreamids, out arrObjWarnings);

                        objWR.BaseStream.Write(bytes, 0, bytes.Length);
                    }


                    if (File.Exists(strZipfile))
                    {
                        File.Delete(strZipfile);
                    }

                    string[] lstFiles = Directory.GetFiles(strReportPath);
                    //using (ZipArchive archive = ZipFile.Open(strZipfile, ZipArchiveMode.Create))
                    //{
                    //    foreach (string strFile in lstFiles)
                    //    {
                    //        archive.CreateEntryFromFile(strFile, Path.GetFileName(strFile));
                    //    }

                    //}

                    using (ZipOutputStream OutputStream = new ZipOutputStream(File.Create(strZipfile)))
                    {

                        // Define the compression level
                        // 0 - store only to 9 - means best compression
                        OutputStream.SetLevel(0);

                        byte[] buffer = new byte[4096];

                        foreach (string strFile in lstFiles)
                        {

                            // Using GetFileName makes the result compatible with XP
                            // as the resulting path is not absolute.
                            ZipEntry entry = new ZipEntry(Path.GetFileName(strFile));

                            // Setup the entry data as required.
                            entry.CompressionMethod = CompressionMethod.Stored;

                            // Crc and size are handled by the library for seakable streams
                            // so no need to do them here.

                            // Could also use the last write time or similar for the file.
                            entry.DateTime = DateTime.Now;
                            OutputStream.PutNextEntry(entry);

                            using (FileStream fs = File.OpenRead(strFile))
                            {

                                // Using a fixed size buffer here makes no noticeable difference for output
                                // but keeps a lid on memory usage.
                                int sourceBytes;

                                do
                                {
                                    sourceBytes = fs.Read(buffer, 0, buffer.Length);
                                    OutputStream.Write(buffer, 0, sourceBytes);
                                } while (sourceBytes > 0);
                            }
                        }

                        // Finish/Close arent needed strictly as the using statement does this automatically

                        // Finish is important to ensure trailing information for a Zip file is appended.  Without this
                        // the created file would be invalid.
                        OutputStream.Finish();

                        // Close is important to wrap things up and unlock the file.
                        OutputStream.Close();
                    }

                    Stream objStr = new FileStream(strZipfile, FileMode.OpenOrCreate);

                    objData.IsSuccessful = true;
                    objData.Body = objStr;
                }
                else
                {
                    objData.IsSuccessful = false;
                    objData.strErrorMessage = "No hay datos que mostrar, favor de contactar al administrador";
                }
            }
            clsEscribirLog.EscribeDebug(this._strKeyLog, clsEscribirLog.enumTipoMensaje.Informativo, "KCM.ServiciosInternet.Site.Business.Logic.GanaKleenbebe.Admin.WinnersGetUserRecords", string.Format("End process - IsSuccesful:'{0}'", objData.IsSuccessful));
            return objData;
        }
        #endregion

        #region PIVOT
        internal Data PivotGetPivotDays(Data objData)
        {
            clsEscribirLog.EscribeDebug(this._strKeyLog, clsEscribirLog.enumTipoMensaje.Informativo, "KCM.ServiciosInternet.Site.Business.Logic.GanaKleenbebe.Admin.PivotGetPivotDays", "Begin process '");
            using (ContextDB.GanaKleenbebe objCtx = new ContextDB.GanaKleenbebe())
            {
                objData.Body = objCtx.Pivot_GetPivotDays().ToList();
            }
            clsEscribirLog.EscribeDebug(this._strKeyLog, clsEscribirLog.enumTipoMensaje.Informativo, "KCM.ServiciosInternet.Site.Business.Logic.GanaKleenbebe.Admin.PivotGetPivotDays", "End process - Numbers of rows:" + ((List<Pivot_GetPivotDays_Result>)objData.Body).Count);
            return objData;
        }

        internal Data PivotUpdatePivotDay(Pivot_GetPivotDays_Result objPivot)
        {
            clsEscribirLog.EscribeDebug(this._strKeyLog, clsEscribirLog.enumTipoMensaje.Informativo, "KCM.ServiciosInternet.Site.Business.Logic.GanaKleenbebe.Admin.PivotUpdatePivotDay", "Begin process");
            Data objData = new Data();
            using (ContextDB.GanaKleenbebe objCtx = new ContextDB.GanaKleenbebe())
            {
                using (DbContextTransaction objTrans = objCtx.Database.BeginTransaction())
                {
                    try
                    {
                        string strMsg = string.Empty;
                        string strPivotDate = string.IsNullOrEmpty(objPivot.PivotDate) ? null : objPivot.PivotDate;
                        //Pivot_GetPivotDays_Result objPivot = JsonConvert.DeserializeObject<Pivot_GetPivotDays_Result>(objData.Body.ToString());
                        if (objPivot != null)
                        {
                            clsEscribirLog.EscribeDebug(this._strKeyLog, clsEscribirLog.enumTipoMensaje.Informativo, "KCM.ServiciosInternet.Site.Business.Logic.GanaKleenbebe.Admin.PivotUpdatePivotDay", string.Format("Update info from pivot '{0}'", objPivot.Id));
                            strMsg = objCtx.Pivot_UpdatePivotDay(
                                id: objPivot.Id,
                                idGameinfo: objPivot.IdGameinfo,
                                pivotDate: objPivot.PivotDate,
                                days: objPivot.Days,
                                idParam: objPivot.IdParam,
                                isProcessed: objPivot.IsProcessed ?? false
                                ).First();
                            objData.Body = strMsg;
                            objTrans.Commit();
                            objData.IsSuccessful = true;
                        }
                        else
                        {
                            throw new Exception("No valid Pivot_GetPivotDays_Result object into objData.Body");
                        }
                    }
                    catch (Exception ex)
                    {
                        objTrans.Rollback();
                        objData.IsSuccessful = false;
                        objData.strErrorMessage = "No se actualiza el registro de corte. Favor de contactar al administrador";
                        clsEscribirLog.EscribeLog(DateTime.Now.ToString(), clsEscribirLog.enumTipoMensaje.Informativo, "KCM.ServiciosInternet.Site.Business.Logic.GanaKleenbebe.GanaKleenbebe.Admin.PivotUpdatePivotDay", "An exception ocurred");
                        clsEscribirLog.EscribeLog(DateTime.Now.ToString(), clsEscribirLog.enumTipoMensaje.Excepcion, "KCM.ServiciosInternet.Site.Business.Logic.GanaKleenbebe.GanaKleenbebe.Admin.PivotUpdatePivotDay", ex, true);
                    }
                }
            }
            clsEscribirLog.EscribeDebug(this._strKeyLog, clsEscribirLog.enumTipoMensaje.Informativo, "KCM.ServiciosInternet.Site.Business.Logic.GanaKleenbebe.Admin.PivotUpdatePivotDay", string.Format("End process - IsSuccesful:'{0}'", objData.IsSuccessful));
            return objData;
        }


        internal Data PivotDeletePivotDay(Data objData)
        {
            clsEscribirLog.EscribeDebug(this._strKeyLog, clsEscribirLog.enumTipoMensaje.Informativo, "KCM.ServiciosInternet.Site.Business.Logic.GanaKleenbebe.Admin.PivotDeletePivotDay", "Begin process");
            using (ContextDB.GanaKleenbebe objCtx = new ContextDB.GanaKleenbebe())
            {
                using (DbContextTransaction objTrans = objCtx.Database.BeginTransaction())
                {
                    try
                    {
                        string strMsg = string.Empty;
                        Pivot_GetPivotDays_Result objPivot = JsonConvert.DeserializeObject<Pivot_GetPivotDays_Result>(objData.Body.ToString());
                        if (objPivot != null)
                        {
                            clsEscribirLog.EscribeDebug(this._strKeyLog, clsEscribirLog.enumTipoMensaje.Informativo, "KCM.ServiciosInternet.Site.Business.Logic.GanaKleenbebe.Admin.PivotDeletePivotDay", string.Format("Delete from pivot '{0}'", objPivot.Id));
                            strMsg = objCtx.Pivot_DeletePivotDay(objPivot.Id).First();
                            objData.Body = strMsg;
                            objTrans.Commit();
                            if (string.IsNullOrEmpty(strMsg))
                            {
                                objData.IsSuccessful = true;
                            }
                            else
                            {
                                objData.IsSuccessful = false;
                            }
                        }
                        else
                        {
                            throw new Exception("No valid Pivot_GetPivotDays_Result object into objData.Body");
                        }
                    }
                    catch (Exception ex)
                    {
                        objTrans.Rollback();
                        objData.IsSuccessful = false;
                        objData.strErrorMessage = "No se borra el registro de corte. Favor de contactar al administrador";
                        clsEscribirLog.EscribeLog(DateTime.Now.ToString(), clsEscribirLog.enumTipoMensaje.Informativo, "KCM.ServiciosInternet.Site.Business.Logic.GanaKleenbebe.GanaKleenbebe.Admin.PivotDeletePivotDay", "An exception ocurred");
                        clsEscribirLog.EscribeLog(DateTime.Now.ToString(), clsEscribirLog.enumTipoMensaje.Excepcion, "KCM.ServiciosInternet.Site.Business.Logic.GanaKleenbebe.GanaKleenbebe.Admin.PivotDeletePivotDay", ex, true);
                    }
                }
            }
            clsEscribirLog.EscribeDebug(this._strKeyLog, clsEscribirLog.enumTipoMensaje.Informativo, "KCM.ServiciosInternet.Site.Business.Logic.GanaKleenbebe.Admin.PivotDeletePivotDay", string.Format("End process - IsSuccesful:'{0}'", objData.IsSuccessful));
            return objData;
        }


        internal Data PivotGetGameInfo(Data objData)
        {
            clsEscribirLog.EscribeDebug(this._strKeyLog, clsEscribirLog.enumTipoMensaje.Informativo, "KCM.ServiciosInternet.Site.Business.Logic.GanaKleenbebe.Admin.PivotGetGameInfo", "Begin process '");
            using (ContextDB.GanaKleenbebe objCtx = new ContextDB.GanaKleenbebe())
            {
                objData.Body = objCtx.Pivot_GetGameInfo().ToList();
            }
            clsEscribirLog.EscribeDebug(this._strKeyLog, clsEscribirLog.enumTipoMensaje.Informativo, "KCM.ServiciosInternet.Site.Business.Logic.GanaKleenbebe.Admin.PivotGetGameInfo", "End process - Numbers of rows:" + ((List<Pivot_ComboBox_Result>)objData.Body).Count);
            return objData;
        }

        internal Data PivotGetParams(Data objData)
        {
            clsEscribirLog.EscribeDebug(this._strKeyLog, clsEscribirLog.enumTipoMensaje.Informativo, "KCM.ServiciosInternet.Site.Business.Logic.GanaKleenbebe.Admin.PivotGetParams", "Begin process '");
            using (ContextDB.GanaKleenbebe objCtx = new ContextDB.GanaKleenbebe())
            {
                objData.Body = objCtx.Pivot_GetParams().ToList();
            }
            clsEscribirLog.EscribeDebug(this._strKeyLog, clsEscribirLog.enumTipoMensaje.Informativo, "KCM.ServiciosInternet.Site.Business.Logic.GanaKleenbebe.Admin.PivotGetParams", "End process - Numbers of rows:" + ((List<Pivot_ComboBox_Result>)objData.Body).Count);
            return objData;
        }

        #endregion
        #region IDisposable Support
        private bool disposedValue = false; // To detect redundant calls

        protected virtual void Dispose(bool disposing)
        {
            if (!disposedValue)
            {
                if (disposing)
                {
                    // TODO: dispose managed state (managed objects).
                }

                // TODO: free unmanaged resources (unmanaged objects) and override a finalizer below.
                // TODO: set large fields to null.

                disposedValue = true;
            }
        }

        // TODO: override a finalizer only if Dispose(bool disposing) above has code to free unmanaged resources.
        // ~GanaKleenbebe() {
        //   // Do not change this code. Put cleanup code in Dispose(bool disposing) above.
        //   Dispose(false);
        // }

        // This code added to correctly implement the disposable pattern.
        public void Dispose()
        {
            // Do not change this code. Put cleanup code in Dispose(bool disposing) above.
            Dispose(true);
            // TODO: uncomment the following line if the finalizer is overridden above.
            // GC.SuppressFinalize(this);
        }


        #endregion
    }
}
