/// <reference path="../../entity/entities.js" />
class AdminPivotDay {
    constructor() {
        this.BtnAddPivotDay = document.querySelector('#AddPivotDay');
        this.BtnPivotAccept = document.querySelector('#modalPivot #PivotAccept');
        this.init();
    }

    init() {
        this.initGameInfoComboBox();
        this.initParamsComboBox();
        this.GetPivotDays();
        this.addEventListeners();
        this.initForm();
    }
    initGameInfoComboBox() {
        let objData = new DataAdmin();
        new AJAXKBB().callController('/PivotDay/GetGameInfo', objData, (dataR) => {
            objData.setDataFromJSON(dataR);
            if (objData.IsSuccessful) {
                let modalPivotSelect = document.querySelector('#modalPivot #IdGameinfo'),
                    objComboResultCollection = objData.Body,
                    objComboBox = new Pivot_ComboBox_Result(),
                    objHTMLOption = null

                modalPivotSelect.innerText = '';

                objHTMLOption = document.createElement('OPTION');
                objHTMLOption.value = 0;
                objHTMLOption.innerText = 'Seleccione juego';
                modalPivotSelect.appendChild(objHTMLOption);

                objComboResultCollection.forEach(CB => {
                    objComboBox.setDataFromJSON(CB);
                    objHTMLOption = document.createElement('OPTION');
                    objHTMLOption.value = objComboBox.Id;
                    objHTMLOption.innerText = objComboBox.Description;
                    modalPivotSelect.appendChild(objHTMLOption);
                });

            }
            else {
                DisplayError.show('Error', objData.strErrorMessage);
            }
        }, true);
    }
    initParamsComboBox() {
        let objData = new DataAdmin();
        new AJAXKBB().callController('/PivotDay/GetParams', objData, (dataR) => {
            objData.setDataFromJSON(dataR);
            if (objData.IsSuccessful) {
                let modalPivotSelect = document.querySelector('#modalPivot #IdParam'),
                    objComboResultCollection = objData.Body,
                    objComboBox = new Pivot_ComboBox_Result(),
                    objHTMLOption = null

                modalPivotSelect.innerText = '';

                objHTMLOption = document.createElement('OPTION');
                objHTMLOption.value = 0;
                objHTMLOption.innerText = 'Seleccione parámetro de promoción';
                modalPivotSelect.appendChild(objHTMLOption);

                objComboResultCollection.forEach(CB => {
                    objComboBox.setDataFromJSON(CB);
                    objHTMLOption = document.createElement('OPTION');
                    objHTMLOption.value = objComboBox.Id;
                    objHTMLOption.innerText = objComboBox.Description;
                    modalPivotSelect.appendChild(objHTMLOption);
                });

            }
            else {
                DisplayError.show('Error', objData.strErrorMessage);
            }
        }, true);
    }
    addEventListeners() {
        let objThis = this;

        this.BtnAddPivotDay.addEventListener('click', function (event) {
            objThis.EditPivotDay();
        }, false);
    }
    initForm() {
        this.Form = new JFMUI.Forms_JS({
            selector: '#PivotForm',
            onErrorField: (field) => {
                field.style.boxShadow = 'inset 0px 0px 5px red';
            },
            onValidField: (field) => {
                field.style.boxShadow = 'initial';
            },
            onSubmit: function (event) {
                if (!event.IsValid) {
                    return false;
                }

                let objcheckPivot = this.Form.querySelector('input[type="checkbox"]');
                if (!!objcheckPivot) {
                    objcheckPivot.value = objcheckPivot.checked;
                }
                return true;
            },
            isSubmitEnable: true,
            onSuccess: function (dataR) {
                let objData = new DataAdmin();
                objData.setDataFromJSON(dataR);
                if (objData.IsSuccessful) {

                    new JFMUI.PopUpAlerts_JS((!!objData.strErrorMessage) ? objData.strErrorMessage : 'Se ha actualizado el corte exitosamente.', 'Corte Por semana', new JFMUI.Icon_JS({ type: JFMUI.CONST.ICONS.SUCCESS, width: 36, height: 36 }), undefined, undefined, true).show();
                    setTimeout(() => location.reload(true), 3000);
                }
                else {
                    let objMsg = this.Form.querySelector('[data-msg-error="true"]');
                    if (!!objMsg) {
                        objMsg.innerText = objData.strErrorMessage;
                    }
                }
            },
            onFailure: DisplayError.show,
        })
    }
    GetPivotDays() {
        let objData = new DataAdmin();

        new AJAXKBB().callController('/PivotDay/GetPivotDays', objData, (dataR) => {
            objData.setDataFromJSON(dataR);
            if (objData.IsSuccessful) {
                this.ShowPivotDays(objData.Body);
            }
            else {
                DisplayError.show('Error', objData.strErrorMessage);
            }
        }, true);
    }

    ShowPivotDays(objPivotDaysCollection) {
        let objPivotDayResult = new PivotDayResult(),
            objRow = null,
            objCol = null,
            objButton = null,
            objI = null,
            objTableBody = document.querySelector('#PivotTable tbody'),
            objThis = this;

        objPivotDaysCollection.forEach(row => {
            objPivotDayResult.setDataFromJSON(row);
            objRow = document.createElement('TR');

            for (let prop in objPivotDayResult) {
                if (prop != 'GameDescription' && typeof objPivotDayResult[prop] != 'function') {
                    if (prop == 'Id') {
                        objCol = document.createElement('TH');
                    }
                    else {
                        objCol = document.createElement('TD');
                    }

                    if (prop == 'IdGameinfo') {
                        objCol.innerText = objPivotDayResult.GameDescription;
                    }
                    else if (prop == 'IsProcessed') {
                        objCol.innerText = (objPivotDayResult.IsProcessed) ? 'Si' : 'No';
                    }
                    else if (prop == 'IsLive') {
                        objCol.innerHTML = `<div class="d-flex">
                                                <img width="14" height="14" src="/Images/${(objPivotDayResult.IsLive) ? 'greenCircle.png' : 'redCircle.png'}"\>
                                            </div>
                                            `;
                    }
                    else {
                        objCol.innerText = (!!objPivotDayResult[prop]) ? objPivotDayResult[prop] : 'N/A';
                    }

                    objCol.dataset.property = prop;
                    objCol.dataset.propertyValue = objPivotDayResult[prop];
                    objRow.appendChild(objCol);
                }
            }

            objCol = document.createElement('TD');
            objButton = document.createElement('BUTTON');
            objButton.classList.add('btn', 'btn-primary');
            objI = document.createElement('I');
            objI.classList.add('bi', 'bi-pencil-square');
            objButton.appendChild(objI);
            objCol.appendChild(objButton);
            objRow.appendChild(objCol);

            AdminPivotDay.EditPivotDayEventLister(objThis, objButton, objRow);

            objCol = document.createElement('TD');

            if (!objPivotDayResult.IsLive) {
                objButton = document.createElement('BUTTON');
                objButton.classList.add('btn', 'btn-danger');
                objI = document.createElement('I');
                objI.classList.add('bi', 'bi-trash');
                objButton.appendChild(objI);
                objCol.appendChild(objButton);
                AdminPivotDay.DeletePivotDayEventLister(objThis, objButton, objRow);
            }

            objRow.appendChild(objCol);

            objRow.PivotDayResult = new PivotDayResult();
            objRow.PivotDayResult.setDataFromJSON(objPivotDayResult);

            if (!!objTableBody) {
                objTableBody.appendChild(objRow);
            }
        });
    }

    EditPivotDay(objRow) {
        let objmodalPivot = document.getElementById('modalPivot'),
            objPivotDayResult = new PivotDayResult(),
            objPivotId = null,
            objPivotDate = null,
            objPivotTime = null,
            objIdGameinfo = null,
            objDays = null,
            objIdParam = null,
            objIsProcessed = false;

        objPivotId = document.querySelector('#modalPivot #Id');
        objPivotDate = document.querySelector('#modalPivot #PivotDate');
        objPivotTime = document.querySelector('#modalPivot #PivotTime');
        objIdGameinfo = document.querySelector('#modalPivot #IdGameinfo');
        objDays = document.querySelector('#modalPivot #Days');
        objIdParam = document.querySelector('#modalPivot #IdParam');
        objIsProcessed = document.querySelector('#modalPivot #IsProcessed');

        if (!!objRow) {
            objPivotDayResult.setDataFromJSON(objRow.PivotDayResult);

            if (objPivotDayResult.IsLive) {
                objPivotDate.disabled = true;
                objIdGameinfo.disabled = true;
                objDays.disabled = true;
                objIdParam.disabled = true;
            }
            else {
                objPivotDate.disabled = false;
                objIdGameinfo.disabled = false;
                objDays.disabled = false;
                objIdParam.disabled = false;
            }
            objIsProcessed.disabled = false;

            objPivotId.value = objPivotDayResult.Id;
            objPivotDate.value = objPivotDayResult.PivotDate.substring(0, 10);

            [].slice.apply(objIdGameinfo.options).some(op => {
                if (op.value == objPivotDayResult.IdGameinfo) {
                    op.selected = true;
                    return true;
                }
            });

            objDays.value = objPivotDayResult.Days;

            [].slice.apply(objIdParam.options).some(op => {
                if (op.value == objPivotDayResult.IdParam) {
                    op.selected = true;
                    return true;
                }
            });

            objIsProcessed.checked = objPivotDayResult.IsProcessed;
            document.getElementById('modalTicketLabel').innerText = "Corte: #" + objPivotDayResult.Id;
        }
        else {
            objPivotDate.disabled = false;
            objIdGameinfo.disabled = false;
            objDays.disabled = false;
            objIdParam.disabled = false;
            objIsProcessed.disabled = true;
            document.getElementById('PivotForm').reset();
            document.getElementById('modalTicketLabel').innerText = "Nuevo Corte";
        }

        new bootstrap.Modal(objmodalPivot, { backdrop: 'static' }).show();
    }

    DeletePivotDay(objRow) {

        new JFMUI.PopUpConfirm_JS('¿Esta seguro de eliminar el corte?', 'corte', this.Icon).show(
            () => {
                let objData = new DataAdmin();
                objData.Body = JSON.stringify(objRow.PivotDayResult);

                new AJAXKBB().callController('/PivotDay/DeletePivotDay', objData, (dataR) => {
                    objData.setDataFromJSON(dataR);
                    if (objData.IsSuccessful) {
                        new JFMUI.PopUpAlerts_JS('Se ha eliminado el corte #' + objRow.PivotDayResult.Id + ' exitosamente.', 'Corte Por semana', new JFMUI.Icon_JS({ type: JFMUI.CONST.ICONS.SUCCESS, width: 36, height: 36 }), undefined, undefined, true).show();
                        setTimeout(() => location.reload(true), 2000);
                    }
                    else {
                        DisplayError.show('Error', objData.strErrorMessage);
                    }
                }, true);
            });
    }

    SubmitAddForm() {

    }

    static EditPivotDayEventLister(objThis, objButton, objRow) {
        objButton.addEventListener('click', function (event) {
            objThis.EditPivotDay(objRow);
        }, false);
    }

    static DeletePivotDayEventLister(objThis, objButton, objRow) {
        objButton.addEventListener('click', function (event) {
            objThis.DeletePivotDay(objRow);
        }, false);
    }
}

window.addEventListener('load', function () {
    new AdminPivotDay();
}, false)