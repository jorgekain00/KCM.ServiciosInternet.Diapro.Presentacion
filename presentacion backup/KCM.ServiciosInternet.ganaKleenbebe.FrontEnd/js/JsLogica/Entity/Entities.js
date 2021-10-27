const ENDOFGAME = {
    OUTIME : 'outTime',
    CANCELGAME: 'cancelGame',
    SUCCESSFUL : 'succesfulGame'
}

class DataKBB {
    strModel = '';
    IsSuccessful = false;
    strErrorMessage = '';
    strUID = '';
    Body = null;

    setDataFromJSON(objR) {
        for (const key in objR) {
            if (Object.hasOwnProperty.call(objR, key)) {
                this[key] = objR[key];

            }
        }
    }

    getJSONData() {
        return JSON.stringify(this);
    }
}


class SoupLettersConfig {

    rows = 0;
    columns = 0;
    ExpiredTimeInSeconds = 0;
    wordsToFind = 0;

    setDataFromJSON(objR) {
        for (const key in objR) {
            if (Object.hasOwnProperty.call(objR, key)) {
                if (key.toLowerCase() == 'config') {
                    this.setDataFromJSON(objR[key])
                }
                else {
                    this[key] = objR[key];
                }
            }
        }
    }
}

class SearchThingsConfig {

    noStage = 0;
    prefix = "";
    template = "";
    backgroundImage = "";
    expiredTimeInSeconds = 0;
    numberThingsToFind = 0;
    thingsToFind = [];

    setDataFromJSON(objR) {
        for (const key in objR) {
            if (key.toLowerCase() == 'thingsToFind'.toLowerCase()) {
                objR[key].forEach(TF => {
                    let objThingsToFind = new ThingsToFind();
                    objThingsToFind.setDataFromJSON(TF)
                    this.thingsToFind.push(objThingsToFind);
                });
            }
            else {
                this[key] = objR[key];
            }
        }
    }
}

class ThingsToFind {
    name = null;
    url = null;
    id = 0;

    setDataFromJSON(objR) {
        for (const key in objR) {
            this[key] = objR[key];
        }
    }
}


class Score {
    Description = null;
    GameDate = null;
    Time = null;

    setDataFromJSON(objR) {
        for (const key in objR) {
            this[key] = objR[key];
        }
    }
}

class ValidateSession {
    static logIn(event) {
        location.href = '/Register/Index';
        event.preventDefault();
        return false;
    }

    static closeSession(event) {
        window.addEventListener('SSO.SessionClosed', function (event) {
            objSSOBussiness.getSession();
        }, false);
        objSSOBussiness.closeSession();
        event.preventDefault();
        return false;
    }
}

class DisplayError{
    static show(strMsg, strStack) {
        new JFMUI.PopUpAlerts_JS(strStack, strMsg, new JFMUI.Icon_JS({ type: JFMUI.CONST.ICONS.DANGER, width: 36, height: 36 }), undefined, undefined, true).show();
    }
}


class AJAXKBB {
    constructor() {
        this.#objAJAXLoader = new JFMUI.AJAXLoader({
            id: 'LoadingAjax',
            background: "rgba(255, 255, 255, 0.74)",
            spinColor: "#eee",
            animationColor: "#122566",
            prefixAnimation: "ticket",
            center: false,
            width: "70px",
            height: "70px",
            position: 'fixed'
        });
        document.body.appendChild(this.#objAJAXLoader.BoxLoading);
    }

    #objAJAXLoader = null;

    callController(strController, objData, fnCallBack, WithLoader = false ) {
        new JFMUI.AJAXCommunications_JS({
            beforeSendFunction: () => {
                if (!!WithLoader) {
                    this.#objAJAXLoader.displayBoxLoading('block');
                }
            },
            completeFunction: () => {
                if (!!WithLoader) {
                    this.#objAJAXLoader.displayBoxLoading('none');
                }
            },
            errorFunction: DisplayError.show,
            successFunction: fnCallBack,
            contentType: JFMUI.CONST.CONTENTTYPE.JSON,
            data: (objData) ? objData.getJSONData() : null,
            mode: JFMUI.CONST.FETCHMODES.SAMEORIGIN,
            type: 'Post',
            url: strController
        }).AsyncSend();
    }
}