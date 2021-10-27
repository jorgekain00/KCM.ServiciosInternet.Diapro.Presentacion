/// <reference path="../../../jfm.ui.js" />
class Ticket {
    constructor(objSSOData) {
        let objticketUID = document.querySelector('form #ticketUID'),
            objticketFirstName = document.querySelector('form #ticketFirstName '),
            objticketLastName = document.querySelector('form #ticketLastName  '),
            objticketEmail = document.querySelector('form #ticketEmail     '),
            objticketBirthYear = document.querySelector('form #ticketBirthYear '),
            objticketBirthMonth = document.querySelector('form #ticketBirthMonth'),
            objticketBirthDay = document.querySelector('form #ticketBirthDay  '),
            objticketCellPhone = document.querySelector('form #ticketCellPhone '),
            objGamer = document.querySelector('.gamenameText > h2'),
            objProfile = JSON.parse(objSSOData.Profile);

        if (!!objticketUID) {
            objticketUID.value = objSSOData.UID;    // Get the user value into the hidden field.
        }

        if (!!objticketFirstName) {
            objticketFirstName.value = objProfile.firstName;    // Get the user value into the hidden field.
        }

        if (!!objticketLastName) {
            objticketLastName.value = objProfile.lastName;    // Get the user value into the hidden field.
        }

        if (!!objticketEmail) {
            objticketEmail.value = objProfile.email;    // Get the user value into the hidden field.
        }

        if (!!objticketBirthYear) {
            objticketBirthYear.value = objProfile.birthYear;    // Get the user value into the hidden field.
        }

        if (!!objticketBirthMonth) {
            objticketBirthMonth.value = objProfile.birthMonth;    // Get the user value into the hidden field.
        }

        if (!!objticketBirthDay) {
            objticketBirthDay.value = objProfile.birthDay;    // Get the user value into the hidden field.
        }

        if (!!objticketCellPhone) {
            objticketCellPhone.value = objProfile.phones.number;    // Get the user value into the hidden field.
        }

        if (!!objGamer) {
            objGamer.innerText = objProfile.firstName.substring(0, 1).toUpperCase() + objProfile.firstName.substring(1).toLowerCase();   // Display the name of the gamer
        }

        this.strUID = objSSOData.UID;     // set the UID param before start ajax request

        this.objAJAXLoader = new JFMUI.AJAXLoader({
            id: 'LoadingTicket',
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
    /**
    * @description Evaluate the user attempts, if attempts are equal to zero the display the ticket Form else Display the pending attempts
    */
    evaluateAttemps() {
        let objThis = this,
            objData = new DataKBB()

        objData.strUID = this.strUID;
        new AJAXKBB().callController('/Ticket/getAttemps', objData, (dataR) => {
            let objData = new DataKBB(),
                intAttemps = 0;
            objData.setDataFromJSON(dataR);
            if (objData.IsSuccessful) {
                if (!isNaN(objData.Body)) {
                    intAttemps = objData.Body;
                    if (intAttemps == 0) {
                        objThis.DisplayTicketForm();
                    }
                    else {
                        objThis.DisplayGetAttempsView()
                    }
                }
            }
            else {
                DisplayError.show('Error', objData.strErrorMessage);
            }
        }, false);
    }
    /**
    * @description Display the view attemps
    */
    DisplayGetAttempsView() {
        let objData = new DataKBB();
        objData.strUID = this.strUID;

        new AJAXKBB().callController('/Ticket/getAttempstView', objData, (strView) => {
            let objParent = document.forms[0].parentNode;
            if (objParent) {
                objParent.innerText = '';
                objParent.insertAdjacentHTML('beforeend', strView);
            }
        }, true);
    }

    /**
    * @description Display the ticket form
    */
    DisplayTicketForm() {
        let objThis = this,
            // Form Ticket options
            objFormsOptions = {
                selector: '#ticketForm',
                confirm: '¿Estan correctos los datos?',
                method: 'Post',
                url: '/Ticket/registerTicket',
                onBegin: () => {
                    objThis.objAJAXLoader.displayBoxLoading('block');
                },
                onComplete: () => {
                    objThis.objAJAXLoader.displayBoxLoading('none');
                },
                onSuccess: function (dataR) {
                    let objData = new DataKBB();
                    objData.setDataFromJSON(dataR);
                    if (objData.IsSuccessful) {
                        let strMessage = `<p>Ahora tienes más oportunidades de ganar.</p><p>Recuerda que etapas:<br> Recién nacido, chico y mediano <span>¡dan una oportunidad extra!</span></p>`;
                        new JFMUI.PopUpAlerts_JS(strMessage, '¡Ticket registrado!', new JFMUI.Icon_JS({ type: JFMUI.CONST.ICONS.CONFIRM, width: 36, height: 36 }), undefined, undefined, true).show();
                        objThis.DisplayGetAttempsView();
                    }
                    else {
                        let objMsg = this.Form.querySelector('[data-msg-error="true"]');
                        if (!!objMsg) {
                            objMsg.innerText = objData.strErrorMessage;
                        }
                        this.Recaptcha.reset();
                    }
                },
                onFailure: DisplayError.show,
                onSubmit: null,
                onErrorField: (field) => {
                    field.style.boxShadow = 'inset 0px 0px 5px red';
                    field.focus();
                },
                onValidField: (field) => {
                    field.style.boxShadow = 'initial';
                },
                isSubmitEnable: true,
                icon: new JFMUI.Icon_JS({ type: JFMUI.CONST.ICONS.CONFIRM, width: 36, height: 36 }),
                recaptcha: new JFMUI.GrecaptchaV2_JS(grecaptcha, { selector: 'gigyaJFMsignUprecaptcha', siteKey: strGlobalRecaptchaSiteKey })
            };

        new JFMUI.Forms_JS(objFormsOptions);
    }

    static main(event) {
        if (event.detail.Route.isSuccessful && event.detail.Data.isSuccessful) {
            new Ticket(event.detail.Data).evaluateAttemps();
        }
        window.removeEventListener('SSO.GetSession', Ticket.main);
    }
}


window.addEventListener('SSO.GetSession', Ticket.main, false);
