/// <reference path="../../../jfm.ui.js" />
/// <reference path="../../entity/entities.js" />
class SessionAdmin {
    constructor() {
        this.User = '';

        let objThis = this;

        this.Observer = new PerformanceObserver((e) => {
            for (let objEntry of e.getEntries()) {
                if (objEntry.initiatorType == "fetch" || objEntry.initiatorType == "xmlhttprequest") {
                    if (objEntry.name.includes(location.hostname) && !objEntry.name.includes('/Register/GetAdminSession')) {
                        objThis.getSession();
                    }
                }
            }
        });
        this.getSession();
    }

    getSession() {
        let objData = new DataAdmin(),
            objThis = this;

        new AJAXKBB().callController('/Register/GetAdminSession', null, (dataR) => {
            objData.setDataFromJSON(dataR);

            if (objData.IsSuccessful) {
                let objSpanSession = document.getElementById('userSession');
                if (!!objSpanSession) {
                    objSpanSession.innerText = objData.Body;
                }
                objThis.User = objData.Body;
                objThis.Observer.observe({   // listen the session
                    entryTypes: ["resource"]
                });
            }
            else {
                if (location.pathname.toLowerCase() != objData.Body.toLowerCase()) {
                    new JFMUI.PopUpAlerts_JS('En breve será redireccionado a la página de registro', 'Caduco su sesión', new JFMUI.Icon_JS({ type: JFMUI.CONST.ICONS.WARNING, width: 36, height: 36 }), undefined, undefined, true).show();
                    location.href = objData.Body;
                }
            }
        }, false);
    }

}


window.addEventListener('load', function () {
    new SessionAdmin();
}, false)

