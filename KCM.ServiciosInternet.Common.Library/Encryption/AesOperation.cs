using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Security.Cryptography;
using System.IO;

namespace KCM.ServiciosInternet.Common.Library.Encryption
{
    public class AesOperation
    {
        public static string EncryptString(string strKey, string strPlainText)
        {
            byte[] btInitVector = new byte[16];
            byte[] btArray;

            using (Aes objAes = Aes.Create())
            {
                objAes.Key = Encoding.UTF8.GetBytes(strKey);
                objAes.IV = btInitVector;

                ICryptoTransform encryptor = objAes.CreateEncryptor(objAes.Key, objAes.IV);

                using (MemoryStream memoryStream = new MemoryStream())
                {
                    using (CryptoStream cryptoStream = new CryptoStream((Stream)memoryStream, encryptor, CryptoStreamMode.Write))
                    {
                        using (StreamWriter streamWriter = new StreamWriter((Stream)cryptoStream))
                        {
                            streamWriter.Write(strPlainText);
                        }

                        btArray = memoryStream.ToArray();
                    }
                }
            }

            return Convert.ToBase64String(btArray);
        }

        public static string DecryptString(string strKey, string strEncryptedString)
        {
            byte[] btInitVector = new byte[16];
            byte[] btBuffer = Convert.FromBase64String(strEncryptedString);

            using (Aes aes = Aes.Create())
            {
                aes.Key = Encoding.UTF8.GetBytes(strKey);
                aes.IV = btInitVector;
                ICryptoTransform decryptor = aes.CreateDecryptor(aes.Key, aes.IV);

                using (MemoryStream memoryStream = new MemoryStream(btBuffer))
                {
                    using (CryptoStream cryptoStream = new CryptoStream((Stream)memoryStream, decryptor, CryptoStreamMode.Read))
                    {
                        using (StreamReader streamReader = new StreamReader((Stream)cryptoStream))
                        {
                            return streamReader.ReadToEnd();
                        }
                    }
                }
            }
        }
    }
}
