using System;
using System.Collections.Generic;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using System.Windows.Forms;
using KCM.ServiciosInternet.Common.Library.Encryption;

namespace ConsoleTest
{
    class Program
    {

        private static void StartBrowser(string source)
        {
            var th = new Thread(() =>
            {
                var webBrowser = new WebBrowser();
                webBrowser.ScrollBarsEnabled = false;
                webBrowser.IsWebBrowserContextMenuEnabled = true;
                webBrowser.AllowNavigation = true;

                webBrowser.DocumentCompleted += webBrowser_DocumentCompleted;
                webBrowser.DocumentText = source;

                Application.Run();
            });
            th.SetApartmentState(ApartmentState.STA);
            th.Start();
        }
        static void webBrowser_DocumentCompleted(object sender, WebBrowserDocumentCompletedEventArgs e)
        {
            var webBrowser = (WebBrowser)sender;
            using (Bitmap bitmap =
                new Bitmap(
                    webBrowser.Width,
                    webBrowser.Height))
            {
                webBrowser
                    .DrawToBitmap(
                    bitmap,
                    new System.Drawing
                        .Rectangle(0, 0, bitmap.Width, bitmap.Height));
                bitmap.Save(@"C:\KCM\filename.jpg",
                    System.Drawing.Imaging.ImageFormat.Jpeg);
            }

        }
        static void Main(string[] args)
        {
            var source = @"  
                <!DOCTYPE html>  
                    <html>  
                        <head>  
                            <style>  
                                table {  
                                  font-family: arial, sans-serif;  
                                  border-collapse: collapse;  
                                  width: 100%;  
                                }  
                                  
                                td, th {  
                                  border: 1px solid #dddddd;  
                                  text-align: left;  
                                  padding: 8px;  
                                }  
                                  
                                tr:nth-child(even) {  
                                  background-color: #dddddd;  
                                }  
                          </style>  
                         </head>  
                    <body>  
                      
                        <h2>HTML Table</h2>  
                          
                        <table>  
                          <tr>  
                            <th>Contact</th>  
                            <th>Country</th>  
                          </tr>  
                          <tr>  
                            <td>Kaushik</td>  
                            <td>India</td>  
                          </tr>  
                          <tr>  
                            <td>Bhavdip</td>  
                            <td>America</td>  
                          </tr>  
                          <tr>  
                            <td>Faisal</td>  
                            <td>Australia</td>  
                          </tr>  
                        </table>  
                     </body>  
                    </html> ";

            StartBrowser(source);
            Console.ReadLine();

            string strcadena = @"In the above code, we used a predefined Aes class which is in System.Security.Cryptography namespace that uses the same key for encryption and decryption. AES algorithm supports 128, 198, and 256 bit encryption.";
            var strencode = AesOperation.EncryptString("Zq4t7w!z%C*F-J@NcRfUjXn2r5u8x/A?", strcadena);
            var strdecode = AesOperation.DecryptString("Zq4t7w!z%C*F-J@NcRfUjXn2r5u8x/A?", strencode);
            Console.WriteLine(strcadena);
            Console.WriteLine();
            Console.WriteLine();
            Console.WriteLine(strencode);
            Console.WriteLine();
            Console.WriteLine();
            Console.WriteLine(strdecode);
        }
    }
}
