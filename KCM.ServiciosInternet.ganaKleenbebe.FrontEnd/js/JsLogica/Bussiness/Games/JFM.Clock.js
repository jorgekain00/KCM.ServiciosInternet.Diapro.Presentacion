class Clock {
    constructor(paramOptions) {
        let objOptions = {
            limitMinutes: 5,
            milisecondsSelector: null,
            secondsSelector: null,
            minutesSelector: null,
            afterEndOfTime: null,
            ...paramOptions
        }

        if (objOptions.milisecondsSelector) {
            this.milisecondsSelector = document.querySelector(objOptions.milisecondsSelector);
        }
        if (objOptions.secondsSelector) {
            this.secondsSelector = document.querySelector(objOptions.secondsSelector);
        }
        if (objOptions.minutesSelector) {
            this.minutesSelector = document.querySelector(objOptions.minutesSelector);
        }

        this.limitMinutes = objOptions.limitMinutes;
        this.InitialTime = new Date();
        this.Handler = setInterval(() => { this.miliSecondsCounter() }, 10);
        this.afterEndOfTime = objOptions.afterEndOfTime;
        this._minutes = 0;
        this._seconds = 0;
        this._miliseconds = 0;
    }
    get Time() {
        return `${this.Minutes}:${this.Seconds}:${this.Miliseconds}0`;
    }

    get Seconds() {
        return this._seconds;
    }

    get Minutes() {
        return this._minutes;
    }

    get Miliseconds() {
        return this._miliseconds;
    }

    stop() {
        clearInterval(this.Handler);
    }

    miliSecondsCounter() {
        let timeActual = new Date();
        let acumularTime = timeActual - this.InitialTime;
        let acumularTime2 = new Date();
        acumularTime2.setTime(acumularTime);
        this._miliseconds = Math.round(acumularTime2.getMilliseconds() / 10);
        this._seconds = acumularTime2.getSeconds();
        this._minutes = acumularTime2.getMinutes();
        if (this.Minutes == this.limitMinutes) {
            clearInterval(this.Handler);
            this.afterEndOfTime();
        }

        if (this.milisecondsSelector) {
            this.milisecondsSelector.innerText = (this.Miliseconds > 9) ? this.Miliseconds : ("0" + this.Miliseconds);
        }
        if (this.secondsSelector) {
            this.secondsSelector.innerText = (this.Seconds > 9) ? this.Seconds : ("0" + this.Seconds);
        }
        if (this.minutesSelector) {
            this.minutesSelector.innerText = (this.Minutes > 9) ? this.Minutes : ("0" + this.Minutes);
        }
    }

}