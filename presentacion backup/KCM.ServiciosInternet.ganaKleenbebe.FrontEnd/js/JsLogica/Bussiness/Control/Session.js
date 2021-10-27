/// <reference path="../entity/entities.js" />
/// <reference path="../../jfm.ui.js" />

window.addEventListener('SSO.Complete', function (event) {
    window.addEventListener('SSO.GetSession', function (event) {
        let objSSOData = event.detail.Data,        // Get session response     
            objRoute = event.detail.Route,        // Get session route validation response     
            objCloseSessionButton = document.querySelector('a.closesesion'),    // session button 
            objUserSession = document.getElementById('userSession'),            // user first letters
            objProfile = null,                                                  // get session event reponse profile
            objData = null;

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

    }, false);

    // get the Session for the SSO
    objSSOBussiness.getSession();
}, false);