/// <reference path="../../entity/entities.js" />
class AdminWinners {
    constructor() {
        this.objBtnExcel = document.querySelector('#btnExcel');
        this.objBtnSave = document.querySelector('#btnSave');
        this.objBtnConfirm = document.querySelector('#btnConfirm');
        this.objBtnMore = document.querySelector('#btnMore');
        this.objCheckCollection = new Map();
        this.intTotalOfRows = 0;
        this.BestTimeIdTicket = '';
        this.init();
    }

    init() {
        this.disabledButtons();
        this.getRangeOfDates();
        this.addEventListeners();
    }

    disabledButtons() {
        if (!this.objBtnExcel || !this.objBtnSave || !this.objBtnConfirm || !this.objBtnMore) {
            throw new Error('AdminWinners.disabledButtons: "missing buttons" Excel or Save or Confirm or More');
        }
        this.objBtnExcel.classList.add('disabled');
        this.objBtnSave.classList.add('disabled');
        this.objBtnConfirm.classList.add('disabled');
        this.objBtnMore.classList.add('disabled');
        this.objPivotDay = null;
    }

    getRangeOfDates() {
        let objData = new DataAdmin(),
            objRange = document.querySelector('#numeroCorte'),
            objPivotDay = null,
            objOption = document.createElement('OPTION'),
            intPrevNonConfirmedPivots = 0,
            objThis = this;

        if (!!objRange) {
            objRange.innerText = '';
            objOption.value = '0';
            objOption.innerText = 'Seleccione el número de corte...';
            objRange.appendChild(objOption);
        }

        new AJAXKBB().callController('/Winners/GetRangeDates', objData, (dataR) => {
            objData.setDataFromJSON(dataR);
            if (objData.IsSuccessful) {
                objData.Body.some(r => {
                    objPivotDay = new PivotDay();
                    objPivotDay.setDataFromJSON(r);
                    if (intPrevNonConfirmedPivots != 0) {
                        new JFMUI.PopUpAlerts_JS('El corte #' + intPrevNonConfirmedPivots + ' no ha sido confirmado. Favor de confirmar los ganadores antes de continuar.', 'Corte Por semana', new JFMUI.Icon_JS({ type: JFMUI.CONST.ICONS.WARNING, width: 36, height: 36 }), undefined, undefined, true).show();
                        return true;
                    }
                    else {
                        objOption = document.createElement('OPTION');
                        objOption.value = objPivotDay.Id;
                        objOption.innerText = objPivotDay.Id + '.   ' + objPivotDay.initialDate + '     >      ' + objPivotDay.endDate;
                        objOption.objPivotDay = objPivotDay;                //save the pivotDayValue
                        objRange.appendChild(objOption);
                    }

                    if (objPivotDay.IsProcessed == false) {
                        intPrevNonConfirmedPivots = objPivotDay.Id;
                    }
                    return false;
                });
            }
            else {
                DisplayError.show('Error', objData.strErrorMessage);
            }
        }, true);
    }

    addEventListeners() {
        let objThis = this,
            objRange = document.querySelector('#numeroCorte');

        this.objBtnMore.addEventListener('click', function (event) {
            objThis.getTickets(objThis.objPivotDay, objThis.BestTimeIdTicket, true);
        }, false);
        this.objBtnExcel.addEventListener('click', function (event) {
            objThis.getAllTicketsInExcel();
        }, false);
        this.objBtnSave.addEventListener('click', function (event) {
            objThis.UpdateTickets();
        }, false);
        this.objBtnConfirm.addEventListener('click', function (event) {
            objThis.UpdateLockPivotDay();
        }, false);

        objRange.addEventListener('change', function (event) {
            let objSelect = event.currentTarget,
                objOpt = null;
            if (!!objSelect) {
                for (let index = 1; index < objSelect.options.length; index++) {
                    objOpt = objSelect.options[index];
                    if (objOpt.selected) {
                        document.querySelector('#TicketTable > table > tbody').innerText = "";  // delete table rows
                        objThis.intTotalOfRows = 0;
                        objThis.disabledButtons();
                        objThis.getTickets(objOpt.objPivotDay);   // objPivotDay is added by getRangeOfDates() method
                        break;
                    }
                }
            }
        }, false);
    }

    getTickets(objP, nextRow = ' ', boolMoreTickets = false) {
        let objData = new DataAdmin();

        this.objPivotDay = new PivotDay();
        this.objPivotDay.setDataFromJSON(objP);

        objData.Body = this.objPivotDay.getJSONData();
        objData.strUID = nextRow;  //the first time is empty. 

        new AJAXKBB().callController('/Winners/GetTickets', objData, (dataR) => {
            objData.setDataFromJSON(dataR);
            if (objData.IsSuccessful) {
                if (objData.Body == 0 && boolMoreTickets == false) {
                    this.updateTicketsByPivotDay();
                }
                else {
                    this.showTickets(objData.Body);
                }
            }
            else {
                DisplayError.show('Error', objData.strErrorMessage);
            }
        }, true);
    }

    updateTicketsByPivotDay() {
        let objData = new DataAdmin();

        new JFMUI.PopUpAlerts_JS('El corte #' + this.objPivotDay.Id + ' no ha sido cargado anteriormente. Sólo por esta ocasión el proceso puede tardar varios minutos.', 'Corte Por semana', new JFMUI.Icon_JS({ type: JFMUI.CONST.ICONS.INFO, width: 36, height: 36 }), undefined, undefined, true).show();

        objData.Body = this.objPivotDay.getJSONData();
        new AJAXKBB().callController('/Winners/UpdateTicketByPivotDay', objData, (dataR) => {
            objData.setDataFromJSON(dataR);
            if (objData.IsSuccessful) {
                this.showTickets(objData.Body);
            }
            else {
                DisplayError.show('Error', objData.strErrorMessage);
            }
        }, true);
    }

    showTickets(ticketsCollection) {
        let intnumberRow = 0,
            objTicket = null,
            objThis = this,
            objCol = null,
            objRow = null,
            objSwap = null,
            objTicketTable = null,
            objColCompetitor = null,
            objRowCompetitor = null,
            objSwapCompetitor = null,
            objCompetitorSection = null,
            objCompetitorTable = null,
            objGameSection = null,
            objGameTable = null,
            objDiv = null,
            objButton = null,
            objAnchorCompetitor = null,
            objNewRowsCollection = [];

        if (this.intTotalOfRows == 0) {  // firstTime
            if (ticketsCollection.length > 0) {
                if (!this.objPivotDay.IsProcessed) {
                    if (this.objBtnSave.classList.contains('disabled')) {
                        this.objBtnSave.classList.remove('disabled');
                    }
                    if (this.objBtnConfirm.classList.contains('disabled')) {
                        this.objBtnConfirm.classList.remove('disabled');
                    }
                }
                if (this.objBtnExcel.classList.contains('disabled')) {
                    this.objBtnExcel.classList.remove('disabled');
                }
                if (this.objBtnMore.classList.contains('disabled')) {
                    this.objBtnMore.classList.remove('disabled');
                }
            }
        }
        else {
            if (ticketsCollection.length == 0) {
                if (!this.objBtnMore.classList.contains('disabled')) {
                    this.objBtnMore.classList.add('disabled');
                    new JFMUI.PopUpAlerts_JS('Ya no hay más registros', 'Consulta de tickets', new JFMUI.Icon_JS({ type: JFMUI.CONST.ICONS.WARNING, width: 36, height: 36 }), undefined, undefined, true).show();
                }
            }
        }

        intnumberRow = this.intTotalOfRows;             // indicates the number of row
        this.intTotalOfRows += ticketsCollection.length;       // sum the number of rows

        objTicketTable = document.querySelector('#TicketTable > table > tbody');
        if (!objTicketTable) {
            throw new Error('AdminWinners.showTickets : Missing TicketTable');
        }

        ticketsCollection.forEach(row => {
            objTicket = new Ticket();
            objTicket.setDataFromJSON(row);

            // Ticket Table
            ++intnumberRow;
            objRow = document.createElement('TR');

            objCol = document.createElement('TH');
            objButton = document.createElement('BUTTON');
            objButton.classList.add('btn', 'btn-dark', 'collapseTicket');
            objButton.dataset.bsToggle = "collapse";
            objButton.dataset.bsTarget = "#competitor" + intnumberRow;
            objButton.ariaExpanded = "false";
            objButton.ariaControls = "competitor" + intnumberRow;
            objButton.innerText = "+";
            AdminWinners.collapseEventListener(objThis, objButton);
            objCol.appendChild(objButton);
            objRow.appendChild(objCol);

            objCol = document.createElement('TH');
            objCol.innerText = intnumberRow;
            objRow.appendChild(objCol);

            // inner Competitor Table
            objCompetitorSection = document.querySelector('#competitorSection');
            if (!!objCompetitorSection) {
                objCompetitorSection = objCompetitorSection.cloneNode(true);
                objCompetitorSection.id = 'competitorSection' + intnumberRow;
                objCompetitorSection.style.display = "initial";
                objCompetitorTable = objCompetitorSection.querySelector('table > tbody');
            }
            else {
                throw new Error('AdminWinners.showTickets : Missing CompetitorTable Template');
            }

            objRowCompetitor = document.createElement('TR');
            objColCompetitor = document.createElement('TH');

            objButton = document.createElement('BUTTON');
            objButton.classList.add('btn', 'btn-dark', 'collapseTicket');
            objButton.dataset.bsToggle = "collapse";
            objButton.dataset.bsTarget = "#games" + intnumberRow;
            objButton.ariaExpanded = "false";
            objButton.ariaControls = "games" + intnumberRow;
            objButton.innerText = "+";
            AdminWinners.loadGamesTableEventListener(objThis, objButton, "#games" + intnumberRow, objTicket.IdTicket, objTicket.BestTime);
            AdminWinners.collapseEventListener(objThis, objButton)
            objColCompetitor.appendChild(objButton);
            objRowCompetitor.appendChild(objColCompetitor);

            // inner inner Game table
            objGameSection = document.querySelector('#gameSection');
            if (!!objGameSection) {
                objGameSection = objGameSection.cloneNode(true);
                objGameSection.style.display = "initial";
                objGameSection.id = 'gameSection' + intnumberRow;
                objGameTable = objGameSection.querySelector('table > tbody');
            }
            else {
                throw new Error('AdminWinners.showTickets : Missing CompetitorTable Template');
            }

            for (let prop in objTicket) {
                if (typeof objTicket[prop] != 'function') {
                    if (prop.includes('Competitor')) {
                        if (prop == 'CompetitorUID') {
                            objColCompetitor = document.createElement('TH');
                        }
                        else {
                            objColCompetitor = document.createElement('TD');
                        }

                        if (prop == 'CompetitorEmail' || prop == 'CompetitorPhone') {
                            objAnchorCompetitor = document.createElement('A');
                            objAnchorCompetitor.href = ((prop == 'CompetitorEmail') ? 'mailto:' : 'tel:') + objTicket[prop];
                            objAnchorCompetitor.innerText = objTicket[prop];
                            objSwapCompetitor = objAnchorCompetitor;
                        }
                        else {
                            objSwapCompetitor = document.createTextNode(objTicket[prop])
                        }

                        objColCompetitor.dataset.property = prop;
                        objColCompetitor.dataset.propertyValue = objTicket[prop];
                        objColCompetitor.appendChild(objSwapCompetitor);
                        objRowCompetitor.appendChild(objColCompetitor);
                    }
                    else {
                        if (prop == 'IsValid' || prop == 'IsWinner') {
                            objDiv = document.createElement('DIV');
                            objDiv.classList.add('form-check');
                            objButton = document.createElement('INPUT');
                            objButton.type = "checkbox";
                            objButton.classList.add('form-check-input', 'ticket-' + prop);
                            objButton.checked = objTicket[prop] ? true : false;
                            if (this.objPivotDay.IsProcessed == 0) {
                                AdminWinners.changeTicketCheckButtonEventListener(objThis, objRow, objButton);
                                objButton.disabled = false;
                            }
                            else {
                                objButton.disabled = true;
                            }
                            objDiv.appendChild(objButton);
                            objSwap = objDiv;
                        }
                        else if (prop == 'BestTimeIdTicket') {
                            this.BestTimeIdTicket = objTicket.BestTimeIdTicket;
                            continue;
                        }
                        else if (prop == 'IdTicket') {
                            objButton = document.createElement('BUTTON');
                            objButton.classList.add('btn', 'btn-primary');
                            objButton.innerText = objTicket.IdTicket.trim();
                            AdminWinners.showTicketModalEventListener(objThis, objButton, objTicket.IdTicket, objTicket.CompetitorUID);
                            objSwap = objButton;
                        }
                        else {
                            objSwap = document.createTextNode(objTicket[prop])
                        }
                        objCol = document.createElement('TD');
                        //objCol.style.fontSize = (prop == 'TicketPath') ? '10px' : 'initial';
                        objCol.dataset.property = prop;
                        objCol.dataset.propertyValue = objTicket[prop];
                        objCol.appendChild(objSwap);
                        objRow.appendChild(objCol);
                    }
                }
            }

            objTicketTable.appendChild(objRow);  // add a Ticket row
            objNewRowsCollection.push(objRow);  // save new rows for later use (enable collapse methods)

            if (!!objCompetitorTable) {
                objColCompetitor = document.createElement('TD');
                objButton = document.createElement('BUTTON');
                objButton.classList.add('btn', 'btn-success');
                objButton.innerText = 'Descargar historial';
                AdminWinners.downloadUserRecordEventListener(objButton, objThis, objTicket.CompetitorUID);
                objColCompetitor.appendChild(objButton);
                objRowCompetitor.appendChild(objColCompetitor);
                objCompetitorTable.appendChild(objRowCompetitor); // add a competitor row 

                objRowCompetitor = document.createElement('TR');
                objColCompetitor = document.createElement('TD');
                objColCompetitor.id = 'games' + intnumberRow;
                objColCompetitor.classList.add('collapse');
                objColCompetitor.setAttribute('colspan', 14);
                objColCompetitor.appendChild(objGameSection);
                objRowCompetitor.appendChild(objColCompetitor);
                objCompetitorTable.appendChild(objRowCompetitor); // add a competitor row

                objRow = document.createElement('TR');
                objCol = document.createElement('TD');
                objCol.id = "competitor" + intnumberRow;
                objCol.classList.add('collapse');
                objCol.setAttribute('colspan', 14);
                objCol.appendChild(objCompetitorSection);
                objRow.appendChild(objCol);
                objTicketTable.appendChild(objRow);  // add competitor table into ticket row
                objNewRowsCollection.push(objRow); // save new rows for later use (enable collapse methods)
            }
        });

        // enable collapse method
        objNewRowsCollection.forEach(nR => {
            [].slice.call(nR.querySelectorAll('.collapseTicket')).map(objC => new bootstrap.Collapse(objC));
        });

        //enable Top Scroll
        let objBar1 = document.querySelector('.div1')
        let objTable = document.querySelector('#TicketTable table');
        objBar1.style.width = window.getComputedStyle(objTable, null).getPropertyValue("width");

    }

    loadGamesTable(strTarget, IdTicket, strBestTime) {
        let objData = new DataAdmin(),
            objGameTable = null,
            objRow = null,
            objCol = null,
            objGameSection = null;

        objGameSection = document.querySelector(strTarget);
        objGameTable = objGameSection.querySelector('table > tbody');

        if (!!objGameTable.querySelector('tr')) {
            return;
        }

        objData.Body = this.objPivotDay.getJSONData();
        objData.strUID = IdTicket;

        new AJAXKBB().callController('/Winners/GetGamesByTicket', objData, (dataR) => {
            objData.setDataFromJSON(dataR);
            if (objData.IsSuccessful) {
                if (!!objGameSection) {
                    objData.Body.forEach(row => {
                        objRow = document.createElement('TR');
                        for (var prop in row) {
                            if (typeof row[prop] != 'function') {
                                if (prop == 'numberGame') {
                                    objCol = document.createElement('TH');
                                }
                                else {
                                    objCol = document.createElement('TD');
                                }
                                if (row[prop] != null && prop === 'Time' && strBestTime == row[prop]) {
                                    objCol.style.color = "#0000ff";
                                    objCol.style.textShadow = "0px 1px #000000";
                                }
                                if (row[prop] == null && prop === 'Time') {
                                    objCol.style.color = "#ff0000";
                                    objCol.style.textShadow = "0px 1px #000000";
                                }
                                objCol.innerText = !!(row[prop]) ? row[prop] : 'JUEGO NO TERMINADO';
                            }
                            objRow.appendChild(objCol);
                        }
                        objGameTable.appendChild(objRow);
                    });
                }
            }
            else {
                DisplayError.show('Error', objData.strErrorMessage);
            }
        }, true);
    }

    changeTicketCheckButton(objRow, objButton) {
        let objRowValue = null,
            isWinnerOld = false,
            isWinnerNew = false,
            isValidOld = false,
            isValidNew = false;


        if (objButton.classList.contains('ticket-IsValid')) {
            if (!objButton.checked) {
                isWinnerNew = objRow.querySelector('.ticket-IsWinner').checked;
                if (isWinnerNew) {
                    objButton.checked = true;
                    new JFMUI.PopUpAlerts_JS('Quite la marca de ganador antes de declarar inválido el ticket', 'Actualización de tickets', new JFMUI.Icon_JS({ type: JFMUI.CONST.ICONS.DANGER, width: 36, height: 36 }), undefined, undefined, true).show();
                    return;
                }
            }
        }
        else if (objButton.classList.contains('ticket-IsWinner')) {
            if (objButton.checked) {
                isValidNew = objRow.querySelector('.ticket-IsValid').checked;
                if (!isValidNew) {
                    objButton.checked = false;
                    new JFMUI.PopUpAlerts_JS('No se puede declarar ganador si el ticket es inválido', 'Actualización de tickets', new JFMUI.Icon_JS({ type: JFMUI.CONST.ICONS.DANGER, width: 36, height: 36 }), undefined, undefined, true).show();
                    return;
                }
            }
        }

        isValidNew = objRow.querySelector('td[data-property="IsValid"] input[type="checkbox"]').checked;
        isValidOld = objRow.querySelector('td[data-property="IsValid"]').dataset.propertyValue.toLowerCase() == 'true' ? true : false;

        isWinnerNew = objRow.querySelector('td[data-property="IsWinner"] input[type="checkbox"]').checked;
        isWinnerOld = objRow.querySelector('td[data-property="IsWinner"]').dataset.propertyValue.toLowerCase() == 'true' ? true : false;


        if (isValidNew == isValidOld && isWinnerNew == isWinnerOld) {
            if (this.objCheckCollection.has(objRow)) {
                this.objCheckCollection.delete(objRow);
                objRow.style.background = 'initial';
            }
        }
        else {
            objRowValue = {
                ticket: objRow.querySelector('td[data-property="IdTicket"]').dataset.propertyValue,
                isValid: isValidNew,
                isWinner: isWinnerNew
            }
            this.objCheckCollection.set(objRow, objRowValue);
            objRow.style.background = '#ffffbf';
        }
    }

    showTicketModal(IdTicket, CompetitorUID) {
        let objData = new DataAdmin();

        objData.Body = IdTicket
        objData.strUID = CompetitorUID;

        new AJAXKBB().callController('/Winners/GetTicketImage', objData, (dataR) => {
            objData.setDataFromJSON(dataR);
            if (objData.IsSuccessful) {
                new JFMUI.PopUpAlerts_JS('<img src="' + objData.Body + '" alt="' + IdTicket + '" width="420" height="900">', 'Ticket:' + IdTicket, new JFMUI.Icon_JS({ type: JFMUI.CONST.ICONS.INFO, width: 36, height: 36 }), undefined, undefined, true).show();
            }
            else {
                DisplayError.show('Error', objData.strErrorMessage);
            }
        }, true);
    }

    downloadUserRecord(CompetitorUID) {
        let objData = new DataAdmin();

        objData.strUID = CompetitorUID;

        new AJAXKBB().callController('/Winners/GetUserRecords', objData, (dataR) => {
            let objUrl = window.URL.createObjectURL(dataR);
            let objAnchor = document.createElement('A');
            objAnchor.style.display = 'none';
            objAnchor.href = objUrl;
            // the filename you want
            objAnchor.download = CompetitorUID + '.zip';
            document.body.appendChild(objAnchor);
            objAnchor.click();
            window.URL.revokeObjectURL(objUrl);
        }, true);
    }

    getAllTicketsInExcel() {
        let objData = new DataAdmin();

        objData.Body = this.objPivotDay.getJSONData();

        new AJAXKBB().callController('/Winners/GetAllTicketsInExcel', objData, (dataR) => {
            let objUrl = window.URL.createObjectURL(dataR);
            let objAnchor = document.createElement('A');
            objAnchor.style.display = 'none';
            objAnchor.href = objUrl;
            // the filename you want
            objAnchor.download = "Corte" + this.objPivotDay.Id + '.xlsx';
            document.body.appendChild(objAnchor);
            objAnchor.click();
            window.URL.revokeObjectURL(objUrl);
        }, true);
    }

    UpdateTickets() {
        let objData = new DataAdmin(),
            objCollectTicket = [],
            objThis = this;

        objData.Body = this.objPivotDay.getJSONData();

        if (this.objCheckCollection.size == 0) {
            return;
        }

        this.objCheckCollection.forEach((v, k) => {
            objCollectTicket.push(v);
        });
        objData.strUID = JSON.stringify(objCollectTicket);

        new AJAXKBB().callController('/Winners/UpdateTickets', objData, (dataR) => {
            objData.setDataFromJSON(dataR);
            if (objData.IsSuccessful) {
                new JFMUI.PopUpAlerts_JS('Se han guardado los cambios con exito', 'Actualización de tickets', new JFMUI.Icon_JS({ type: JFMUI.CONST.ICONS.SUCCESS, width: 36, height: 36 }), undefined, undefined, true).show();
                objThis.objCheckCollection.forEach((value, key) => {
                    key.style.background = 'initial';
                    key.querySelector('td[data-property="IsValid"]').dataset.propertyValue = value.isValid;
                    key.querySelector('td[data-property="IsWinner"]').dataset.propertyValue = value.isWinner;
                });
                objThis.objCheckCollection.clear();
                setTimeout(()=>location.reload(), 2000);
            }
            else {
                DisplayError.show('Error', objData.strErrorMessage);
            }
        }, true);
    }

    UpdateLockPivotDay() {
        let objData = new DataAdmin(),
            objThis = this;
        objData.Body = this.objPivotDay.getJSONData();

        if (this.objCheckCollection.size > 0) {
            new JFMUI.PopUpAlerts_JS('Antes de continuar, guarde sus cambios pendientes', 'Actualización de ganadores', new JFMUI.Icon_JS({ type: JFMUI.CONST.ICONS.WARNING, width: 36, height: 36 }), undefined, undefined, true).show();
            return;
        }

        new JFMUI.PopUpConfirm_JS('¿Esta seguro de confirmar los ganadores?. Una vez hecho esto no se puede modificar.', 'Cerrar corte', this.Icon).show(
            () => {
                new AJAXKBB().callController('/Winners/UpdateLockPivotDay', objData, (dataR) => {
                    objData.setDataFromJSON(dataR);
                    if (objData.IsSuccessful) {
                        new JFMUI.Alert_JS('Se han confirmador los ganadores con exito. El cierre de este corte se ha efectuado').generateAlert('#alerts');
                        //new JFMUI.PopUpAlerts_JS('Se han confirmador los ganadores con exito.', 'Cierre del corte finalizado', new JFMUI.Icon_JS({ type: JFMUI.CONST.ICONS.SUCCESS, width: 36, height: 36 }), undefined, undefined, true).show();
                        objThis.objBtnSave.classList.add('disabled');
                        objThis.objBtnConfirm.classList.add('disabled');
                        document.querySelectorAll('input[type="checkbox"]').forEach(c => c.disabled = true)
                        objThis.getRangeOfDates();
                    }
                    else {
                        DisplayError.show('Error', objData.strErrorMessage);
                    }
                }, true);
            });
    }

    collapeButton(objButton) {
        if (objButton.innerText == "+") {
            objButton.innerText = "-";
        }
        else {
            objButton.innerText = "+";
        }
    }

    static loadGamesTableEventListener(objThis, objButton, strRowSelector, strTicket, strBesTime) {
        objButton.addEventListener('click', function (event) {
            objThis.loadGamesTable(strRowSelector, strTicket, strBesTime);
        }, false);
    }

    static changeTicketCheckButtonEventListener(objThis, objRow, objButton) {
        objButton.addEventListener('change', function (event) {
            objThis.changeTicketCheckButton(objRow, objButton);
        });
    }

    static showTicketModalEventListener(objThis, objButton, strTicket, strCompetitorUID) {
        objButton.addEventListener('click', function (event) {
            objThis.showTicketModal(strTicket, strCompetitorUID)
        }, false);
    }

    static downloadUserRecordEventListener(objButton, objThis, strCompetitorUID) {
        objButton.addEventListener('click', function (event) {
            objThis.downloadUserRecord(strCompetitorUID);
        }, false);
    }
    static collapseEventListener(objThis, objButton) {
        objButton.addEventListener('click', function (event) {
            objThis.collapeButton(objButton);
        }, false);
    }
}

window.addEventListener('load', function (event) {
    new AdminWinners();
});



