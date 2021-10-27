class Clock {
    constructor(paramOptions) {
        let objOptions = {
            limitMinutes : 5,
            milisecondsSelector : null,
            secondsSelector : null,
            minutesSelector : null,
            ...paramOptions
        }

        if (objOptions.milisecondsSelector) {
            this.#milisecondsSelector = document.querySelector(objOptions.milisecondsSelector);
        }
        if (objOptions.secondsSelector) {
            this.#secondsSelector = document.querySelector(objOptions.secondsSelector);
        }
        if (objOptions.minutesSelector) {
            this.#minutesSelector = document.querySelector(objOptions.minutesSelector);
        }

        this.#limitMinutes = objOptions.limitMinutes;
        this.#InitialTime = new Date();
        this.#Handler = setInterval(() => { this.#miliSecondsCounter() }, 10);
    }

    #limitMinutes=0;
    #Miliseconds = 0;
    #Seconds = 0;
    #Minutes = 0;
    #Handler = null;
    #InitialTime;

    #milisecondsSelector = null;
    #secondsSelector = null;
    #minutesSelector = null;

    get Time() {
        return `${this.#Minutes}:${this.#Seconds}:${this.#Miliseconds}`;
    }

    get Seconds() {
        return this.#Seconds;
    }

    get Minutes() {
        return this.#Minutes;
    }

    get miliseconds(){
        return this.#Miliseconds;
    }

    stopClock(){
        clearInterval(this.#Handler);
    }

    #miliSecondsCounter() {
        let timeActual = new Date();
        let acumularTime = timeActual - this.#InitialTime;
        let acumularTime2 = new Date();
        acumularTime2.setTime(acumularTime);
        this.#Miliseconds = Math.round(acumularTime2.getMilliseconds() / 10);
        this.#Seconds = acumularTime2.getSeconds();
        this.#Minutes = acumularTime2.getMinutes();
        if (this.#Minutes == this.#limitMinutes) {
            clearInterval(this.#Handler);
        }

        if (this.#milisecondsSelector) {
            this.#milisecondsSelector.innerText = (this.#Miliseconds > 9) ? this.#Miliseconds : ("0" + this.#Miliseconds);
        }
        if (this.#secondsSelector) {
            this.#secondsSelector.innerText = (this.#Seconds > 9) ? this.#Seconds : ("0" + this.#Seconds);
        }
        if (this.#minutesSelector) {
            this.#minutesSelector.innerText = (this.#Minutes > 9) ? this.#Minutes : ("0" + this.#Minutes);
        }
    }

}