

class SearchThings {
    constructor(objSearchThingsConfig, endOfGameEvent) {
        this.#SearchThingsConfig = new SearchThingsConfig();
        this.#SearchThingsConfig.setDataFromJSON(objSearchThingsConfig);
        this.#NumberOfImages = this.#SearchThingsConfig.thingsToFind.length;
        this.#numberThingsToFind = this.#SearchThingsConfig.numberThingsToFind;
        this.#endOfGameEvent = endOfGameEvent;

        if (this.#NumberOfImages == 0) {
            throw new Error('SearchThings : number of images equal to zero');
        }

        this.#init();
    }

    #SearchThingsConfig = null;
    #NumberOfImages = 0;
    #NumberOfGaps = 0;
    #Gaps = null;
    #endOfGameEvent = null;
    #numberThingsToFind = 0;

    #init() {
        this.#loadCSS();
        this.#loadImages();
        this.#setThingsTofind();
        this.#assignEvents();
    }

    #loadCSS() {
        let objData = new DataKBB(),
            objThis = this;

        objData.Body = this.#SearchThingsConfig.template;
        new AJAXKBB().callController('/Games/GetTemplate', objData, (dataR) => {
            objData.setDataFromJSON(dataR);
            if (objData.IsSuccessful) {
                document.head.insertAdjacentHTML('beforeend', objData.Body);
            }
            else {
                DisplayError.show('Error', objData.strErrorMessage);
                throw new Error('Can not get html template');
            }
        }, false);
    }
    #loadImages() {
        let strBackGround = this.#SearchThingsConfig.backgroundImage,
            objRugImage = document.getElementById('rugImage'),
            objGaps = document.querySelectorAll(`div[id^=${this.#SearchThingsConfig.prefix}_]`),
            objthingsToFind = this.#SearchThingsConfig.thingsToFind.slice(0);

        // set the background
        if (!!objRugImage && !!strBackGround) {
            objRugImage.src = strBackGround;
        }

        // get the possible gaps
        if (!objGaps || objGaps.length == 0) {
            throw new Error('SearchThings : can not get gaps')
        }

        this.#NumberOfGaps = objGaps.length;
        if (this.#NumberOfImages > this.#NumberOfGaps){
            this.#NumberOfImages = this.#NumberOfGaps;
        }
        
        objGaps = [].slice.call(objGaps, 0);
        this.#Gaps = objGaps.slice(0);

        this.#setImage(this.#NumberOfGaps, this.#NumberOfImages, objGaps, objthingsToFind);
    }

    #setImage(intNumberOfGaps, intNumberOfImages, objGaps, thingsToFind) {
        let intRndGap = 0,
            intRndImg = 0,
            objImg = document.createElement('IMG');

        if (intNumberOfGaps == 0 || intNumberOfImages == 0) {
            return;
        }

        if (intNumberOfGaps == 1) {
            intRndGap = 0;
        }
        else {
            intRndGap = Math.floor(Math.random() * intNumberOfGaps);
        }

        if (intNumberOfImages == 1) {
            intRndImg = 0;
        }
        else {
            intRndImg = Math.floor(Math.random() * intNumberOfImages);
        }

        objGaps[intRndGap].dataset.numberOfImage = thingsToFind[intRndImg].id;
        objImg.src = thingsToFind[intRndImg].url;
        objImg.alt = thingsToFind[intRndImg].name;
        objGaps[intRndGap].appendChild(objImg);

        objGaps.splice(intRndGap, 1);
        thingsToFind.splice(intRndImg, 1);

        --intNumberOfGaps;
        --intNumberOfImages;

        this.#setImage(intNumberOfGaps, intNumberOfImages, objGaps, thingsToFind);
    }

    #setThingsTofind() {
        let objWordsToFind = document.getElementById('wordsToFind'),
            objUL = document.createElement('UL'),
            arrThingsToFind = this.#SearchThingsConfig.thingsToFind.slice(0);

        objUL.id = `ThingsTofindList`;
        
        if (this.#numberThingsToFind > this.#NumberOfImages) {
            this.#numberThingsToFind > this.#NumberOfImages;
        }

        for (var iw = 0; iw < this.#numberThingsToFind; iw++) {
            let objLI = document.createElement('LI'),
                objSpan = document.createElement('SPAN'),
                intRnd = Math.floor(Math.random() * arrThingsToFind.length),
                objTF = this.#SearchThingsConfig.arrThingsToFind[intRnd];
            arrThingsToFind.splice(intRnd,1);
            objLI.classList.add('ThingsTofindElement');
            objLI.dataset.numberOfImage = objTF.id;
            objSpan.innerText = objTF.name;
            objLI.appendChild(objSpan);
            objUL.appendChild(objLI);
        }
        objWordsToFind.appendChild(objUL);
    }

    #assignEvents() {
        let objThis = this,
            objfinishedButton = document.querySelector('#finishedButton');
        this.#Gaps.forEach(objHTML => {
            if (!!objHTML.dataset.numberOfImage) {
                objHTML.addEventListener('click', function (event) {
                    objHTML.classList.toggle('FoundElement')
                }, false);
            }
        });

        if (!!objfinishedButton) {
            objfinishedButton.addEventListener('click', function (event) {
                let arrSelectedThings = document.querySelectorAll('.FoundElement'),
                arrThingsTofindList = document.querySelectorAll(`#ThingsTofindList > li[data-number-of-image]`),
                arrIdToFind = arrThingsTofindList.map(TFL=>TFL.dataset.numberOfImage);

                if (!!arrSelectedThings) {
                    arrSelectedThings.forEach(FE=>{
                        let intInd = arrIdToFind.indexOf(FE.dataset.numberOfImage);
                        if (intInd > -1) {
                            arrIdToFind.splice(intInd,1);
                        }
                    });
                }

                if (arrIdToFind == 0) {
                    objThis.#endOfGameEvent();
                }
                else
                {
                    new JFMUI.PopUpAlerts_JS('oops, parece que te equivocaste, faltan o tienes objetos de más ¡apúrate!', 'Partida en curso', new JFMUI.Icon_JS({ type: JFMUI.CONST.ICONS.WARNING, width: 36, height: 36 }), undefined, undefined, true).show();
                }
            },false);
        }
    }

    static main(event){
        let objSSOData = event.detail.Data,
            objData= null,
            objGame;
        if (event.detail.Route.isSuccessful && objSSOData.isSuccessful) {
             objGame = new Game({
                    UID: objSSOData.strUID,
                    Attemps: 1,
                    StartBtn: document.querySelector('#startGame'),
                    GameBoard: document.querySelector('#GameBoard'),
                    InstruccionsBoard : document.querySelector('.gameinner'),
                    InitializeGame : function() {
                        let objThis = this;
                        objData = new DataKBB();
                        objData.strUID = objSSOData.strUID;

                        new AJAXKBB().callController('/Games/getGame', objData, (dataR) => {
                            objData.setDataFromJSON(dataR);
                            if (objData.IsSuccessful) {
                                let objSearchThingsConfig = new SearchThingsConfig();

                                if (objData.Body.collection == 1) {
                                    objSearchThingsConfig.setDataFromJSON(JSON.parse(objData.Body.collection[0]));
                                }
                                else {
                                    let intInd = Math.floor(Math.random() * objData.Body.collection.length);
                                    objSearchThingsConfig.setDataFromJSON(JSON.parse(objData.Body.collection[intInd]));
                                }

                                let objSearchThings = new SearchThings(objSearchThingsConfig, objThis.endOfGameEvent);
                                objThis.ExpiredTimeInSeconds = objSearchThingsConfig.expiredTimeInSeconds;
                            }
                            else {
                                DisplayError.show('Error', objData.strErrorMessage);
                            }
                        }, true);
                    },
                    AfterHit: function () {
                    },
                    endOfGameEvent : function (State) {
                        if (!State) {
                            objGame.Clock.stop();
                            let iconClock = `<svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor" class="bi bi-alarm-fill" viewBox="0 0 16 16"><path d="M6 .5a.5.5 0 0 1 .5-.5h3a.5.5 0 0 1 0 1H9v1.07a7.001 7.001 0 0 1 3.274 12.474l.601.602a.5.5 0 0 1-.707.708l-.746-.746A6.97 6.97 0 0 1 8 16a6.97 6.97 0 0 1-3.422-.892l-.746.746a.5.5 0 0 1-.707-.708l.602-.602A7.001 7.001 0 0 1 7 2.07V1h-.5A.5.5 0 0 1 6 .5zm2.5 5a.5.5 0 0 0-1 0v3.362l-1.429 2.38a.5.5 0 1 0 .858.515l1.5-2.5A.5.5 0 0 0 8.5 9V5.5zM.86 5.387A2.5 2.5 0 1 1 4.387 1.86 8.035 8.035 0 0 0 .86 5.387zM11.613 1.86a2.5 2.5 0 1 1 3.527 3.527 8.035 8.035 0 0 0-3.527-3.527z"/></svg>`,
                                strtime = objGame.Clock.Time,
                                objCancelBtn = document.getElementById('cancelButton');

                                 new JFMUI.PopUpAlerts_JS(`Este es tu tiempo < br > <span id="clocktime">${iconClock} ${strtime}</span> <br>!Vas bien, sigue así!`, 'Has ganado la partida',
                                    new JFMUI.Icon_JS({type: JFMUI.CONST.ICONS.SUCCESS, width: 36, height: 36 }), undefined, undefined, true).show();
                             
                            if (!!objCancelBtn) {
                                objCancelBtn.disabled = true;
                            }
                            objGame.saveGame(objData, "/Ticket/Index", 5000);

                        }
                        else {
                            if (State == ENDOFGAME.CANCELGAME) {
                                new JFMUI.PopUpConfirm_JS('¿Estás segur@@ de cerrar y perder tu juego?', 'Oye, espera', new JFMUI.Icon_JS({ type: JFMUI.CONST.ICONS.CONFIRM, width: 46, height: 46 }), 'SI', 'NO').show(function () {
                                    objGame.Clock.stop();
                                    setTimeout(() => { new JFMUI.PopUpAlerts_JS('En breve será redireccionado al Inicio de juegos', 'Has perdido la partida', new JFMUI.Icon_JS({ type: JFMUI.CONST.ICONS.WARNING, width: 36, height: 36 }), undefined, undefined, true).show() }, 500);
                                    setTimeout(() => location.href = "/Ticket/Index", 5000);
                                });
                            }
                            else if (State == ENDOFGAME.OUTIME) {
                                new JFMUI.PopUpAlerts_JS('En breve será redireccionado al Inicio de juegos', 'Has perdido la partida', new JFMUI.Icon_JS({ type: JFMUI.CONST.ICONS.WARNING, width: 36, height: 36 }), undefined, undefined, true).show();
                                setTimeout(()=>location.href="/Ticket/Index",5000);
                            }
                        }
                    }
            })
        }
        window.removeEventListener('SSO.GetSession',SearchThings.main);                                        
    }
}


window.addEventListener('SSO.GetSession',SearchThings.main, false);