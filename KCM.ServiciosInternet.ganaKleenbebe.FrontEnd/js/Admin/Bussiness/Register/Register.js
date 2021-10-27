class Register {
    constructor() {
        this.Form = new JFMUI.Forms_JS({
            selector: '#AdminLogin',
            onErrorField: (field) => {
                field.style.boxShadow = 'inset 0px 0px 5px red';
            },
            onValidField: (field) => {
                field.style.boxShadow = 'initial';
            },
            isSubmitEnable: true,
            recaptcha: new JFMUI.GrecaptchaV2_JS(grecaptcha,
                {
                    selector: 'JFMLOGIN_Recaptcha',
                    siteKey: strGlobalSiteKey
                }
            ),
            //onSubmit: function (event) {
            //    fnSubmit(event);
            //    return false;
            //}
            onSuccess: function (dataR) {
                let objData = new DataAdmin();
                objData.setDataFromJSON(dataR);
                if (objData.IsSuccessful) {
                    location.href = objData.Body;
                }

                let objMsg = this.Form.querySelector('[data-msg-error="true"]');
                if (!!objMsg) {
                    objMsg.innerText = objData.strErrorMessage;
                }
                this.Recaptcha.reset();
            },
            onFailure: DisplayError.show,
        })
    }

    static main() {
        let objReg = new Register();
    }
}


function main() {
    Register.main();
}

window.addEventListener('load', function () {
    JFMUI.GrecaptchaV2_JS.addLibrary(main)
}, false)