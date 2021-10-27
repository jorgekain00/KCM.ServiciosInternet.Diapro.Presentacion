/// <reference path="../entity/entities.js" />
/// <reference path="../../jfm.ui.js" />
class Session {
    static main() {
        let objData = new DataKBB(),
            objDataSSO = new SSO.Data(objSSOBussiness.SiteKey);

        new AJAXKBB().callController('/Register/GetSession', null, (dataR) => {
            objData.setDataFromJSON(dataR);

            if (objData.IsSuccessful) {
                objDataSSO.UID = objData.Body;
            }
            objSSOBussiness.getSession(location.pathname, objDataSSO);
        }, true);
    }

    static UpdateSession() {
        let objSSOData = event.detail.Data,        // Get session response     
            objRoute = event.detail.Route,        // Get session route validation response     
            objCloseSessionButton = document.querySelector('a.closesesion'),    // session button 
            objUserSession = document.getElementById('userSession'),            // user first letters
            objProfile = null,                                                  // get session event reponse profile
            objData = null,
            objLoader;

        if (objRoute.isSuccessful) {
            // Display user session
            if (objSSOData.isSuccessful) {
                if (!!objUserSession) {  // show the first name letters
                    objProfile = JSON.parse(objSSOData.strProfile);
                    objUserSession.innerText = objProfile.firstName.substring(0, 1).toUpperCase() + objProfile.lastName.substring(0, 1).toUpperCase();
                    objUserSession.style.display = 'block';
                }
                if (!!objCloseSessionButton) { // show close session
                    objCloseSessionButton.innerText = 'Cerrar Sesión';
                    objCloseSessionButton.removeEventListener('click', ValidateSession.logIn);
                    objCloseSessionButton.addEventListener('click', ValidateSession.closeSession, false);
                }
            }
            else {
                if (!!objUserSession) {
                    objUserSession.innerText = '';
                    objUserSession.style.display = 'none';
                }
                if (!!objCloseSessionButton) {      // show login
                    objCloseSessionButton.innerText = 'Iniciar Sesión';
                    objCloseSessionButton.removeEventListener('click', ValidateSession.closeSession);
                    objCloseSessionButton.addEventListener('click', ValidateSession.logIn, false);
                }
            }
            objLoader = document.querySelector('div.loader');
            if (!!objLoader) {
                objLoader.style.animation = "hide 1s alternate"
            }
        }
        else {
            //validate route
            objData = new DataKBB();
            objData.Body = objRoute.getJSONData();
            new AJAXKBB().callController('/Register/RedirectToPath', objData, (dataR) => {
                objData.setDataFromJSON(dataR);
                if (objData.IsSuccessful) {
                    location.href = objData.Body;
                }
                else {
                    DisplayError.show('Error', objData.strErrorMessage);
                }
            }, true);
        }

    }
}

window.addEventListener('SSO.GetSession', Session.UpdateSession, false);

window.addEventListener('SSO.Complete', Session.main, false);  // start main after init SSO
