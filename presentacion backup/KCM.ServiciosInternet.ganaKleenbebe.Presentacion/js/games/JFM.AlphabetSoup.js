
class Cell {
    constructor(row, column) {
        this.row = row;
        this.column = column;
        this.Value = null;
    }
    PreviousColor='';
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
    constructor(numberRows, numberColumns, arrWords, afterFindWord ,endOfGameEvent) {
        this.#numberRows = numberRows;
        this.#numberColumns = numberColumns;
        this.#maxWordLength = (this.#numberRows > this.#numberColumns) ? this.#numberRows : this.#numberColumns;
        this.#arrWords = arrWords;
        this.objBoard = null;
        this.#initBoard();
        this.#assignWords();
        this.#assignLeftCells();
        this.#endOfGameEvent = endOfGameEvent;
        this.#afterFindWord = afterFindWord;
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
                    console.log(objthis.MissingWords);
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
                    let compStyles = window.getComputedStyle(objthis.boardHTML[row][column]), 
                    height = parseFloat(compStyles.height), 
                    width = parseFloat(compStyles.width), 
                    bounding = objthis.boardHTML[row][column].getBoundingClientRect();
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
}


// export default{
//     Cell,
//     Letter,
//     Board,