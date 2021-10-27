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

namespace KCM.ServiciosInternet.Site.Business.Logic.GanaKleenbebe
{
    public class GanaKleenbebe : IDisposable
    {
        private string _strKeyLog = DateTime.Now.ToString();
        public GanaKleenbebe()
        {

        }

        #region PRIVATE METHODS
        private bool IsValidUser(string strUID)
        {
            clsEscribirLog.EscribeDebug(this._strKeyLog, clsEscribirLog.enumTipoMensaje.Informativo, "KCM.ServiciosInternet.Site.Business.Logic.GanaKleenbebe.GanaKleenbebe.IsValidUser", string.Format("Begin process - UID:'{0}'", strUID));
            SSOData.Data objSSOData = getSessionInfo(strUID);

            clsEscribirLog.EscribeDebug(this._strKeyLog, clsEscribirLog.enumTipoMensaje.Informativo, "KCM.ServiciosInternet.Site.Business.Logic.GanaKleenbebe.GanaKleenbebe.IsValidUser", string.Format("Begin process - UID:'{0}' - IsSuccessful:'{1}'", strUID, objSSOData.isSuccessful));
            if (objSSOData.isSuccessful)
            {
                return true;
            }
            return false;
        }

        private SSOData.Data getSessionInfo(string strUID)
        {
            /*--------------------------------------------
             * Replace values for Google params
             *--------------------------------------------*/
            clsEscribirLog.EscribeDebug(this._strKeyLog, clsEscribirLog.enumTipoMensaje.Informativo, "KCM.ServiciosInternet.Site.Business.Logic.GanaKleenbebe.GanaKleenbebe.getSessionInfo", string.Format("Begin process - UID:'{0}'", strUID));

            SSOData.Data objSSOData = new SSOData.Data();
            objSSOData.strUID = strUID;
            objSSOData.strSiteKey = Global.strSSOapiKey;
            objSSOData.strExtraProfileFieldsDescriptor = Global.strSSOExtraProfileFieldsDescriptor;

            string strWebAddress = string.Format("{0}{1}?apiKey={2}&version=1.0", Global.strUrlSSOService, Global.strSSOgetSession, Global.strSSOapiKey);

            clsEscribirLog.EscribeDebug(this._strKeyLog, clsEscribirLog.enumTipoMensaje.Informativo, "KCM.ServiciosInternet.Site.Business.Logic.GanaKleenbebe.GanaKleenbebe.getSessionInfo", string.Format("Service:'{0}'", strWebAddress));
            WebRequest objHttpWebRequest = WebRequest.Create(strWebAddress);

            string objSerialized = JsonConvert.SerializeObject(objSSOData);

            clsEscribirLog.EscribeDebug(this._strKeyLog, clsEscribirLog.enumTipoMensaje.Informativo, "KCM.ServiciosInternet.Site.Business.Logic.GanaKleenbebe.GanaKleenbebe.getSessionInfo", string.Format("objSerialized:'{0}'", objSerialized));

            byte[] BtPostData = Encoding.ASCII.GetBytes(objSerialized);

            objHttpWebRequest.Method = "POST";
            objHttpWebRequest.ContentType = "application/json";
            objHttpWebRequest.ContentLength = BtPostData.Length;

            using (var stream = objHttpWebRequest.GetRequestStream())
            {
                stream.Write(BtPostData, 0, BtPostData.Length);
            }

            HttpWebResponse objHttpResponse = (HttpWebResponse)objHttpWebRequest.GetResponse();

            using (StreamReader objSrdr = new StreamReader(objHttpResponse.GetResponseStream()))
            {
                JavaScriptSerializer objJSONSerializer = new JavaScriptSerializer();
                Dictionary<string, object> objResp = (Dictionary<string, object>)objJSONSerializer.DeserializeObject(objSrdr.ReadToEnd());

                objSSOData.getDataFromDictionary(objResp);

                clsEscribirLog.EscribeDebug(this._strKeyLog, clsEscribirLog.enumTipoMensaje.Informativo, "KCM.ServiciosInternet.Site.Business.Logic.GanaKleenbebe.GanaKleenbebe.getSessionInfo", string.Format("End process - UID:'{0}'", strUID));
                return objSSOData;
            }
        }

        private string CompressImage(Stream StrmInputImage, int intQuality, string strOutPutDirectory, ImageFormat eFormat)
        {
            clsEscribirLog.EscribeDebug(this._strKeyLog, clsEscribirLog.enumTipoMensaje.Informativo, "KCM.ServiciosInternet.Site.Business.Logic.GanaKleenbebe.GanaKleenbebe.CompressImage", string.Format("Begin process - file to save:'{0}'", strOutPutDirectory));
            using (Bitmap objBitmab = new Bitmap(StrmInputImage))
            {
                ImageCodecInfo objImageCodecInfo = this.GetEncoder(eFormat);

                System.Drawing.Imaging.Encoder objEncoder = System.Drawing.Imaging.Encoder.Quality;

                EncoderParameters objEncoderParameters = new EncoderParameters(1);
                EncoderParameter objEncoderParameter = new EncoderParameter(objEncoder, intQuality);
                objEncoderParameters.Param[0] = objEncoderParameter;

                objBitmab.Save(strOutPutDirectory, objImageCodecInfo, objEncoderParameters);

            }
            clsEscribirLog.EscribeDebug(this._strKeyLog, clsEscribirLog.enumTipoMensaje.Informativo, "KCM.ServiciosInternet.Site.Business.Logic.GanaKleenbebe.GanaKleenbebe.CompressImage", string.Format("End process - saved file:'{0}'", strOutPutDirectory));
            return strOutPutDirectory;
        }



        private ImageCodecInfo GetEncoder(ImageFormat eFormat)
        {
            ImageCodecInfo[] objCollectionImageCodecInfo = ImageCodecInfo.GetImageDecoders();
            foreach (ImageCodecInfo objImageCodecInfo in objCollectionImageCodecInfo)
            {
                if (objImageCodecInfo.FormatID == eFormat.Guid)
                {
                    return objImageCodecInfo;
                }
            }
            return null;
        }

        private Data addTicket(TicketModel objTicket)
        {
            Data objData = new Data();
            clsEscribirLog.EscribeDebug(this._strKeyLog, clsEscribirLog.enumTipoMensaje.Informativo, "KCM.ServiciosInternet.Site.Business.Logic.GanaKleenbebe.GanaKleenbebe.addTicket", string.Format("Begin process - ticket:'{0}'", objTicket.productTicket));
            using (ContextDB.GanaKleenbebe objCtx = new ContextDB.GanaKleenbebe())
            {
                using (DbContextTransaction objTrans = objCtx.Database.BeginTransaction())
                {
                    try
                    {
                        string strExt = Path.GetExtension(objTicket.ImageFile.FileName);
                        string strDirectory = Path.Combine(Global.strDataPath, "Tickets", objTicket.UID);
                        string strImagePath = Path.Combine(strDirectory, objTicket.productTicket + strExt);

                        if (!Directory.Exists(strDirectory))
                        {
                            Directory.CreateDirectory(strDirectory);
                        }

                        objData.strErrorMessage = objCtx.InsertTicket(
                            productPrice: objTicket.productPrice,
                            productClave: objTicket.productClave,
                            productTicket: objTicket.productTicket,
                            uID: objTicket.UID,
                            firstName: objTicket.FirstName,
                            lastName: objTicket.LastName,
                            email: objTicket.Email,
                            birthYear: objTicket.BirthYear,
                            birthMonth: objTicket.BirthMonth,
                            birthDay: objTicket.BirthDay,
                            cellPhone: objTicket.CellPhone,
                            path: strImagePath,
                            todayDt: DateTime.Now
                            ).First();

                        if (string.IsNullOrEmpty(objData.strErrorMessage))
                        {
                            ImageFormat eFormat = strExt.ToLower().Equals(".png") ? ImageFormat.Png : ImageFormat.Jpeg;
                            // cargar imagen
                            this.CompressImage(StrmInputImage: objTicket.ImageFile.InputStream, intQuality: 60, strOutPutDirectory: strImagePath, eFormat: eFormat);
                            objTrans.Commit();
                            objData.IsSuccessful = true;
                        }
                        else
                        {
                            objData.IsSuccessful = false;
                            objTrans.Rollback();
                        }
                    }
                    catch (Exception ex)
                    {
                        objTrans.Rollback();
                        clsEscribirLog.EscribeLog(DateTime.Now.ToString(), clsEscribirLog.enumTipoMensaje.Informativo, "KCM.ServiciosInternet.Site.Business.Logic.GanaKleenbebe.GanaKleenbebe.GanaKleenbebe.addTicket", "An exception ocurred");
                        clsEscribirLog.EscribeLog(DateTime.Now.ToString(), clsEscribirLog.enumTipoMensaje.Excepcion, "KCM.ServiciosInternet.Site.Business.Logic.GanaKleenbebe.GanaKleenbebe.GanaKleenbebe.addTicket", ex, true);
                        objData.IsSuccessful = false;
                        objData.strErrorMessage = "No se pudo cargar el ticket, favor de contactar al administrador";
                    }
                }
            }
            clsEscribirLog.EscribeDebug(this._strKeyLog, clsEscribirLog.enumTipoMensaje.Informativo, "KCM.ServiciosInternet.Site.Business.Logic.GanaKleenbebe.GanaKleenbebe.addTicket", string.Format("End process - ticket:'{0}' IsSuccessful", objTicket.productTicket, objData.IsSuccessful));
            return objData;
        }

        #endregion

        #region TICKET
        internal Data ProcessTicket(TicketModel objTicket)
        {
            Data objData = new Data();
            objData.strModel = objTicket.GetType().ToString();

            clsEscribirLog.EscribeDebug(this._strKeyLog, clsEscribirLog.enumTipoMensaje.Informativo, "KCM.ServiciosInternet.Site.Business.Logic.GanaKleenbebe.GanaKleenbebe.ProcessTicket", string.Format("Begin process - ticket:'{0}'", objTicket.productTicket));

            if (BussinessGoogle.isExpiredReCaptcha(strCatchapSecretKey: Global.strRecaptchaSecretKey, strCaptchaToken: objTicket.recaptchaResponse, strProviderUrlValidator: Global.strRecaptchaUrlValidator))
            {
                objData.IsSuccessful = false;
                objData.strErrorMessage = "Recaptcha Inválido";
                objData.Body = string.Empty;
            }
            else
            {
                objData = addTicket(objTicket);
            }
            clsEscribirLog.EscribeDebug(this._strKeyLog, clsEscribirLog.enumTipoMensaje.Informativo, "KCM.ServiciosInternet.Site.Business.Logic.GanaKleenbebe.GanaKleenbebe.ProcessTicket", string.Format("End process - ticket:'{0}' - IsSuccessful", objTicket.productTicket, objData.IsSuccessful));
            return objData;
        }

        internal Data GetAttemps(Data objData)
        {
            clsEscribirLog.EscribeDebug(this._strKeyLog, clsEscribirLog.enumTipoMensaje.Informativo, "KCM.ServiciosInternet.Site.Business.Logic.GanaKleenbebe.GanaKleenbebe.GetAttemps", String.Format("Begin process  UID: {0}", objData.strUID));
            using (ContextDB.GanaKleenbebe objCtx = new ContextDB.GanaKleenbebe())
            {
                objData.Body = objCtx.GetAttemps(objData.strUID).FirstOrDefault();
            }
            clsEscribirLog.EscribeDebug(this._strKeyLog, clsEscribirLog.enumTipoMensaje.Informativo, "KCM.ServiciosInternet.Site.Business.Logic.GanaKleenbebe.GanaKleenbebe.GetAttemps", string.Format("End process - Attemps:'{0}'", objData.Body.ToString()));
            return objData;
        }

        #endregion

        #region GAME
        internal string GetGamePathInfo()
        {
            clsEscribirLog.EscribeDebug(this._strKeyLog, clsEscribirLog.enumTipoMensaje.Informativo, "KCM.ServiciosInternet.Site.Business.Logic.GanaKleenbebe.GanaKleenbebe.GetGamePathInfo", "Begin process");
            string strPath = string.Empty;
            DateTime dtToday = DateTime.Now;
            using (ContextDB.GanaKleenbebe objCtx = new ContextDB.GanaKleenbebe())
            {
                strPath = objCtx.GetGameInfo(dtToday).FirstOrDefault();
            }
            clsEscribirLog.EscribeDebug(this._strKeyLog, clsEscribirLog.enumTipoMensaje.Informativo, "KCM.ServiciosInternet.Site.Business.Logic.GanaKleenbebe.GanaKleenbebe.GetGamePathInfo", string.Format("End process - Path Game:'{0}'", strPath));
            return strPath;
        }
        internal Data GetGame(Data objData)
        {
            clsEscribirLog.EscribeDebug(this._strKeyLog, clsEscribirLog.enumTipoMensaje.Informativo, "KCM.ServiciosInternet.Site.Business.Logic.GanaKleenbebe.GanaKleenbebe.GetGame", string.Format("Begin process - UID:'{0}'", objData.strUID));
            using (ContextDB.GanaKleenbebe objCtx = new ContextDB.GanaKleenbebe())
            {
                using (DbContextTransaction objTrans = objCtx.Database.BeginTransaction())
                {
                    try
                    {
                        UpdateSetGame_Result objGameToPlay = objCtx.UpdateSetGame(objData.strUID, DateTime.Now).AsEnumerable().First();
                        List<string> collectionWords = objCtx.GetParamsFromGame(objGameToPlay.IdGameInfo).AsEnumerable().ToList();
                        if (collectionWords.Count > 0)
                        {
                            objTrans.Commit();
                            objData.IsSuccessful = true;
                            objData.Body = new KCM.ServiciosInternet.Site.Entity.www.gana.kleenbebe.com_1.Data.Game
                            {
                                Id_PivotDay = objGameToPlay.PivotDayId.Value,
                                Id_Game = objGameToPlay.GameId.Value,
                                Id_GameInfo = objGameToPlay.IdGameInfo,
                                collection = collectionWords,
                                Time = null
                            };
                        }
                        else
                        {
                            objData.IsSuccessful = false;
                            objData.strErrorMessage = "No se pudo cargar las parametros del juego, favor de contactar al administrador";
                            objTrans.Rollback();
                        }
                    }
                    catch (Exception ex)
                    {
                        objTrans.Rollback();
                        objData.IsSuccessful = false;
                        objData.strErrorMessage = "No se pudo cargar el juego, favor de contactar al administrador";
                        clsEscribirLog.EscribeLog(DateTime.Now.ToString(), clsEscribirLog.enumTipoMensaje.Informativo, "KCM.ServiciosInternet.Site.Business.Logic.GanaKleenbebe.GanaKleenbebe.GanaKleenbebe.GetGame", "An exception ocurred");
                        clsEscribirLog.EscribeLog(DateTime.Now.ToString(), clsEscribirLog.enumTipoMensaje.Excepcion, "KCM.ServiciosInternet.Site.Business.Logic.GanaKleenbebe.GanaKleenbebe.GanaKleenbebe.GetGame", ex, true);
                    }
                }
            }
            clsEscribirLog.EscribeDebug(this._strKeyLog, clsEscribirLog.enumTipoMensaje.Informativo, "KCM.ServiciosInternet.Site.Business.Logic.GanaKleenbebe.GanaKleenbebe.GetGame", string.Format("End process - Successful:'{0}'", objData.IsSuccessful));
            return objData;
        }


        internal Data SaveGame(Data objData)
        {
            clsEscribirLog.EscribeDebug(this._strKeyLog, clsEscribirLog.enumTipoMensaje.Informativo, "KCM.ServiciosInternet.Site.Business.Logic.GanaKleenbebe.GanaKleenbebe.SaveGame", string.Format("Begin process - UID:'{0}'", objData.strUID));
            using (ContextDB.GanaKleenbebe objCtx = new ContextDB.GanaKleenbebe())
            {
                using (DbContextTransaction objTrans = objCtx.Database.BeginTransaction())
                {
                    try
                    {
                        KCM.ServiciosInternet.Site.Entity.www.gana.kleenbebe.com_1.Data.Game objGame = JsonConvert.DeserializeObject<KCM.ServiciosInternet.Site.Entity.www.gana.kleenbebe.com_1.Data.Game>(objData.Body.ToString());
                        clsEscribirLog.EscribeDebug(this._strKeyLog, clsEscribirLog.enumTipoMensaje.Informativo, "KCM.ServiciosInternet.Site.Business.Logic.GanaKleenbebe.GanaKleenbebe.SaveGame", string.Format("GameToSave - idPivotDay:'{0}' idGame:'{1}'  time:'{2}'", objGame.Id_PivotDay, objGame.Id_Game, objGame.Time));
                        objCtx.UpdateSaveGame(objGame.Id_PivotDay,objGame.Id_Game, DateTime.Now, "00:" + objGame.Time);
                        objTrans.Commit();
                        objData.IsSuccessful = true;
                    }
                    catch (Exception ex)
                    {
                        objTrans.Rollback();
                        clsEscribirLog.EscribeLog(DateTime.Now.ToString(), clsEscribirLog.enumTipoMensaje.Informativo, "KCM.ServiciosInternet.Site.Business.Logic.GanaKleenbebe.GanaKleenbebe.GanaKleenbebe.SaveGame", "An exception ocurred");
                        clsEscribirLog.EscribeLog(DateTime.Now.ToString(), clsEscribirLog.enumTipoMensaje.Excepcion, "KCM.ServiciosInternet.Site.Business.Logic.GanaKleenbebe.GanaKleenbebe.GanaKleenbebe.SaveGame", ex, true);
                        objData.IsSuccessful = false;
                        objData.strErrorMessage = "No se pudo guardar el juego, favor de contactar al administrador";
                    }
                }
            }
            clsEscribirLog.EscribeDebug(this._strKeyLog, clsEscribirLog.enumTipoMensaje.Informativo, "KCM.ServiciosInternet.Site.Business.Logic.GanaKleenbebe.GanaKleenbebe.SaveGame", string.Format("End process - IsSuccesful:'{0}'", objData.IsSuccessful));
            return objData;
        }

        internal Data GetTemplate(Data objData)
        {
            clsEscribirLog.EscribeDebug(this._strKeyLog, clsEscribirLog.enumTipoMensaje.Informativo, "KCM.ServiciosInternet.Site.Business.Logic.GanaKleenbebe.GanaKleenbebe.GetTemplate", string.Format("Begin process - template:'{0}'", objData.Body));
            string strFile = string.Concat(Global.strDataPath, objData.Body.ToString());
            using (StreamReader objRdr = new StreamReader(strFile))
            {
                objData.Body = objRdr.ReadToEnd();
                objData.IsSuccessful = true;
            }
            clsEscribirLog.EscribeDebug(this._strKeyLog, clsEscribirLog.enumTipoMensaje.Informativo, "KCM.ServiciosInternet.Site.Business.Logic.GanaKleenbebe.GanaKleenbebe.GetTemplate", string.Format("End process - IsSuccesful:'{0}'", objData.IsSuccessful));
            return objData;
        }

        internal Data GetScore(Data objData)
        {
            clsEscribirLog.EscribeDebug(this._strKeyLog, clsEscribirLog.enumTipoMensaje.Informativo, "KCM.ServiciosInternet.Site.Business.Logic.GanaKleenbebe.GanaKleenbebe.GetScore", string.Format("Begin process  UID:'{0}'", objData.strUID));
            using (ContextDB.GanaKleenbebe objCtx = new ContextDB.GanaKleenbebe())
            {
                objData.Body = objCtx.GetScore(objData.strUID, DateTime.Now).AsEnumerable().Select(objS=>
                {
                    return new
                    {
                        objS.Description,
                        GameDate = objS.GameDate.Value.ToString("yyyy/MM/dd"),
                        Time = objS.Time.Value.ToString("mm\\:ss\\.ffff")
                    };
                }).ToList();
                objData.IsSuccessful = true;
            }
            clsEscribirLog.EscribeDebug(this._strKeyLog, clsEscribirLog.enumTipoMensaje.Informativo, "KCM.ServiciosInternet.Site.Business.Logic.GanaKleenbebe.GetScore", "End process");
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
