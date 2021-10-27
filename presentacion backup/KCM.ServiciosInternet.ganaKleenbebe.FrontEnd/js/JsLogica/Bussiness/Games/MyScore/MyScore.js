/// <reference path="../../../jfm.ui.js" />

class MyScore {

    constructor(strUID, strName) {
        let objGamer = document.querySelector('.gamenameText');

        if (!!objGamer && !!strName) {
            objGamer.innerText = strName.substring(0, 1).toUpperCase() + strName.substring(1).toLowerCase();   // Display the name of the gamer
        }
        this.strUID = strUID;     // set the UID param before start ajax request

        this.#objAJAXLoader = new JFMUI.AJAXLoader({
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
        document.body.appendChild(this.#objAJAXLoader.BoxLoading);
    }
    #objAJAXLoader = null;

    getScore() {
        let objThis = this,
            objData = new DataKBB()

        objData.strUID = this.strUID;
        new AJAXKBB().callController('/Games/GetScore', objData, (dataR) => {
            objData.setDataFromJSON(dataR);
            if (objData.IsSuccessful) {
                this.#SetTableScore(objData.Body);
            }
            else {
                DisplayError.show('Error', objData.strErrorMessage);
            }
        }, false);
    }
    #SetTableScore(arrData) {

        if (arrData.length == 0) {
            let objDivScore = document.getElementById('ScoreSection');
            if (!!objDivScore) {
                objDivScore.innerText = '';
                objDivScore.innerHTML = `<span class="nodata" >No hay partidas jugadas en esta semana</span>`;
            }
        }
        else {
            let objScore = null,
                strNewRow = null,
                intNumber = 0,
                objScoreTable = document.querySelector('#ScoreSection > table > tbody'),
                intLessTime = '99:99:9999',
                objHtmlLesstime = null;

            arrData.forEach(row => {
                objScore = new Score();
                objScore.setDataFromJSON(row);
                ++intNumber;
                strNewRow = `<tr id="score_${intNumber}"><th scope="row">${intNumber}</th><td>${objScore.Description}</td><td>${objScore.GameDate}</td><td>${objScore.Time}</td></tr>`
                objScoreTable.insertAdjacentHTML('beforeend', strNewRow);
                if (intLessTime < objScore.Time) {
                    intLessTime = objScore.Time;
                    objHtmlLesstime = document.querySelector(`#score_${intNumber}`);
                }
            })

            if (!!objHtmlLesstime) {
                objHtmlLesstime.style.color = "#DAA520";
            }
        }
    }

    static main(event) {
        if (event.detail.Route.isSuccessful && event.detail.Data.isSuccessful) {
            new MyScore(event.detail.Data.strUID, JSON.parse(event.detail.Data.strProfile).firstName).getScore();
        }
        window.removeEventListener('SSO.GetSession', MyScore.main);
    }
}


window.addEventListener('SSO.GetSession', MyScore.main, false);
