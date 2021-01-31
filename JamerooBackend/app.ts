import express = require('express');
let morgan = require('morgan');
import routes = require('./routes/index');
import user = require('./routes/user');
import http = require('http');
import path = require('path');
import I = require('./Interfaces');
let logger = require('./logger');	
import serveStatic = require('serve-static');

let settings: I.Settings = require('./config/settings');

let bodyParser = require('body-parser');

let app = express();

app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: false }));
let jsonFormatter = function (tokens: any, req: any, res: any) {
    let obj: any = {
        url: tokens.url(req, res),
        statusCode: tokens.status(req, res),
        durationMs: parseInt(tokens['response-time'](req, res), 10)
    };
    return JSON.stringify(obj);
}
app.use(morgan(jsonFormatter, { stream: logger.stream }));
app.use(serveStatic(path.join(__dirname, 'public')));

let COLOR1: string = "color1";
let COLOR2: string = "color2";
let COLOR3: string = "color3";
let NOCOLOR: string = "nocolor";

let SHAPE1: string = "shape1";
let SHAPE2: string = "shape2";
let SHAPE3: string = "shape3";
let NOSHAPE: string = "noshape";

let BEER_NAME: string = "beer";
let REDBULL_NAME: string = "redbull";
let KEY_NAME: string = "key";
let SHOVEL_NAME: string = "shovel";

let beerItem: I.Item = {
    name: BEER_NAME,
    color: NOCOLOR
};

let color2Shovel: I.Item = {
    name: SHOVEL_NAME,
    color: COLOR2
};

let color3Shovel: I.Item = {
    name: SHOVEL_NAME,
    color: COLOR3
};

let keyItem: I.Item = {
    name: KEY_NAME,
    color: NOCOLOR
};

let redbullItem: I.Item = {
    name: REDBULL_NAME,
    color: NOCOLOR
};

let NOMARKING: I.Marking = {
    shape: NOSHAPE,
    color: NOCOLOR
};

let cell00: I.Cell = {
    digResultByColor: {
        color1: { items: [redbullItem] },
        color2: { items: [redbullItem] },
        color3: { items: [redbullItem] }
    },
    marking: NOMARKING
};

let cell01: I.Cell = {
    digResultByColor: {
        color1: { items: [color2Shovel] },
        color2: { items: [color3Shovel] },
        color3: { items: [keyItem] }
    },
    marking: NOMARKING
};

let cell10: I.Cell = {
    digResultByColor: {
        color1: { items: [beerItem] },
        color2: { items: [beerItem] },
        color3: { items: [beerItem] }
    },
    marking: NOMARKING
};

let cell11: I.Cell = {
    digResultByColor: {
        color1: { items: [] },
        color2: { items: [] },
        color3: { items: [] }
    },
    marking: NOMARKING
};

let room22: I.Room = {
    grid: [
        [cell00, cell01],
        [cell10, cell11]
    ],
    depositBox: []
}
let roomByRoomId: { [key: string]: I.Room } = {
    room22: room22
}

function generateRoomId(): string {
    let length: number = 6;
    let result: string = '';
    let characters = 'ABCDEFGHIJKLMNPQRSTUVWXYZ123456789'; // no letter O/number 0, shit's confusing
    let charactersLength: number = characters.length;
    for (let i: number = 0; i < length; i++) {
        result += characters.charAt(Math.floor(Math.random() * charactersLength));
    }
    return result;
}

app.get('/isRunning', (req:any, res:any) => {
    res.json(200, true);
});

app.get('/roomState/:roomId', (req: any, res: any) => {
    let room: I.Room = roomByRoomId[req.params.roomId];

    let getRoomResponse: I.GetRoomResponse = {
        room: room
    };

    res.json(getRoomResponse);
    res.status(200);
});

app.post('/roomState/:roomId', (req: any, res: any) => {
    let roomId: string = req.params.roomId;

    roomByRoomId[roomId] = req.body.room;

    let createRoomStateResponse: I.CreateRoomStateResponse = {
        roomId: roomId
    };

    res.json(createRoomStateResponse);
    res.status(200);
});

app.post('/roomState/', (req: any, res: any) => {
    let roomId: string = generateRoomId();

    roomByRoomId[roomId] = req.body.room;

    let createRoomStateResponse: I.CreateRoomStateResponse = {
        roomId: roomId
    };

    res.json(createRoomStateResponse);
    res.status(200);
});

app.listen(settings.httpPort);

process.on('uncaughtException', function (err: any) {
	logger.error(err.stack);
	logger.info("Node NOT Exiting...");
	debugger;
});

logger.info("JamerooBackend has started");
let printableSettings: any = settings;
logger.info(JSON.stringify(printableSettings.__proto__, null, 2));