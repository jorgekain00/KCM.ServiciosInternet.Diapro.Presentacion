/**
 * @fileoverview classes for UI functions (uses bootstrap V5)
 *
 * @version                               1.1
 *
 * @author       Eng. Jorge Flores Miguel
 * @copyright         jorge_kain@yahoo.com
 *
 * History
 * v1.1 – 
 * ----
 *
 *  date          Classes                                  description
 *  ----------    ------------------------------------     --------------------------------------------------------------------
 *  2021/07/21     JFM.AJAXCommunications_JS                Establish AJAX communications.
 *  2021/07/21     JFM.Forms_JS                             Process the form - evaluate the form - add a recaptcha object - submit the for via AJAX.
 *  2021/07/21     JFM.Recaptcha                            Recaptcha object.
 *  2021/07/21     JFM.GrecaptchaV2_JS                      Google recaptcha V2 object.
 *  2021/07/21     JFM.Icon_JS                              Build a html span icon object.
 *  2021/07/21     JFM.PopUpAlerts_JS                       Show A PopUp Alert Dialog.
 *  2021/07/21     JFM.PopUpConfirm_JS                      Show A PopUp Confirm Dialog.
 *  2021/07/21     JFM.ValidationClasses                    Regular Expresion classes.
 *  2021/07/21     JFM.ValidationForm_JS                    Validation control for a Form.
 *  2021/07/21     JFM.ValidationMethods_JS                 Different testing cases for a Form field.
 */
// ROOT OBJECT
let JFM = {
    CONST: {}
};
// #region CONSTANTS VALUES

// values for AJAX contentType header 
JFM.CONST.CONTENTTYPE = {
    FORM: 'application/x-www-form-urlencoded; charset=UTF-8',
    FILEFORM: 'multipart/form-data',
    JSON: 'application/json',
    XML: 'text/xml',
    TEXT: 'text/html; charset=utf-8'
};
// Ajax FETCH modes
JFM.CONST.FETCHMODES = {
    SAMEORIGIN: 'same-origin',
    CORS: 'cors'
};
// Types of icons for PopUp Messages
JFM.CONST.ICONS = {
    INFO: 'INFO',
    WARNING: 'WARNING',
    DANGER: 'DANGER',
    SUCCESS: 'SUCCESS',
    CONFIRM: 'CONFIRM'
};
// MVC NET AJAXFORM REPLACE MODES
JFM.CONST.REPLACEMODE = {
    REPLACE: 'REPLACE',
    INSERTAFTER: 'AFTER',
    INSERTBEFORE: 'BEFORE'
};
// #endregion
// #region AJAX OPERATIONS
/**
 * @class
 * @classdesc Establish AJAX communications.
 * @author Eng. Jorge Flores Miguel   jorgekain00@gmail.com July 2021.
 */
JFM.AJAXCommunications_JS = class {
    /**
     * @param {{type: string, url:string, data: object, mode: string, contentType: string, successFunction: Function, errorFunction: Function, beforeSendFunction: Function, completeFunction: Function }} paramOptions {type: get or post, url: remote site, data: data to send, mode: JFM.CONST.FETCHMODES values, contentType: JFM.CONST.CONTENTTYPE values, successFunction: fn(dataR), errorFunction: fn(strMsg, statusText), beforeSendFunction: fn(), completeFunction: fn() }
     */
    constructor(paramOptions) {
        let objDefaultOptions = {
            type: 'get',
            url: null,
            data: null,
            mode: JFM.CONST.FETCHMODES.SAMEORIGIN,
            contentType: JFM.CONST.CONTENTTYPE.FORM,
            successFunction: null,
            errorFunction: null,
            beforeSendFunction: null,
            completeFunction: null
        };
        this.objOptions = Object.assign({}, objDefaultOptions, paramOptions);
    }
    /**
     * @description send the object via AJAX
     */
    async AsyncSend() {

        let objAJAX = this;

        let fetchOptions = {
            method: this.objOptions.type,
            body: this.objOptions.data
        };

        // Add the headers
        if (this.objOptions.contentType && this.objOptions.contentType.toLowerCase().indexOf(JFM.CONST.CONTENTTYPE.FILEFORM) == -1) {
            fetchOptions.headers = {
                "Content-type": this.objOptions.contentType
            };
        }

        if (this.objOptions.beforeSendFunction) {
            this.objOptions.beforeSendFunction();
        }

        fetch(this.objOptions.url, fetchOptions
        ).then(objR => {
            if (objR.ok) {
                return objR
            }
            else {
                Promise.reject(objR)
            }
        }).then(objR => {

            let dataType = objR.headers.get('Content-Type');

            if (dataType) {
                if (dataType.indexOf("application/json") !== -1) {
                    return objR.json();
                }
                else if (dataType.indexOf("text/html") !== -1) {
                    return objR.text();
                }
            }

        }).then(dataR => {
            if (this.objOptions.successFunction) {
                this.objOptions.successFunction(dataR)
            }
        }).catch(async function (objR) {
            if (objAJAX.objOptions.errorFunction) {
                if (objR && objR.message) {
                    let strMsg = objR.message,
                        strStack = objR.stack;
                    objAJAX.objOptions.errorFunction(strMsg, strStack);
                }
            }
        }).finally(() => {
            if (this.objOptions.completeFunction) {
                this.objOptions.completeFunction()
            }
        })

    }
}
// #endregion
// #region FORMS
//#region RECAPTCHA
/**
 * @class
 * @classdesc Recaptcha object.
 * @author Eng. Jorge Flores Miguel   jorgekain00@gmail.com July 2021.
 */
JFM.Recaptcha = class {
    callback() { }
    getResponse() { }
    reset() { }
    isValid() { }
    set RecaptchaValue(strToken) {
        this._strRecaptchaValue = strToken;
    }
    get RecaptchaValue() {
        return this._strRecaptchaValue;
    }
}
/**
 * @class
 * @classdesc Google recaptcha V2 object.
 * @author Eng. Jorge Flores Miguel   jorgekain00@gmail.com July 2021.
 * @augments JFM.Recaptcha.
 */
JFM.GrecaptchaV2_JS = class extends JFM.Recaptcha {
    /**
     * @param {object} grecaptcha  Google object
     * @param {{selector: {string}, siteKey: {string}, theme: {string}, size: {string}, tabindex: {number}, callback: {Function}, expiredCallback: {Function}, errorCallback: {Function}, badge: {string}, isolated: {boolean}, isInvisible: {boolean}, formField: {Object}, errorMessage: {string} }} paramOptions {{selector: A container for the recaptcha, siteKey: Id to the render the recaptcha, theme: theme for the recaptcha, size: size for the recaptcha, or invisble, tabindex: tab index, callback: Execute a method on a successful recaptcha, expiredCallback: execute a method on an expired recaptcha, errorCallback: execute a method on an error recaptcha, badge: (invisible only) position of the recaptcha, isolated: (invisible only), isInvisible: True for an invisible recaptcha, formField: A form field that saves the recaptcha value , errorMessage: an error message on unsuccessful recaptcha}
     */
    constructor(grecaptcha, paramOptions) {

        if (!grecaptcha) {
            throw new Error('Missing libs for Google grecaptcha');
        }

        let opt_widget_id = null; // id for the recaptcha

        let objDefaultOptions = {
            selector: null,
            siteKey: null,
            theme: null,
            size: null,
            tabindex: null,
            callback: null,
            expiredCallback: null,
            errorCallback: null,
            badge: null,
            isolated: false,
            isInvisible: false,
            formField: null,
            errorMessage: ''
        }

        let grecaptchaOptions = {
            ...objDefaultOptions,
            ...paramOptions
        }

        if (grecaptchaOptions.selector && grecaptchaOptions.siteKey) {
            super();
            this.GrecaptchaFunction = grecaptcha;
            this.IsInvisible = grecaptchaOptions.isInvisible;
            this.FormField = grecaptchaOptions.formField;
            this.ErrorMessage = grecaptchaOptions.errorMessage;

            if (this.IsInvisible) {
                opt_widget_id = grecaptcha.render(grecaptchaOptions.selector, {
                    'sitekey': grecaptchaOptions.siteKey,
                    'badge': !!grecaptchaOptions.badge ? grecaptchaOptions.badge : 'bottomright',
                    'size': 'invisible',
                    'tabindex': !!grecaptchaOptions.tabindex ? grecaptchaOptions.tabindex : 0,
                    'callback': this.callback(),
                    'expired-callback': !!grecaptchaOptions.expiredCallback ? grecaptchaOptions.expiredCallback : null,
                    'error-Recaptchacallback': !!grecaptchaOptions.errorCallback ? grecaptchaOptions.errorCallback : null,
                    'isolated': grecaptchaOptions.isolated
                });
            }
            else {
                opt_widget_id = grecaptcha.render(grecaptchaOptions.selector, {
                    'sitekey': grecaptchaOptions.siteKey,
                    'theme': !!grecaptchaOptions.theme ? grecaptchaOptions.theme : 'light',
                    'size': !!grecaptchaOptions.size ? grecaptchaOptions.size : 'normal',
                    'tabindex': !!grecaptchaOptions.tabindex ? grecaptchaOptions.tabindex : 0,
                    'callback': this.callback(),
                    'expired-callback': !!grecaptchaOptions.expiredCallback ? grecaptchaOptions.expiredCallback : null,
                    'error-callback': !!grecaptchaOptions.errorCallback ? grecaptchaOptions.errorCallback : null
                });
            }
            this.Grecaptcha = {
                widget_id: opt_widget_id,
                parameters: grecaptchaOptions
            };
            this.RecaptchaValue = '';
        }
        else {
            throw new Error('Missing params: selector or sitekey for Google grecaptcha');
        }
    }
    // #region PUBLIC PROPERTIES
    /**
     * @property {string} set Recaptcha value
     */
    set RecaptchaValue(strToken) {
        this._strRecaptchaValue = strToken;
        if (this.FormField) {
            this.FormField.value = strToken;
        }
    }
    /**
     * @property {string} get Recaptcha value
     */
    get RecaptchaValue() {
        return this._strRecaptchaValue;
    }
    // #endregion
    // #region PUBLIC METHODS
    /**
     * @description update the recaptcha value and send the recaptcha token to the callback parameter function
     * @returns {Function} callback parameter function
     */
    callback() {
        let objThis = this;

        return function (token) {
            objThis.RecaptchaValue = token;
            if (objThis.Grecaptcha.parameters.callback) {
                objThis.Grecaptcha.parameters.callback(token);
            }
        };
    }
    /**
     * @description get the Recaptcha response value
     * @returns {string} Recaptcha value
     */
    getResponse() {
        if (this.IsInvisible) {
            this.GrecaptchaFunction.execute(this.Grecaptcha.widget_id);
        }
        this.RecaptchaValue = this.GrecaptchaFunction.getResponse(this.Grecaptcha.widget_id);
        return this.RecaptchaValue;
    }
    /**
     * @description reset the recaptcha
     */
    reset() {
        this.GrecaptchaFunction.reset(this.Grecaptcha.widget_id);
    }
    /**
     * @description true for valid recaptcha
     * @returns {boolean} 
     */
    isValid() {
        return this.RecaptchaValue.length > 0;
    }
    // #endregion
}
//#endregion
/**
 * @class
 * @classdesc Validation control for a Form.
 * @author Eng. Jorge Flores Miguel   jorgekain00@gmail.com July 2021
 */
JFM.ValidationForm_JS = class {
    /**
     * 
     * @param {object} objForm Forms_JS object
     * @param {string} strEventsToValidateByField a list of events separated by space (events that launch a validation routine).
     * @param {Function} OnErrorField A method that executes when a field has an error.
     * @param {Function} OnValidField A method that executes when a field passes the validation.
     * @param {Function} validationClass An identifier for the class that will execute the validation control.
     */
    constructor(objForm, strEventsToValidateByField, OnErrorField, OnValidField, validationClass = JFM.ValidationMethods_JS) {
        if (objForm && objForm.Form.tagName.toUpperCase() == "FORM" && objForm.Fields.length > 0) {
            this.FormJs = objForm;
            this.OnErrorField = OnErrorField;
            this.OnValidField = OnValidField;
            this.IsValid = false;
            this.ValidationMethods = new validationClass();
            this.Fields = objForm.Fields;
            this.addEventToEvalForm(strEventsToValidateByField);
        }
        else {
            throw new Error('missing Form Tag or zero child elements : ValidationForm_JS > constructor')
        }
    }
    /**
     * @property {object} set recaptcha object
     */
    set Recaptcha(objRecaptcha) {
        if (typeof objRecaptcha == 'object' && objRecaptcha instanceof JFM.Recaptcha) {
            this._GRecaptcha = objRecaptcha;
        }
    }
    /**
     * @property {object} get recaptcha object
     */
    get Recaptcha() {
        return this._GRecaptcha;
    }
    /**
     * @description validate a form for each validation methods
     * @param {object} event 
     * @returns {object} an object Map that saves all errors
     */
    evalForm(event) {
        this.IsValid = true;
        let objMapErrors = new Map();    // object to save all errors

        // Clean all error messages
        this.FormJs.Form.querySelectorAll('[data-valmsg-for]').forEach((objItem) => objItem.innerHTML = '');
        //check every field in the form
        this.Fields.forEach((objItem) => {
            let objValMsgfor = this.FormJs.Form.querySelector('[data-valmsg-for="' + objItem.name + '"]');

            for (let f in this.ValidationMethods) {
                if (typeof this.ValidationMethods[f] == 'function') {
                    let strErrorMessage = this.ValidationMethods[f](objItem);
                    if (strErrorMessage) {
                        if (objValMsgfor) {
                            objValMsgfor.innerText = strErrorMessage;
                        }
                        objMapErrors.set(objItem, strErrorMessage);
                        this.IsValid = false;

                        if (this.OnErrorField) {
                            this.OnErrorField(objItem);
                        }
                        return;
                    }
                }
            }
        });
        // check Recaptcha is valid
        if (this.Recaptcha) {
            let objValMsgfor = this.FormJs.Form.querySelector('[data-valmsg-for="' + this.Recaptcha.FormField.name + '"]');
            if (objValMsgfor) {  // Look for a input field that holds the recaptcha value
                objValMsgfor.innerText = ''; // Clean Previous Error
            }
            if (!this.Recaptcha.isValid()) {
                let strErrorMessage = '';

                if (this.Recaptcha.FormField) {
                    strErrorMessage = this.Recaptcha.FormField.dataset.recaptchaValue;
                }
                else {
                    strErrorMessage = this.Recaptcha.ErrorMessage;
                }
                if (strErrorMessage) {
                    if (objValMsgfor) {
                        objValMsgfor.innerText = strErrorMessage;
                    }
                    objMapErrors.set(this.Recaptcha, strErrorMessage);
                }
                this.IsValid = false;
            }
        }

        return objMapErrors;
    }
    /**
     * @description validate a field for each validation methods
     * @param {object} event 
     * @returns {boolen} True for valid field
     */
    evalField(event) {
        /*
        * validate individual field
        */
        let objCurrentField = event.currentTarget,  // current field
            objValMsgfor = this.FormJs.Form.querySelector('[data-valmsg-for="' + objCurrentField.name + '"]');

        if (objValMsgfor) {
            objValMsgfor.innerText = '';  // Clean error message
        }

        // Loop for every validation method
        for (let f in this.ValidationMethods) {
            if (typeof this.ValidationMethods[f] == 'function') {
                let strErrorMessage = this.ValidationMethods[f](objCurrentField);
                if (strErrorMessage) {
                    if (objValMsgfor) {
                        objValMsgfor.innerText = strErrorMessage;
                    }

                    if (this.OnErrorField) {
                        this.OnErrorField(objCurrentField);   // execute a method when this field has an error
                    }
                    return false;
                }
            }
        }

        if (this.OnValidField) {
            this.OnValidField(objCurrentField); // execute a method when this field is valid
        }
        return true;
    }
    /**
     * @description Add a listener for validation field for each specified event
     * @param {string} strEvents A list of events separated by space 
     */
    addEventToEvalForm(strEvents) {
        let objValidationForm = this;

        strEvents.split(' ').forEach(e => {
            objValidationForm.Fields.forEach(objField => {
                objField.addEventListener(e, (event) => objValidationForm.evalField(event), false);
            });
        });
    }
}
//#region  VALIDATIONS CLASSES
/**
 * @class
 * @classdesc Different testing cases for a Form field.
 * @author Eng. Jorge Flores Miguel   jorgekain00@gmail.com July 2021
 */
JFM.ValidationMethods_JS = class {
    /**
     * @description test a field for an empty field
     * @param {object} objItem a Form field
     * @returns string  Error message
     */
    RequiredFieldEval = (objItem) => {
        let strValRequired = objItem.dataset.valRequired;
        if (strValRequired) {
            if (objItem.value == '') {
                return strValRequired;

            }
        }
        return '';
    }
    /**
     * @description test a field for a specific regular expression
     * @param {object} objItem a Form field
     * @returns string  Error message
     */
    eRegularExpressionEval = (objItem) => {
        let strExpRegex = objItem.dataset.valRegexPattern;
        if (strExpRegex) {
            let objRegExp = new RegExp(strExpRegex);
            if (!objRegExp.test(objItem.value)) {
                return objItem.dataset.valRegex;
            }
        }
        return '';
    }
    /**
     * @description test a field for a max length
     * @param {object} objItem a Form field
     * @returns string  Error message
     */
    LengthMaxEval = (objItem) => {
        let strValLengthMax = objItem.dataset.valLengthMax;
        if (strValLengthMax) {
            if (objItem.value.length > parseInt(strValLengthMax)) {
                return objItem.dataset.valLength;
            }
        }
        return '';
    }
    /**
     * @description test a field for a valid email
     * @param {object} objItem a Form field
     * @returns string  Error message
     */
    MailfieldEval = (objItem) => {
        let strvalEmail = objItem.dataset.valEmail;
        if (strvalEmail) {
            if (!JFM.ValidationClasses.EmailRegExp.test(objItem.value)) {
                return strvalEmail;
            }
        }
        return '';
    }
}
/**
 * @class
 * @classdesc Regular Expresion classes.
 * @author Eng. Jorge Flores Miguel   jorgekain00@gmail.com July 2021
 */
JFM.ValidationClasses = class {
    static EmailRegExp = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
}
//#endregion
/**
 * @class
 * @classdesc Process the form - evaluate the form - add a recaptcha object - submit the for via AJAX.
 * @author Eng. Jorge Flores Miguel   jorgekain00@gmail.com July 2021
 */
JFM.Forms_JS = class {
    /**
     * 
     * @param {{selector : {string, Object}, confirm: {string}, insertionMode: {string}, loadingElementId: {string}, method:{string}, url: {string}, updateTargetId: {string}, eventsToValidateByField:{string}, recaptcha: {Object}, onBegin:{Function}, onComplete:{Function}, onSuccess: {Function}, onFailure: {Function}, onSubmit:{Function}, onErrorField:{Function},  onValidField:{Function} ,isSubmitEnable:{bool}, icon: {Object}, sanitizer : {Function}}} paramOptions {selector: selector or Form object, confirm: confirm message before send the form, insertionMode: JFM.CONST.REPLACEMODE type of replacement html response, loadingElementId: HTML object that it displays before establish ajax communications, method: post or get method, url: destination address,  updateTargetId: location where to insert the HTML response, eventsToValidateByField: binds an event to a invalid field, recaptcha : recaptcha object extends JFM.Recaptcha, onBegin: it executes a function before AJAX communications, onComplete: it executesa function after AJAX communications, onSuccess: it executes afunction after AJAX successful operation, onFailure: it executes a function if an error ocurred in the AJAX communications, onSubmit: it executes a function before submit the form - must return true otherwise the process is cancelled, onErrorField: it executes a function on an specific invalid field, onValidField: it executes a function if the field is valid, isSubmitEnable: enable/disable the submit button, icon: An Icon_JS object for the Popup object, sanitizer: a function that sanitizes a string (in this case a Form Field)}
     */
    constructor(paramOptions) {
        let objDefaultOptions = {
            selector: null,
            confirm: '',
            insertionMode: '',
            loadingElementId: '',
            method: 'Post',
            url: '',
            updateTargetId: '',
            eventsToValidateByField: 'change',
            recaptcha: null,
            onBegin: null,
            onComplete: null,
            onSuccess: null,
            onFailure: null,
            onSubmit: null,
            onErrorField: null,
            onValidField: null,
            isSubmitEnable: true,
            icon: new JFM.Icon_JS({ type: JFM.CONST.ICONS.CONFIRM, width: 46, height: 46 }),
            sanitizer: null
        }

        let Options = {
            ...objDefaultOptions,
            ...paramOptions
        }

        // get object Form
        if (typeof Options.selector == 'object') {
            this.Form = Options.selector;
        }
        else if (typeof Options.selector == 'string') {
            this.Form = document.querySelector(Options.selector);
        }
        else {
            throw new Error('Invalid options: selector. Missing value. ');
        }

        this.Confirm = !!Options.confirm ? Options.confirm : this.Form.dataset.ajaxConfirm;
        this.InsertionMode = !!Options.insertionMode ? Options.insertionMode : this.Form.dataset.ajaxMode;
        this.LoadingElementId = !!Options.loadingElementId ? Options.loadingElementId : this.Form.dataset.ajaxLoading;
        this.Method = !!Options.method ? Options.method : this.Form.dataset.ajaxMethod;
        this.UpdateTargetId = !!Options.updateTargetId ? Options.updateTargetId : this.Form.dataset.ajaxUpdate;

        // public properties
        this.Url = !!Options.url ? Options.url : this.Form.action;
        this.IsSubmitEnable = Options.isSubmitEnable;
        this.Fields = this.Form.querySelectorAll('[data-val="true"]');
        this.Icon = Options.icon;
        if (!this.Fields) {
            throw new Error('Invalid options: selector. Form object does not have fields to validate: [data-val="true"]');
        }

        this.OnBegin = !!Options.onBegin ? Options.onBegin : eval(this.Form.dataset.ajaxBegin);
        this.OnComplete = !!Options.onComplete ? Options.onComplete : eval(this.Form.dataset.ajaxComplete);
        this.OnSuccess = !!Options.onSuccess ? Options.onSuccess : eval(this.Form.dataset.ajaxSuccess);
        this.OnFailure = !!Options.onFailure ? Options.onFailure : eval(this.Form.dataset.ajaxFailure);
        this.OnSubmit = Options.onSubmit;

        this.ValidationForm = new JFM.ValidationForm_JS(this, Options.eventsToValidateByField, Options.onErrorField, Options.onValidField);
        this.Recaptcha = Options.recaptcha;
        this.Sanitizer = Options.sanitizer;
        this.addSubmitEvent();
    }
    /**
     * @description  binds a submit event that execute an Optional OnSubmit method, finally send the form via AJAX
     */
    addSubmitEvent() {
        let objThis = this;
        objThis.Form.addEventListener('submit', (event) => {
            if (objThis.Confirm) {
                // show a PopUp Confirm message then evaluate the form and finally execute a OnSubmit method
                new JFM.PopUpConfirm_JS(objThis.Confirm, '', this.Icon).show(() => {
                    if (objThis.startValidationForm(event)) {
                        objThis.sendFormDataAjax();
                    }
                });
            }
            else {
                if (objThis.startValidationForm(event)) {
                    objThis.sendFormDataAjax();
                }
            }
            event.preventDefault();
            return false;
        });
    }
    /**
     * @param {object} event object inherit by the submit event
     * @returns {Boolean} True for successful Validation
     */
    startValidationForm(event) {
        event.MapErrors = this.ValidationForm.evalForm(event);
        event.IsValid = this.ValidationForm.IsValid;
        event.Fields = this.sanitizeFields();
        if (event.IsValid && this.OnSubmit) {
            return !!this.OnSubmit(event);
        }
        else {
            return this.ValidationForm.IsValid;
        }
    }
    /**
     * @returns {HTMLAllCollection} collection of sanitized fields
     * */
    sanitizeFields() {
        let sanitizeToString = (this.Sanitizer && typeof this.Sanitizer == 'function') ? this.Sanitizer : new JFM.Sanitizer().sanitizeToString;
        this.Fields.forEach(f => {
            if (f.value) {
                f.value = sanitizeToString(f.value);
            }
        });
        return this.Fields;
    }

    /**
     * @description set if the form is can be submitted
     */
    set IsSubmitEnable(isSubmitEnable) {
        this.Form.querySelector('[type="submit"]').disabled = !isSubmitEnable; // disble submit button
        this._isSubmitEnable = isSubmitEnable;
    }
    /**
     * @description get if the form is can be submitted
     */
    get IsSubmitEnable() {
        return this._isSubmitEnable;
    }
    /**
     * @property {object} objRecaptcha   Recaptcha object that extends JFM.Recaptcha
     */
    set Recaptcha(objRecaptcha) {
        if (typeof objRecaptcha == 'object' && objRecaptcha instanceof JFM.Recaptcha) {
            // get the input Field that will holds recaptcha value
            if (!objRecaptcha.FormField) {
                objRecaptcha.FormField = this.Form.querySelector('input[data-recaptcha-value]');
            }

            this._GRecaptcha = objRecaptcha;
            this.ValidationForm.Recaptcha = objRecaptcha;
        }
    }
    /**
    * @property {object} objRecaptcha   Recaptcha object that extends JFM.Recaptcha
    */
    get Recaptcha() {
        return this._GRecaptcha;
    }
    /**
     * @description Evaluate if InsertionMode has correct values : INSERT, AFTER, BEFORE
     * @returns True for valid InsertionMode
     */
    isInsertionModeValid() {
        if (this.InsertionMode) {
            let strInsertionMode = this.InsertionMode.toUpperCase();
            return strInsertionMode == JFM.CONST.REPLACEMODE.INSERTAFTER
                || strInsertionMode == JFM.CONST.REPLACEMODE.INSERTBEFORE
                || strInsertionMode.includes(JFM.CONST.REPLACEMODE.REPLACE);
        }
        return false;
    }
    /**
     * @description send the form via Ajax 
     * @param {{type: string, url : string, data : object, mode: string, contentType :string}} paramOptions {type: post or get method, url : ajax url, data : data to send, mode: JFM.CONST.FETCHMODES, contentType :JFM.CONST.CONTENTTY}
     */
    sendAjax(paramOptions) {
        let objForm = this;

        // Build the AJAX connection
        new JFM.AJAXCommunications_JS({
            type: paramOptions.type,
            url: paramOptions.url,
            data: paramOptions.data,
            mode: paramOptions.mode,
            contentType: paramOptions.contentType,
            successFunction: (dataR) => {
                if (objForm.isInsertionModeValid()) {
                    let objHTML = document.querySelector(objForm.UpdateTargetId);
                    if (objHTML) {
                        if (objForm.InsertionMode.toUpperCase() == JFM.CONST.REPLACEMODE.INSERTAFTER) {
                            objHTML = objHTML.nextSibling;
                        }
                        else if (objForm.InsertionMode.toUpperCase() == JFM.CONST.REPLACEMODE.INSERTBEFORE) {
                            objHTML = objHTML.previousSibling;
                        }
                        if (objHTML) {
                            /*
                             * Replace the element (objHTML) by the partialView(mvc) or HTML code
                             * then rerun all the inline scripts
                             */
                            objHTML.innerHTML = dataR;
                            objHTML.querySelectorAll('script').forEach((scr) => {
                                eval(scr.innerHTML);
                            });
                        }
                    }
                }
                if (objForm.OnSuccess) {
                    objForm.OnSuccess(dataR);
                }
            },
            errorFunction: (strMsg, statusText) => {
                if (objForm.OnFailure) {
                    objForm.OnFailure(strMsg, statusText);
                }
            },
            beforeSendFunction: () => {
                let objLoading = document.querySelector(objForm.LoadingElementId);
                if (objLoading) {
                    objLoading.style.display = 'initial'
                }
                if (objForm.OnBegin) {
                    objForm.OnBegin();
                }
            },
            completeFunction: () => {
                let objLoading = document.querySelector(objForm.LoadingElementId);
                if (objLoading) {
                    objLoading.style.display = 'none'
                }
                if (objForm.OnComplete) {
                    objForm.OnComplete();
                }
            }
        }).AsyncSend();
    }
    /**
    * @description send the form via AJAX FormData Object
    */
    sendFormDataAjax() {
        this.sendAjax({
            type: this.Method,
            url: this.Url,
            data: new FormData(this.Form),
            mode: JFM.CONST.FETCHMODES.SAMEORIGIN,
            contentType: JFM.CONST.CONTENTTYPE.FILEFORM
        });
    }
}
// #endregion
// #region POPUP
/**
 * @class
 * @classdesc Build a html span icon object.
 * @author Eng. Jorge Flores Miguel   jorgekain00@gmail.com July 2021
 */
JFM.Icon_JS = class {
    /**
     * 
     * @param {{color: string, width: number, height : number, type: object }} paramOptions {color : color for the Icon, width: width measures in pixels, height: height measures in pixels, type : type of Icon}
     */
    constructor(paramOptions) {
        let objOptions = {
            color: '',
            width: 16,
            height: 16,
            type: JFM.CONST.ICONS.INFO,
            ...paramOptions
        }
        this.Color = objOptions.color;
        this.Width = objOptions.width;
        this.Height = objOptions.height;
        this.Type = objOptions.type;
        this.generateAutoTemplate();
    }
    /**
     * @description (private method don't use it) generate the default template based in Type Property(JFM.CONST.ICON)
     */
    generateAutoTemplate() {
        let strColor = ''
        switch (this.Type) {
            case JFM.CONST.ICONS.WARNING:
                this.strTemplate = `<svg xmlns="http://www.w3.org/2000/svg" width="${this.Width}" height="${this.Height}" fill="currentColor" class="bi bi-exclamation-triangle-fill" viewBox="0 0 16 16">
            <path d="M8.982 1.566a1.13 1.13 0 0 0-1.96 0L.165 13.233c-.457.778.091 1.767.98 1.767h13.713c.889 0 1.438-.99.98-1.767L8.982 1.566zM8 5c.535 0 .954.462.9.995l-.35 3.507a.552.552 0 0 1-1.1 0L7.1 5.995A.905.905 0 0 1 8 5zm.002 6a1 1 0 1 1 0 2 1 1 0 0 1 0-2z"/>
          </svg>`;
                strColor = '#ffcc00';
                break;
            case JFM.CONST.ICONS.DANGER:
                this.strTemplate = `<svg xmlns="http://www.w3.org/2000/svg" width="${this.Width}" height="${this.Height}" fill="currentColor" class="bi bi-x-circle-fill" viewBox="0 0 16 16">
                    <path d="M16 8A8 8 0 1 1 0 8a8 8 0 0 1 16 0zM5.354 4.646a.5.5 0 1 0-.708.708L7.293 8l-2.647 2.646a.5.5 0 0 0 .708.708L8 8.707l2.646 2.647a.5.5 0 0 0 .708-.708L8.707 8l2.647-2.646a.5.5 0 0 0-.708-.708L8 7.293 5.354 4.646z"/>
                    </svg>`;
                strColor = '#cc3300';
                break;
            case JFM.CONST.ICONS.INFO:
                this.strTemplate = `<svg xmlns="http://www.w3.org/2000/svg" width="${this.Width}" height="${this.Height}" fill="currentColor" class="bi bi-info-circle-fill" viewBox="0 0 16 16">
                        <path d="M8 16A8 8 0 1 0 8 0a8 8 0 0 0 0 16zm.93-9.412-1 4.705c-.07.34.029.533.304.533.194 0 .487-.07.686-.246l-.088.416c-.287.346-.92.598-1.465.598-.703 0-1.002-.422-.808-1.319l.738-3.468c.064-.293.006-.399-.287-.47l-.451-.081.082-.381 2.29-.287zM8 5.5a1 1 0 1 1 0-2 1 1 0 0 1 0 2z"/>
                        </svg>`;
                strColor = '#3232FF';
                break;
            case JFM.CONST.ICONS.SUCCESS:
                this.strTemplate = `<svg xmlns="http://www.w3.org/2000/svg" width="${this.Width}" height="${this.Height}" fill="currentColor" class="bi bi-check-circle-fill" viewBox="0 0 16 16">
                            <path d="M16 8A8 8 0 1 1 0 8a8 8 0 0 1 16 0zm-3.97-3.03a.75.75 0 0 0-1.08.022L7.477 9.417 5.384 7.323a.75.75 0 0 0-1.06 1.06L6.97 11.03a.75.75 0 0 0 1.079-.02l3.992-4.99a.75.75 0 0 0-.01-1.05z"/>
                            </svg>`;
                strColor = '#339900';
                break;
            case JFM.CONST.ICONS.CONFIRM:
                this.strTemplate = `<svg xmlns="http://www.w3.org/2000/svg" width="${this.Width}" height="${this.Height}" fill="currentColor" class="bi bi-question-circle-fill" viewBox="0 0 16 16">
                <path d="M16 8A8 8 0 1 1 0 8a8 8 0 0 1 16 0zM5.496 6.033h.825c.138 0 .248-.113.266-.25.09-.656.54-1.134 1.342-1.134.686 0 1.314.343 1.314 1.168 0 .635-.374.927-.965 1.371-.673.489-1.206 1.06-1.168 1.987l.003.217a.25.25 0 0 0 .25.246h.811a.25.25 0 0 0 .25-.25v-.105c0-.718.273-.927 1.01-1.486.609-.463 1.244-.977 1.244-2.056 0-1.511-1.276-2.241-2.673-2.241-1.267 0-2.655.59-2.75 2.286a.237.237 0 0 0 .241.247zm2.325 6.443c.61 0 1.029-.394 1.029-.927 0-.552-.42-.94-1.029-.94-.584 0-1.009.388-1.009.94 0 .533.425.927 1.01.927z"/>
              </svg>`;
                strColor = '#3232FF';
                break;
        }
        if (!this.Color) {
            this.Color = strColor;
        }
    }
    /**
     * @description generate the HTML Icon Object
     * @param {string} strTemplate   HTML template for the icon
     * @returns HTML DIV element with the icon
     */
    generateIcon(strTemplate) {
        if (!strTemplate) {
            strTemplate = this.strTemplate;
        }
        let objDIV = document.createElement('DIV');
        objDIV.style.color = this.Color;
        objDIV.classList.add('me-3');
        objDIV.insertAdjacentHTML('beforeend', strTemplate)
        return objDIV;
    }

}
/**
 * @class
 * @classdesc Show A PopUp Alert Dialog.
 * @author Eng. Jorge Flores Miguel   jorgekain00@gmail.com July 2021
 */
JFM.PopUpAlerts_JS = class {
    /**
     * 
     * @param {string} strMessage strMessage principal message into the PopUp dialog
     * @param {string} strHeader strHeader header message into the PopUp dialog
     * @param {object} objIcon objIcon Icon object (DANGER, WARNING, INFO, SUCCESS)
     * @param {string} strCancelButton text for the cancel button
     * @param {string} strIDModal 
     * @param {boolean} blSetSmallText True For smallText 
     */
    constructor(strMessage = '', strHeader = '', objIcon = new JFM.Icon_JS({ type: JFM.CONST.ICONS.INFO }), strCancelButton = 'Cerrar', strIDModal = 'PopUpAlerts_JS', blSetSmallText = false) {
        this.strIDModal = strIDModal;
        this.Icon = objIcon;
        this.refreshTemplate(this.strTemplate)
        this.strCancelButton = strCancelButton;
        this.strHeader = strHeader;
        this.strMessage = strMessage;
        this.IsVisible = false;
        this.SetSmallText = blSetSmallText;
    
    /**
     * @property {string}  strTemplate  html template for the dialog
     */
        this.strTemplate =
            "<div class='modal fade' tabindex='-1'>" +
            "<div class='modal-dialog'>" +
            "<div class='modal-content'>" +
            "<div class='modal-header'>" +
            "<h5 class='modal-title'>Modal title</h5>" +
            "<button type='button' class='btn-close' data-bs-dismiss='modal' aria-label='Close'></button>" +
            "</div>" +
            "<div class='modal-body d-inline-flex text-break' style='align-items:baseline'>" +
            "<div><h5 class='modal-message ms-2'>Modal body text goes here.</h5></div>" +
            "</div>" +
            "<div class='modal-footer'>" +
            "<button type='button' class='btn btn-secondary close' data-bs-dismiss='modal'>Close</button>" +
            "</div>" +
            "</div>" +
            "</div>" +
                "</div>";
    }
    /**
     * @description refresh the dialog template
     * @param {string} strTemplate html template for the entire dialog
     */
    refreshTemplate(strTemplate) {
        this.strTemplate = strTemplate;
        this.objFragmentHTML = document.createDocumentFragment();
        let objDiv = document.createElement('DIV');
        objDiv.id = this.strIDModal;
        this.objFragmentHTML.appendChild(objDiv);
        objDiv.insertAdjacentHTML("afterbegin", this.strTemplate);
    }
    /**
    * @description (don't use it private method) refresh the dialog elements  
    * */
    updateFields() {
        this.objFragmentHTML.querySelector('.modal-title').innerHTML = this.strHeader;

        let objMsg = this.objFragmentHTML.querySelector('.modal-message');
        objMsg.innerHTML = this.strMessage;
        if (this.SetSmallText) {
            objMsg.classList.add('fs-6');
        }

        this.objFragmentHTML.querySelector('.modal-footer > .close').innerHTML = this.strCancelButton;
        this.objFragmentHTML.querySelector('.modal-body').insertAdjacentElement('afterbegin', this.Icon.generateIcon());
    }
    /**
     * @description show the PopUpAlerts_JS
     */
    show() {
        this.updateFields();
        this.showPopUpAlert();
        this.IsVisible = true;
    }
    /**
     * @description (don't use it private method) show the PopUpConfirm_JS Dialog 
     * @returns {bootstrapModal} refence to the Dialog
     */
    showPopUpAlert() {
        let objThis = this;
        let objCloneFragment = this.objFragmentHTML.cloneNode(true);  // backup the dialog
        document.body.appendChild(this.objFragmentHTML);
        // Build the Dialog
        let objModal = document.querySelector('#' + this.strIDModal + ' > .modal')
        let objPopUpAlert = document.getElementById(this.strIDModal);

        let bootstrapModal = new bootstrap.Modal(objModal, {
            backdrop: 'static'
        })

        bootstrapModal.show();  // show the dialog

        objModal.addEventListener('hidden.bs.modal', function (event) {
            document.body.removeChild(objPopUpAlert);  // drop the dialog
            objThis.IsVisible = false;
        });

        this.objFragmentHTML = objCloneFragment;  // restore the dialog in memory

        return bootstrapModal;
    }
}
/**
 * @class
 * @classdesc Show A PopUp Confirm Dialog.
 * @augments JFM.PopUpConfirm_JS
 * @author Eng. Jorge Flores Miguel   jorgekain00@gmail.com  July 2021
 */
JFM.PopUpConfirm_JS = class extends JFM.PopUpAlerts_JS {
    /**
     * @description constructor fro the PopUpConfirm_JS Object
     * @param {string} strMessage principal message into the PopUp dialog
     * @param {string} strHeader header message into the PopUp dialog
     * @param {object} objIcon Icon object (DANGER, WARNING, INFO, SUCCESS)
     * @param {string} strAcceptButton text for the accept button
     * @param {string} strCancelButton text for the cancel button
     */
    constructor(strMessage = '', strHeader = '', objIcon = new JFM.Icon_JS({ type: JFM.CONST.ICONS.CONFIRM }), strAcceptButton = 'Aceptar', strCancelButton = 'Cerrar') {
        super(strMessage, strHeader, objIcon, strCancelButton);
        this.strAcceptButton = strAcceptButton;
        let objNodeFooter = this.objFragmentHTML.querySelector('.modal-footer');
        objNodeFooter.insertAdjacentHTML("beforeend", this.strButtonOKTemplate);
    }

    strButtonOKTemplate = "<button type='button' class='btn btn-primary ok'>OK</button >";
    /**
     * @description refresh the dialog template
     * @param {string} strTemplate html template for the entire dialog
     * @param {string} strButtonOKTemplate html template for the accept button
     */
    refreshTemplate(strTemplate, strButtonOKTemplate) {
        super.refreshTemplate(!!strTemplate ? strTemplate : this.strTemplate);
        if (strButtonOKTemplate) {
            this.strButtonOKTemplate = strButtonOKTemplate;
            let objNodeFooter = this.objFragmentHTML.querySelector('.modal-footer');
            objNodeFooter.insertAdjacentHTML("beforeend", this.strButtonOKTemplate);
        }

    }
    /**
     * @description (don't use it private method) refresh the dialog elements  
     * */
    updateFields() {
        // first refresh the accept button the the rest elements
        this.objFragmentHTML.querySelector('.modal-footer > .ok').innerHTML = this.strAcceptButton;
        super.updateFields();
    }
    /**
     * 
    * @description (don't use it private method) show the PopUpConfirm_JS Dialog 
    * @param {function} evalFunction function to execute after the user confirm the PopUpConfirm_JS
    */
    showPopUpConfirm(evalFunction) {
        if (!evalFunction) {
            throw new Error("missing arg evalFunction (function to execute): PopUpConfirm_JS > showPopUpConfirm");
        }
        let bootstrapModal = super.showPopUpAlert(); // show the dialog through the father
        let objOKButton = document.querySelector('#' + this.strIDModal + ' > .modal .modal-footer > .ok');

        objOKButton.addEventListener('click', function (event) {
            evalFunction(true);
            bootstrapModal.hide();  // hide the dialog
        });

        return bootstrapModal;
    }
    /**
     * @description show the PopUpConfirm_JS Dialog
     * @param {function} evalFunction function to execute after the user confirm the PopUpConfirm_JS
     */
    show(evalFunction) {
        this.updateFields();
        this.showPopUpConfirm(evalFunction);
    }
}
// #endregion

// #region UTILITIES
JFM.Sanitizer = class {
    constructor() {

    }

    sanitizeToString(str) {
        return str
            .replace(/&/g, '&amp;')
            .replace(/</g, '&lt;')
            .replace(/>/g, '&gt;')
            .replace(/"/g, '&quot;')
            .replace(/'/g, '&#039;');
    }
}
// #endregion

