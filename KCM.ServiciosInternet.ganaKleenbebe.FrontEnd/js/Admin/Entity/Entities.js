class DataAdmin {
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

class PivotDay {
    constructor() {

        this.Id = 0;
        this.initialDate = '';
        this.endDate = '';
        this.IsProcessed = false;
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

class Ticket {
    constructor() {
        this.PivotDayId = 0;
        this.IdTicket = '';
        this.GameDescription = '';
        this.TicketDate = '';
        this.TicketAmount = 0;
        this.BestTime = '';
        this.Product = 0;
        this.ProductSize = '';
        this.TicketAttempts = 0;
        this.TicketPath = '';
        this.CompetitorUID = '';
        this.CompetitorFirstName = '';
        this.CompetitorLastName = '';
        this.CompetitorEmail = '';
        this.CompetitorBirthDay = '';
        this.CompetitorPhone = '';
        this.BestTimeIdTicket = '';
        this.IsValid = false;
        this.IsWinner = false;
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


class PivotDayResult {
    constructor() {
        this.Id = 0;
        this.PivotDate = '';
        this.IdGameinfo = 0;
        this.GameDescription = '';
        this.Days = 0;
        this.IdParam = '';
        this.CreationDate = '';
        this.IsProcessed = false;
        this.Closeby = '';
        this.ClosebyDate = '';
        this.IsLive = false;
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

class Pivot_ComboBox_Result {
    constructor() {
        this.Id = '';
        this.Description = '';
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

class DisplayError {
    static show(strMsg, strStack) {
        new JFMUI.PopUpAlerts_JS(strStack, strMsg, new JFMUI.Icon_JS({ type: JFMUI.CONST.ICONS.DANGER, width: 36, height: 36 }), undefined, undefined, true).show();
    }
}