
class Cell {
    constructor(row, column) {
        this.row = row;
        this.column = column;
        this.Value = null;
    }
    PreviousColor = '';
    Value;
    get TemplateHTML() {
        let objDiv = document.createElement('DIV'),
            objSpan = document.createElement('SPAN');

        objDiv.classList.add('soupCell');
        objSpan.innerText = this.Value;
        objDiv.appendChild(objSpan);

        return objDiv;
    }
}

class Letter {
    static getRandomLetter() {
        let intRnd = Math.floor(Math.random() * 27),
            intCode = 0;

        if (intRnd == 26) {
            intCode = 209;
        }
        else {
            intCode = 65 + intRnd;
        }
        return String.fromCharCode(intCode);
    }
    static getRandomColor() {
        let letters = '0123456789ABCDEF';
        let color = "#";
        for (let index = 0; index < 6; index++) {
            color += letters[Math.floor(Math.random() * 16)];
        }
        return color;
    }
}

class Word {
    constructor(address, value) {
        this.Value = value;
        this.Address = address;
    }
}

class Board {
    constructor(numberRows, numberColumns, arrWords, numberOfWordsTofind, afterFindWordEvent, endOfGameEvent) {

        if (arrWords.length == 0) {
            throw new Error('missing words to find');
        }

        this.#numberRows = numberRows;
        this.#numberColumns = numberColumns;
        this.#maxWordLength = (this.#numberRows > this.#numberColumns) ?this.#numberRows: this.#numberColumns;
        this.#arrWords = [];
        this.#selectWords(arrWords.map(w => w.trim().toUpperCase()), numberOfWordsTofind, this.#arrWords);
        this.objBoard = null;
        this.#initBoard();
        this.#assignWords();
        this.#assignLeftCells();
        this.#endOfGameEvent = endOfGameEvent;
        this.#afterFindWord = afterFindWordEvent;
    }
    #numberRows;
    #numberColumns;
    #maxWordLength;
    #board = [];
    #cellsCollection = [];
    #arrWords;
    #WordsToFind = null;
    MissingWords = null;
    #Answer = null;
    #isEnablePointerMove = false;
    #Color = null;
    boardHTML = [];
    #endOfGameEvent;  // event when the users end successful the game
    #afterFindWord;

    get wordsToFind() {
        return this.#WordsToFind;
    }

    #selectWords(arrWords, numberOfWordsTofind, arrWordsToFind = []) {
        if (arrWords.length == 0) {
            return arrWordsToFind;
        }

        if (numberOfWordsTofind == 0) {
            return arrWordsToFind;
        }

        let intRnd = Math.floor(Math.random() * arrWords.length),
            strCurrentWord = arrWords[intRnd];

        if (arrWordsToFind.length > 0) {
            let isArrWordIncludeByCurrent = arrWordsToFind.some((value, index, arr) => {
                return strCurrentWord.includes(value);
            }),
                isCurrentIncludeByArrWord = arrWordsToFind.some((value, index, arr) => {
                    return value.includes(strCurrentWord);
                });

            if (!isArrWordIncludeByCurrent && !isCurrentIncludeByArrWord) {
                arrWordsToFind.push(strCurrentWord);
                --numberOfWordsTofind;
            }
        }
        else {
            arrWordsToFind.push(strCurrentWord);
            --numberOfWordsTofind;
        }
        arrWords.splice(intRnd, 1);

        this.#selectWords(arrWords, numberOfWordsTofind, arrWordsToFind);
    }

    #initBoard() {
        for (let row = 0; row < this.#numberRows; row++) {
            this.#board[row] = [];
            for (let column = 0; column < this.#numberColumns; column++) {
                let objCell = new Cell(row, column);
                this.#board[row][column] = objCell;
                this.#cellsCollection.push(objCell);
            }
        }
    }

    #assignWords() {
        // TODO: utilizamos cellsCollection para buscar una celda aleatoria donde poner la palabra
        let intTry = 0;

        this.#WordsToFind = new Map();

        this.#arrWords.forEach((w) => {
            w = w.toUpperCase();
            intTry = 0;
            if (!(w.length > this.#maxWordLength)) {
            while (intTry < this.#cellsCollection.length) {
                let startCell = Math.floor(Math.random() * this.#cellsCollection.length);
                let address = [];
                if (this.#setWord(w, startCell, address)) {
                    let objWord = new Word(address, w);
                    this.#WordsToFind.set(w, objWord);
                    break;
                }
                intTry++;
            }
        }
    });

        this.MissingWords = new Map([...this.#WordsToFind]);
    }

#setWord(word, cellPos, address) {
    let cell = this.#cellsCollection[cellPos];

    if (!this.#alignLetter(-1, -1, word, cell.row, cell.column, address)) //to the northwest
    if (!this.#alignLetter(-1, 0, word, cell.row, cell.column, address)) //to the north
    if (!this.#alignLetter(-1, 1, word, cell.row, cell.column, address)) //to the northeast
    if (!this.#alignLetter(0, 1, word, cell.row, cell.column, address)) // to the east
    if (!this.#alignLetter(1, 1, word, cell.row, cell.column, address))   // to the southEast
    if (!this.#alignLetter(1, 0, word, cell.row, cell.column, address)) // to the south
    if (!this.#alignLetter(1, -1, word, cell.row, cell.column, address)) // to the SouthWest
    if (!this.#alignLetter(0, -1, word, cell.row, cell.column, address))    // to the west
    return false;

    return true;

}

#alignLetter(rowMovement, columnMovement, word, row, column, address) {
    let previousValue,
        nextLetter,
        cell;

    if (word.length == 0) {
        return true;
    }

    if (row < 0 || column < 0 || row == this.#numberRows || column == this.#numberColumns) {
        return false;
    }

    cell = this.#board[row][column];
    nextLetter = word[0];

    if (!cell.Value || cell.Value == nextLetter) {
        previousValue = cell.Value;
        cell.Value = nextLetter;
        address.push({ row, column });
    }
    else {
        return false;
    }

    if (this.#alignLetter(rowMovement, columnMovement, word.slice(1), row + rowMovement, column + columnMovement, address)) {
        return true;
    }
        else {
        cell.Value = previousValue;
        address.splice(0, address.length);
        return false;
    }
}

#assignLeftCells() {
    for (let index = 0; index < this.#cellsCollection.length; index++) {
        let cell = this.#cellsCollection[index];
        if (!cell.Value) {
            cell.Value = Letter.getRandomLetter();
        }
    }
}

printBoardConsole() {
    for (let row = 0; row < this.#board.length; row++) {
        let arrrow = [];
        for (let column = 0; column < this.#board[row].length; column++) {
            arrrow.push(this.#board[row][column].Value);
        }
        console.log(arrrow);
    }
}
printBoard() {
    let objBoard = document.createElement('DIV'),
        objRow,
        objCell;

    objBoard.id = "soupBoard";

    for (let row = 0; row < this.#numberRows; row++) {
        objRow = document.createElement('DIV');
        objRow.classList.add("soupRow");
        this.boardHTML[row] = [];
        for (let column = 0; column < this.#numberColumns; column++) {
            objCell = this.#board[row][column];
            this.boardHTML[row][column] = objRow.appendChild(objCell.TemplateHTML);
            this.boardHTML[row][column].Cell = objCell;  // Save the Cell object into the HTML OBJECT
        }
        objBoard.appendChild(objRow);
    }
    this.objBoard = objBoard;
    return objBoard;
}

showSolution() {
    this.#WordsToFind.forEach((w, k) => {
        let color = Letter.getRandomColor();
        w.Address.forEach(l => {
            this.boardHTML[l.row][l.column].style.background = color;
        });
    });
}

// TODO: que pasa cuando ya se encontro la palabra y se vuelve a pasar por la palabra
handleTouchEvent() {
    let objthis = this;

    this.objBoard.addEventListener('pointerdown', function (event) {
        objthis.#isEnablePointerMove = true;
        if (objthis.#Answer && objthis.#Answer instanceof Set) {
        objthis.#Answer.clear();
    }
            else {
        objthis.#Answer = new Set();
    }
    objthis.#Color = Letter.getRandomColor();
    objthis.#lookUpCell(event, objthis);
}, false);

this.objBoard.addEventListener('pointermove', function (event) {
    if (objthis.#isEnablePointerMove) {
    objthis.#lookUpCell(event, objthis);
}
        }, false);

this.objBoard.addEventListener('pointerup', function (event) {
    objthis.#getUserResponse(objthis);
}, false);

this.objBoard.addEventListener('pointerleave', function (event) {
    objthis.#getUserResponse(objthis);
}, false);

    }

#getUserResponse(objthis) {
    if (objthis.#isEnablePointerMove) {
        objthis.#isEnablePointerMove = false;

        let strWord = '', objAddress = [], isWordFinded = false;

        objthis.#Answer.forEach(l => {
            strWord += l.Cell.Value;
            objAddress.push({ row: l.Cell.row, column: l.Cell.column });
        });

        if (objthis.MissingWords && objthis.MissingWords instanceof Map) {
            let objRespMap = objthis.MissingWords.get(strWord);
            if (!!objRespMap) {
                isWordFinded = objRespMap.Address.every((value, index, arr) => {
                    return value.row == objAddress[index].row && value.column == objAddress[index].column;
                });
            }

            if (!objRespMap || !isWordFinded) {
                objthis.#Answer.forEach(l => {
                    l.style.background = l.Cell.PreviousColor;
                    // l.style.background = 'initial';
                });
            }
            else if (!!isWordFinded) {
                objthis.#Answer.forEach(l => {
                    l.Cell.PreviousColor = objthis.#Color;
                });
                objthis.MissingWords.delete(strWord);
                if (!!objthis.#afterFindWord) {
                    objthis.#afterFindWord(strWord);
                }
                if (objthis.MissingWords.size == 0 && !!objthis.#endOfGameEvent) {
                    // end of succesful game
                    objthis.#endOfGameEvent();
                }
            }
        }
    }
}

#lookUpCell(event, objthis) {
    let clientX, clientY;
    // if (event.touches.length == 1) {
    //switch (event.type) {
    //    case "touchmove":
    event.preventDefault(); //prevent scrolling
    clientX = event.clientX;
    clientY = event.clientY;
    // clientX = event.touches[0].clientX;
    // clientY = event.touches[0].clientY;
    //        break;
    //}
    for (let row = 0; row < objthis.#numberRows; row++) {
        for (let column = 0; column < objthis.#numberColumns; column++) {
            let compStyles = window.getComputedStyle(objthis.boardHTML[row][column].firstChild),
                height = parseFloat(compStyles.height),
                width = parseFloat(compStyles.width),
                bounding = objthis.boardHTML[row][column].firstChild.getBoundingClientRect();
            if (bounding.x < clientX && bounding.y < clientY && clientX < (bounding.x + width) && clientY < (bounding.y + height)) {
                if (!objthis.boardHTML[row][column].style.background) {
                    objthis.boardHTML[row][column].Cell.PreviousColor = 'initial';
                }
                objthis.boardHTML[row][column].style.background = objthis.#Color;
                objthis.#Answer.add(objthis.boardHTML[row][column]);
            }
        }
    }
    // }
}
    static main(event){
        let objSSOData = event.detail.Data,
            objData,
            objGame;

        if (event.detail.Route.isSuccessful && objSSOData.isSuccessful) {
            objGame = new Game({
                UID: objSSOData.strUID,
                Attemps: 1,
                StartBtn: document.querySelector('#startGame'),
                GameBoard: document.querySelector('#GameBoard'),
                InstruccionsBoard: document.querySelector('.gameinner'),
                InitializeGame: function () {
                    let objThis = this;

                    objData = new DataKBB();
                    objData.strUID = objSSOData.strUID;

                    new AJAXKBB().callController('/Games/getGame', objData, (dataR) => {
                        objData.setDataFromJSON(dataR);
                        if (objData.IsSuccessful) {
                            let objSoupLettersConfig = new SoupLettersConfig(),
                                objParams = JSON.parse(objData.Body.collection[0]),
                                arrWords = objData.Body.collection.slice(1).map(w => { let [strWord] = [...JSON.parse(w)]; return strWord; });
                            if (!!objParams) {
                                objSoupLettersConfig.setDataFromJSON(objParams);
                                let objBoard = new Board(objSoupLettersConfig.rows, objSoupLettersConfig.columns, arrWords, objSoupLettersConfig.wordsToFind, objThis.AfterHit, objThis.endOfGameEvent),
                                    objPlayGame = document.getElementById('juego');

                                if (!!objPlayGame) {
                                    objPlayGame.appendChild(objBoard.printBoard());
                                }
                                objBoard.handleTouchEvent();

                                objBoard.MissingWords.forEach((v, k) => {
                                    let divW = document.createElement('DIV'),
                                        spanW = document.createElement('SPAN'),
                                        objWordsToFind = document.getElementById('wordsToFind');

                                    divW.id = "soupWord_" + k;
                                    divW.style = "margin:10px";
                                    spanW.innerText = k;
                                    divW.appendChild(spanW);
                                    objWordsToFind.appendChild(divW);
                                });
                                objThis.ExpiredTimeInSeconds = objSoupLettersConfig.ExpiredTimeInSeconds;
                            }
                        }
                        else {
                            DisplayError.show('Error', objData.strErrorMessage);
                        }
                    }, true);
                },
                AfterHit: function (strWord) {
                    let objWord = document.getElementById("soupWord_" + strWord);
                    objWord.style.textDecoration = "line-through";
                },
                endOfGameEvent: function (State) {
                    if (!State) {
                        objGame.Clock.stop();
                        let iconClock = `<svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor" class="bi bi-alarm-fill" viewBox="0 0 16 16"><path d="M6 .5a.5.5 0 0 1 .5-.5h3a.5.5 0 0 1 0 1H9v1.07a7.001 7.001 0 0 1 3.274 12.474l.601.602a.5.5 0 0 1-.707.708l-.746-.746A6.97 6.97 0 0 1 8 16a6.97 6.97 0 0 1-3.422-.892l-.746.746a.5.5 0 0 1-.707-.708l.602-.602A7.001 7.001 0 0 1 7 2.07V1h-.5A.5.5 0 0 1 6 .5zm2.5 5a.5.5 0 0 0-1 0v3.362l-1.429 2.38a.5.5 0 1 0 .858.515l1.5-2.5A.5.5 0 0 0 8.5 9V5.5zM.86 5.387A2.5 2.5 0 1 1 4.387 1.86 8.035 8.035 0 0 0 .86 5.387zM11.613 1.86a2.5 2.5 0 1 1 3.527 3.527 8.035 8.035 0 0 0-3.527-3.527z" /></svg>`,
                            strtime = objGame.Clock.Time,
                            objCancelBtn = document.getElementById('cancelButton');
                        new JFMUI.PopUpAlerts_JS(`Este es tu tiempo<br><span id="clocktime">${iconClock} ${strtime}</span><br>!Vas bien, sigue así!`, 'Has ganado la partida',
                            new JFMUI.Icon_JS({ type: JFMUI.CONST.ICONS.SUCCESS, width: 36, height: 36 }), undefined, undefined, true).show();

                        if (objCancelBtn) {
                            objCancelBtn.disabled = true;
                        }
                        objGame.saveGame(objData, "/Ticket/Index", 5000);
                    }
                    else {
                        if (State == ENDOFGAME.CANCELGAME) {
                            new JFMUI.PopUpConfirm_JS('Estas apunto de abandonar el juego. Si abandonas el juego perderás una de tus oportunidades de ganar.¡Ánimo!', 'Oye, espera', new JFMUI.Icon_JS({ type: JFMUI.CONST.ICONS.CONFIRM, width: 46, height: 46 }), 'Abandonar', 'Cancelar').show(function () {
                                objGame.Clock.stop();
                                setTimeout(() => { new JFMUI.PopUpAlerts_JS('En breve será redireccionado al Inicio de juegos', 'Has perdido la partida', new JFMUI.Icon_JS({ type: JFMUI.CONST.ICONS.WARNING, width: 36, height: 36 }), undefined, undefined, true).show() }, 500);
                                setTimeout(() => location.href = "/Ticket/Index", 5000);
                            });
                        }
                        else if (State == ENDOFGAME.OUTIME) {
                            new JFMUI.PopUpAlerts_JS('En breve será redireccionado al Inicio de juegos', 'Has perdido la partida', new JFMUI.Icon_JS({ type: JFMUI.CONST.ICONS.WARNING, width: 36, height: 36 }), undefined, undefined, true).show();
                            setTimeout(() => location.href = "/Ticket/Index", 5000);
                        }
                    }
                }
            })
        }
        window.removeEventListener('SSO.GetSession', Board.main);
    }
}

window.addEventListener('SSO.GetSession', Board.main, false);