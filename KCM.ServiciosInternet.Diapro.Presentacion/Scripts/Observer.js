/**
 * @class
 * description. execute pre-loaded statements on a visibled DOM object in the client
 * @author  Eng. Jorge Flores Miguel    jorgekain00@gmail.com
 * @summary observe and unobserve objects by IntersectionObserver API
 * @property {Object}  lazyImageObserver - An IntersectionObserver API object
 */
class Observer {
    constructor() {
        document.addEventListener("DOMContentLoaded", function () {
            if ("IntersectionObserver" in window) {
                Observer.lazyImageObserver = new IntersectionObserver(function (entries, observer) {
                    entries.forEach(function (entry) {
                        if (entry.isIntersecting) {     // validate 
                            let objObserved = entry.target;
                            objObserved.IntersectingAction(objObserved.IntersectingArgs);
                            if (objObserved.autoUnObserve) {
                                Observer.lazyImageObserver.unobserve(objObserved);
                            }
                        }
                    });
                });
            }
        });
    }

    /**
     * @static IntersectionObserver Object
     */
    static lazyImageObserver = null;

    /**
     * @description  add a DOM object to IntersectionObserver Object (lazyImageObserver)
     * @param {string} selector  DOM object(s)
     * @param {{IntersectingAction: string, IntersectingArgs:string, autoUnObserve: boolean }} args {IntersectingAction: function to exec, IntersectingArgs: args for the function, autoUnObserve: auto unregister object }
     */
    static registerSelector(selector, args) {
        let objSelector = document.querySelectorAll(selector);
        let objDefaultValues = {
            IntersectingAction: null,
            IntersectingArgs: null,
            autoUnObserve: true
        }

        let objOptions = Object.assign({}, objDefaultValues, args);

        if (objSelector && objOptions && objOptions.IntersectingAction) {
            objSelector.forEach(elem => {
                elem.IntersectingAction = objOptions.IntersectingAction;
                elem.IntersectingArgs = objOptions.IntersectingArgs;
                elem.autoUnObserve = objOptions.autoUnObserve;
                Observer.lazyImageObserver.observe(elem);
            });
        }
    }

    /**
     * @description  remove a DOM object(s) from IntersectionObserver Object (lazyImageObserver)
     * @param {string} selector  DOM object 
     */
    static unRegisterSelector(selector) {
        let objSelector = document.querySelectorAll(selector);
        if (objSelector) {
            objSelector.forEach(elem => Observer.lazyImageObserver.unobserve(elem));
        }
    }
}

new Observer(); // begin actions