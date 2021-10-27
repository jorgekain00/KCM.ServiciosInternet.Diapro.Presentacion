class Game {
    constructor(paramOptions) {
        let objOptions = {
            UID: '',
            Attemps: '',
            StartBtn: null,
            GameBoard: null,
            InstruccionsBoard: null,
            InitializeGame: null,
            AfterHit: null,
            endOfGameEvent: null,
            ExpiredTimeInSeconds: 0,
            ...paramOptions
        }

        this.UID = objOptions.UID;
        this.Attemps = objOptions.Attemps;
        this.StartBtn = objOptions.StartBtn;
        this.GameBoard = objOptions.GameBoard;
        this.InstrucctionsBoard = objOptions.InstruccionsBoard;
        this.InitializeGame = objOptions.InitializeGame;
        this.AfterHit = objOptions.AfterHit;
        this.endOfGameEvent = objOptions.endOfGameEvent;
        this.ExpiredTimeInSeconds = objOptions.ExpiredTimeInSeconds;
        this.Clock = null;


        if (!this.UID || !this.Attemps || !this.StartBtn || !this.GameBoard || !this.InstrucctionsBoard || !this.InitializeGame) {
            throw new Error('Game : missing parameters');
        }

        this.init();
    }
    init() {
        let objThis = this;

        this.InstrucctionsBoard.addEventListener("animationend", (evt) => {
            if (evt.animationName === 'Games_AnimationFadeOut') {
                objThis.InstrucctionsBoard.style.display = "none";
                objThis.GameBoard.style.animation = 'Games_AnimationFadeIn 1s linear';
                objThis.GameBoard.style.display = "block";
            }
        }, false);


        this.GameBoard.addEventListener("animationend", (evt) => {
            if (evt.animationName === 'Games_AnimationFadeIn') {
                objThis.GameBoard.style.display = "block";
                objThis.setClock();
            }
        }, false);

        this.loadAnimations();

        this.StartBtn.addEventListener('click', function (event) {
            objThis.initGame();
        }, false);
        this.StartBtn.style.pointerEvents = 'auto';


        this.InitializeGame();
    }

    loadAnimations() {
        let objStyle = document.createElement('STYLE');
        objStyle.type = 'text/css';
        objStyle.innerText = '@keyframes Games_AnimationFadeIn {0%{opacity:0;}100%{opacity:1;}} @keyframes Games_AnimationFadeOut {0%{opacity:1;} 100 % {opacity:0;}}';
        document.getElementsByTagName('head')[0].appendChild(objStyle);
    }

    initGame() {
        this.InstrucctionsBoard.style.animation = 'Games_AnimationFadeOut 1s linear';
        this.GameBoard.style.animation = '';
    }

    setClock() {
        let objthis = this;

        this.Clock = new Clock({
            limitMinutes: Math.floor(this.ExpiredTimeInSeconds / 60),
            milisecondsSelector: '#clockMiliseconds',
            secondsSelector: '#clockSecond',
            minutesSelector: '#clockMinutes',
            afterEndOfTime: function () {
                objthis.endOfGameEvent(ENDOFGAME.OUTIME);
            }
        });

        document.getElementById('cancelButton').addEventListener('click', function (event) {
            objthis.endOfGameEvent(ENDOFGAME.CANCELGAME);
        }, false);
    }

    saveGame(dataR, strUrlRedirect, intWaitSeconds) {
        let objData = new DataKBB();
        objData.setDataFromJSON(dataR);
        objData.Body.Time = this.Clock.Time;
        objData.Body = JSON.stringify(objData.Body);

        new AJAXKBB().callController('/Games/SaveGame', objData, (dataR) => {
            objData.setDataFromJSON(dataR);
            if (!objData.IsSuccessful) {
                new JFMUI.PopUpAlerts_JS(objData.strErrorMessage, 'Error', new JFMUI.Icon_JS({ type: JFMUI.CONST.ICONS.DANGER, width: 36, height: 36 }), undefined, undefined, true).show();
            }
            setTimeout(() => location.href = strUrlRedirect, intWaitSeconds);
        }, true);
    }
}
