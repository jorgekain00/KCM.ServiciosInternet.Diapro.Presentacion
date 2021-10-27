/*
 *  Observer.js
 * 
 *  Exec a custom function for an HTML object when it is observed by the browser client
 * 
 *  @Author: Eng. Jorge Flores Miguel    jorgekain00@gamail.com
 *  @Date : April 2021
 */

let lazyImageObserver;   // IntersectionObserver object

/**
 * Register the IntersectionObserver event
 */

document.addEventListener("DOMContentLoaded", function () {
    if ("IntersectionObserver" in window) {
        lazyImageObserver = new IntersectionObserver(function (entries, observer) {
            entries.forEach(function (entry) {
                if (entry.isIntersecting) {
                    let objObserved = entry.target;
                    objObserved.IntersectingAction(objObserved.IntersectingArgs);
                    lazyImageObserver.unobserve(objObserved);
                }
            });
        });
    }
});


(function ($) {
    /*
     * Execute just one time a function where the object is visible in the DOM
     * @param {function} IntersectingAction    function to execute when the object is visible in the DOM
     * @param {any} args                        args pass to the function
     */
    $.fn.observe = function (IntersectingAction, args) {
        // The function to execute
        this.each((ind, elem) => {
            elem.IntersectingAction = IntersectingAction;
            elem.IntersectingArgs = args;
            lazyImageObserver.observe(elem);
        });
        return this;
    };
}(jQuery));