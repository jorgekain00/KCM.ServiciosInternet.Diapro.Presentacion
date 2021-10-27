const ENDOFGAME = {
    OUTIME: 'outTime',
    CANCELGAME: 'cancelGame',
    SUCCESSFUL: 'succesfulGame'
}

class DataKBB {
    constructor() {
        this.strModel = '';
        this.IsSuccessful = false;
        this.strErrorMessage = '';
        this.strUID = '';
        this.Body = null;
    }

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
    constructor() {
        this.rows = 0;
        this.columns = 0;
        this.ExpiredTimeInSeconds = 0;
        this.wordsToFind = 0;
    }

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
    constructor() {
        this.noStage = 0;
        this.prefix = "";
        this.template = "";
        this.backgroundImage = "";
        this.expiredTimeInSeconds = 0;
        this.numberThingsToFind = 0;
        this.thingsToFind = [];
    }

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
    constructor() {
        this.name = null;
        this.url = null;
        this.id = 0;
    }

    setDataFromJSON(objR) {
        for (const key in objR) {
            this[key] = objR[key];
        }
    }
}


class Score {
    constructor() {
        this.Description = null;
        this.GameDate = null;
        this.Time = null;
    }

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
        location.href = '/Register/CloseSession';
        event.preventDefault();
        return false;
    }
}

class DisplayError {
    static show(strMsg, strStack) {
        new JFMUI.PopUpAlerts_JS(strStack, strMsg, new JFMUI.Icon_JS({ type: JFMUI.CONST.ICONS.DANGER, width: 36, height: 36 }), undefined, undefined, true).show();
    }
}


class AJAXKBB {
    constructor() {
        this.objAJAXLoader = new JFMUI.AJAXLoader({
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
        document.body.appendChild(this.objAJAXLoader.BoxLoading);
    }
    callController(strController, objData, fnCallBack, WithLoader = false) {
        new JFMUI.AJAXCommunications_JS({
            beforeSendFunction: () => {
                if (!!WithLoader) {
                    this.objAJAXLoader.displayBoxLoading('block');
                }
            },
            completeFunction: () => {
                if (!!WithLoader) {
                    this.objAJAXLoader.displayBoxLoading('none');
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