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
let PresetData = require('./PresetData');

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

let roomByRoomId: { [key: string]: I.Room } = {
    room22: PresetData.generateRoom22(),
    room33: PresetData.generateRoom33()
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

function getUnfinishedRoom(): I.Room {
    var roomIds: Array<string> = Object.keys(roomByRoomId);
    for (let i: number = 0; i < roomIds.length; ++i) {
        let room: I.Room = roomByRoomId[roomIds[i]];
        if (room.finishedBy != null) {
            return room;
        }
    }
    return null;
}

app.get('/roomState/', (req: any, res: any) => {
    let roomId: string = generateRoomId();
    let room: I.Room = getUnfinishedRoom();
    if (room == null) {
        room = PresetData.generateNewRoom(roomId, 10, 10);
    }
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