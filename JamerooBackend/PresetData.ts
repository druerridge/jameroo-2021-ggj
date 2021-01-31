﻿import I = require('./Interfaces');

class PresetData {
    public static generateRoom33(): I.Room {
        let room22: I.Room = PresetData.generateRoom22();

        let cell00: I.Cell = room22.grid[0][0];
        let cell01: I.Cell = room22.grid[0][1];
        let cell11: I.Cell = room22.grid[1][1];
        let cell10: I.Cell = room22.grid[1][0];

        let room33: I.Room = {
            grid: [
                [cell00, cell01, cell11],
                [cell10, cell11, cell00],
                [cell00, cell01, cell01]
            ],
            depositBox: []
        }
        return room33;
    }

    public static generateRoom22(): I.Room {
        let YELLOW: string = "yellow";
        let BLUE: string = "blue";
        let PURPLE: string = "purple";
        let NOCOLOR: string = "nocolor";
        let O_SHAPE: string = "o";
        let X_SHAPE: string = "x";
        let TRI_SHAPE: string = "tri";
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
            color: BLUE
        };

        let color3Shovel: I.Item = {
            name: SHOVEL_NAME,
            color: PURPLE
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

        let COLOR1_SHAPE1: I.Marking = {
            color: YELLOW,
            shape: O_SHAPE
        };

        let COLOR2_SHAPE2: I.Marking = {
            color: BLUE,
            shape: X_SHAPE
        };

        let COLOR3_SHAPE3: I.Marking = {
            color: PURPLE,
            shape: TRI_SHAPE
        };

        let COLOR1_SHAPE3: I.Marking = {
            color: YELLOW,
            shape: TRI_SHAPE
        };

        let cell00: I.Cell = {
            digResultByColor: {
                color1: { items: [redbullItem] },
                color2: { items: [redbullItem] },
                color3: { items: [redbullItem] }
            },
            marking: COLOR1_SHAPE1
        };

        let cell01: I.Cell = {
            digResultByColor: {
                color1: { items: [color2Shovel] },
                color2: { items: [color3Shovel] },
                color3: { items: [keyItem] }
            },
            marking: COLOR2_SHAPE2
        };

        let cell10: I.Cell = {
            digResultByColor: {
                color1: { items: [beerItem] },
                color2: { items: [beerItem] },
                color3: { items: [beerItem] }
            },
            marking: COLOR3_SHAPE3
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
        return room22;
    }
}

export = PresetData;