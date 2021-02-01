export interface Settings {
	httpPort: number;
    graylog2: Graylog2;
    logMorgan: boolean;
}

export interface Graylog2 {
	name: string;
	level: string;
	graylog: any;
    staticMeta: any;
}

export interface Marking {
    shape: string;
    color: string;
}

export interface Item {
    name: string;
    color: string;
}

export interface DigResult {
    items: Array<Item>;
}

export interface Cell {
    marking: Marking;
    digResultByColor: { [key: string]: DigResult };
}

export interface Room {
    grid: Array<Array<Cell>>;
    depositBox: Array<Item>;
    finishedBy: string;
    attempts: number;
    roomId: string;
}

export interface CreateRoomStateResponse {
    roomId: string;
}

export interface GetRoomResponse {
    room: Room;
}