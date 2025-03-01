player.onChat("run", function () {
    // Podstawa zamku
    blocks.fill(
        Block.StoneBricks,
        pos(3, -1, 0),
        pos(15, -1, 12),
        FillOperation.Replace
    );

    // Budowanie wież
    build_tower(3, 0);
    build_tower(11, 0);

    // Budowanie murów zamku
    build_wall(3, 2, 15, 2, "horizontal");
    build_wall(3, 10, 15, 10, "horizontal");
    build_wall(3, 2, 3, 10, "vertical");
    build_wall(15, 2, 15, 10, "vertical");

    // Dodanie okien
    add_windows_to_wall(3, 2, 15, 2, "horizontal");
    add_windows_to_wall(3, 10, 15, 10, "horizontal");

    // Brama
    build_gate(8, 2);

    // Fosa i most
    build_moat(2, 1, 16, 11, 2);
    build_bridge(8, -1);
});

function build_tower(x: number, z: number) {
    blocks.fill(
        Block.Cobblestone,
        pos(x, 0, z),
        pos(x + 2, 6, z + 2),
        FillOperation.Hollow
    );
}

function build_wall(x1: number, z1: number, x2: number, z2: number, orientation: string) {
    for (let y = 0; y <= 5; y++) {
        blocks.fill(
            Block.StoneBricks,
            pos(x1, y, z1),
            pos(x2, y, z2),
            FillOperation.Replace
        );
    }
}

function add_windows_to_wall(x1: number, z1: number, x2: number, z2: number, orientation: string) {
    let windowHeight = 3;
    if (orientation === "horizontal") {
        for (let x = x1 + 2; x < x2; x += 4) {
            blocks.place(Block.Glass, pos(x, windowHeight, z1));
        }
    }
}

function build_gate(x: number, z: number) {
    for (let y = 0; y <= 3; y++) {
        blocks.place(Block.PlanksOak, pos(x, y, z));
        blocks.place(Block.PlanksOak, pos(x + 2, y, z));
    }
    blocks.fill(
        Block.OakFence,
        pos(x + 1, 1, z),
        pos(x + 1, 2, z),
        FillOperation.Replace
    );
}

function build_moat(x1: number, z1: number, x2: number, z2: number, width: number) {
    blocks.fill(
        Block.Water,
        pos(x1 - width, -2, z1 - width),
        pos(x2 + width, -1, z2 + width),
        FillOperation.Replace
    );
}

function build_bridge(x: number, z: number) {
    blocks.fill(
        Block.PlanksOak,
        pos(x, 0, z),
        pos(x + 2, 0, z + 4),
        FillOperation.Replace
    );
}
