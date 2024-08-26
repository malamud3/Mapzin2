import { aStar } from "../services/aStar"; // Import the aStar function
import {createPOI} from "../entities/POI"
import { ObjectId } from 'mongodb';

test('Simple path with two points', () => {
    const start = createPOI(
        new ObjectId().toHexString(),
        'Start',
        'TestPOI',
        0,
        0,
        0,
        1,
        'Start point'
    );
    const end = createPOI(
        new ObjectId().toHexString(),
        'End',
        'TestPOI',
        1,
        1,
        0,
        1,
        'End point'
    );
    start.connections.push({ connectedPoiId: end._id!.toString(), distance: 1 });

    const result = aStar([start, end], start, end);

    expect(result).toHaveLength(2);
    expect(result[0]).toEqual(start);
    expect(result[1]).toEqual(end);
});
test('Multi-point path with four points', () => {
    const pointA = createPOI(
        new ObjectId().toHexString(),
        'A',
        'default',
        0,
        0,
        0,
        1,
        'Start point'
    );
    const pointB = createPOI(
        new ObjectId().toHexString(),
        'B',
        'default',
        1,
        0,
        0,
        1,
        'Intermediate point'
    );
    const pointC = createPOI(
        new ObjectId().toHexString(),
        'C',
        'default',
        2,
        0,
        0,
        1,
        'Intermediate point'
    );
    const pointD = createPOI(
        new ObjectId().toHexString(),
        'D',
        'default',
        3,
        0,
        0,
        1,
        'End point'
    );

    pointA.connections.push({ connectedPoiId: pointB._id!.toString(), distance: 1 });
    pointB.connections.push({ connectedPoiId: pointC._id!.toString(), distance: 1 });
    pointC.connections.push({ connectedPoiId: pointD._id!.toString(), distance: 1 });

    const result = aStar([pointA, pointB, pointC, pointD], pointA, pointD);
// Print the reconstructed path with both IDs and names
    console.log("Reconstructed path: " +
        result.map(point => `${point._id} (${point.name})`).join(" -> "));
    expect(result).toHaveLength(4);
    expect(result[0]).toEqual(pointA);
    expect(result[1]).toEqual(pointB);
    expect(result[2]).toEqual(pointC);
    expect(result[3]).toEqual(pointD);
});
test('Complex path with multiple options', () => {
    const pointA = createPOI(
        new ObjectId().toHexString(),
        'A',
        'default',
        0,
        0,
        0,
        1,
        'Start point'
    );
    const pointB = createPOI(
        new ObjectId().toHexString(),
        'B',
        'default',
        1,
        0,
        0,
        1,
        'Intermediate point'
    );
    const pointC = createPOI(
        new ObjectId().toHexString(),
        'C',
        'default',
        0,
        2,
        0,
        1,
        'Intermediate point'
    );
    const pointD = createPOI(
        new ObjectId().toHexString(),
        'D',
        'default',
        1,
        1,
        0,
        1,
        'Intermediate point'
    );
    const pointE = createPOI(
        new ObjectId().toHexString(),
        'E',
        'default',
        2,
        2,
        0,
        1,
        'End point'
    );

    pointA.connections.push(
        { connectedPoiId: pointB._id!.toString(), distance: 1 },
        { connectedPoiId: pointC._id!.toString(), distance: 2 }
    );
    pointB.connections.push({ connectedPoiId: pointD._id!.toString(), distance: 1 });
    pointC.connections.push({ connectedPoiId: pointE._id!.toString(), distance: 2 });
    pointD.connections.push({ connectedPoiId: pointE._id!.toString(), distance: 1 });

    const result = aStar([pointA, pointB, pointC, pointD, pointE], pointA, pointE);

    // Print the reconstructed path with both IDs and names
    console.log("Reconstructed path: " +
        result.map(point => `${point._id} (${point.name})`).join(" -> "));

    expect(result).toHaveLength(4);
    expect(result.map(point => point.name)).toEqual(['A', 'B', 'D', 'E']);
});
test('Complex path with multiple options and specific node structure', () => {
    const pointA = createPOI(
        new ObjectId().toHexString(),
        'A',
        'default',
        0,
        0,
        0,
        1,
        'Start point'
    );
    const pointB = createPOI(
        new ObjectId().toHexString(),
        'B',
        'default',
        2,
        0,
        0,
        1,
        'Intermediate point'
    );
    const pointC = createPOI(
        new ObjectId().toHexString(),
        'C',
        'default',
        0,
        1,
        0,
        1,
        'Intermediate point'
    );
    const pointD = createPOI(
        new ObjectId().toHexString(),
        'D',
        'default',
        1,
        2,
        0,
        1,
        'End point'
    );

    pointA.connections.push(
        { connectedPoiId: pointB._id!.toString(), distance: 2 },
        { connectedPoiId: pointC._id!.toString(), distance: 1 }
    );
    pointB.connections.push({ connectedPoiId: pointD._id!.toString(), distance: 2 });
    pointC.connections.push({ connectedPoiId: pointD._id!.toString(), distance: 1 });

    const result = aStar([pointA, pointB, pointC, pointD], pointA, pointD);

    // Print the reconstructed path with both IDs and names
    console.log("Reconstructed path: " +
        result.map(point => `${point._id} (${point.name})`).join(" -> "));

    expect(result).toHaveLength(3);
    expect(result.map(point => point.name)).toEqual(['A', 'C', 'D']);
});
