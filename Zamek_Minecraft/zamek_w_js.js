const AIR = "minecraft:air";
const STONE = "minecraft:stone";
const WOOD = "minecraft:oak_planks";
const GLASS = "minecraft:glass";
const WATER = "minecraft:water";
const TORCH = "minecraft:torch";

function createCastle(origin) {
    const { x, y, z } = origin;

    const width = 20;
    const depth = 20;
    const height = 10;
    const moatWidth = 4;

    function setBlock(x, y, z, block) {
        console.log(`Set block ${block} at (${x}, ${y}, ${z})`);
    }

    function fillArea(x1, y1, z1, x2, y2, z2, block) {
        for (let i = x1; i <= x2; i++) {
            for (let j = y1; j <= y2; j++) {
                for (let k = z1; k <= z2; k++) {
                    setBlock(i, j, k, block);
                }
            }
        }
    }

    // moat
    fillArea(x - moatWidth, y, z - moatWidth, x + width + moatWidth, y - 1, z + depth + moatWidth, WATER);

    // castle walls
    fillArea(x, y, z, x + width, y + height, z, STONE); // front wall
    fillArea(x, y, z + depth, x + width, y + height, z + depth, STONE); // back wall
    fillArea(x, y, z, x, y + height, z + depth, STONE); // left wall
    fillArea(x + width, y, z, x + width, y + height, z + depth, STONE); // right wall

    // towers
    fillArea(x, y, z, x + 3, y + height + 3, z + 3, STONE); // front-left tower
    fillArea(x + width - 3, y, z, x + width, y + height + 3, z + 3, STONE); // front-right tower
    fillArea(x, y, z + depth - 3, x + 3, y + height + 3, z + depth, STONE); // back-left tower
    fillArea(x + width - 3, y, z + depth - 3, x + width, y + height + 3, z + depth, STONE); // back-right tower

    fillArea(x, y + 5, z, x + width, y + 5, z + depth, WOOD); // first floor
    fillArea(x, y + height, z, x + width, y + height, z + depth, WOOD); // second floor

    // windows
    fillArea(x + 5, y + 2, z, x + 6, y + 3, z, GLASS); // front wall window
    fillArea(x + width - 6, y + 2, z, x + width - 5, y + 3, z, GLASS); // front wall window
    fillArea(x + 5, y + 2, z + depth, x + 6, y + 3, z + depth, GLASS); // back wall window
    fillArea(x + width - 6, y + 2, z + depth, x + width - 5, y + 3, z + depth, GLASS); // back wall window

    // gate and bridge
    fillArea(x + width / 2 - 1, y + 1, z, x + width / 2 + 1, y + 3, z, AIR); // gate
    fillArea(x + width / 2 - 2, y, z - moatWidth, x + width / 2 + 2, y, z, WOOD); // bridge

    // torches for lighting
    setBlock(x + 1, y + height + 1, z + 1, TORCH); // front-left tower torch
    setBlock(x + width - 1, y + height + 1, z + 1, TORCH); // front-right tower torch
    setBlock(x + 1, y + height + 1, z + depth - 1, TORCH); // back-left tower torch
    setBlock(x + width - 1, y + height + 1, z + depth - 1, TORCH); // back-right tower torch

    console.log("Castle created successfully!");
}

createCastle({ x: 0, y: 64, z: 0 });