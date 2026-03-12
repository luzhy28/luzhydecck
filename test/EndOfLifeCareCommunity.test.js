// SPDX-License-Identifier: MIT

const { expect } = require('chai');
const { ethers } = require('hardhat');

describe('EndOfLifeCareCommunity Contract', function () {
    let EndOfLifeCareCommunity;
    let endOfLifeCareCommunity;

    beforeEach(async function () {
        EndOfLifeCareCommunity = await ethers.getContractFactory('EndOfLifeCareCommunity');
        endOfLifeCareCommunity = await EndOfLifeCareCommunity.deploy();
        await endOfLifeCareCommunity.deployed();
    });

    it('Should register a user successfully', async function () {
        await expect(endOfLifeCareCommunity.registerUser('UserOne')).to.emit(endOfLifeCareCommunity, 'UserRegistered').withArgs('UserOne');
    });

    it('Should register a worker successfully', async function () {
        await expect(endOfLifeCareCommunity.registerWorker('WorkerOne')).to.emit(endOfLifeCareCommunity, 'WorkerRegistered').withArgs('WorkerOne');
    });

    it('Should create a service successfully', async function () {
        await endOfLifeCareCommunity.registerWorker('WorkerOne');
        await expect(endOfLifeCareCommunity.createService('ServiceOne', 100)).to.emit(endOfLifeCareCommunity, 'ServiceCreated').withArgs('ServiceOne', 100);
    });

    it('Should book a service successfully', async function () {
        await endOfLifeCareCommunity.registerUser('UserOne');
        await endOfLifeCareCommunity.registerWorker('WorkerOne');
        await endOfLifeCareCommunity.createService('ServiceOne', 100);
        await expect(endOfLifeCareCommunity.bookService(1)).to.emit(endOfLifeCareCommunity, 'ServiceBooked').withArgs(1);
    });

    it('Should accept an order successfully', async function () {
        await endOfLifeCareCommunity.registerWorker('WorkerOne');
        await endOfLifeCareCommunity.registerUser('UserOne');
        await endOfLifeCareCommunity.createService('ServiceOne', 100);
        await endOfLifeCareCommunity.bookService(1);
        await expect(endOfLifeCareCommunity.acceptOrder(1)).to.emit(endOfLifeCareCommunity, 'OrderAccepted').withArgs(1);
    });

    it('Should complete an order successfully', async function () {
        await endOfLifeCareCommunity.registerWorker('WorkerOne');
        await endOfLifeCareCommunity.registerUser('UserOne');
        await endOfLifeCareCommunity.createService('ServiceOne', 100);
        await endOfLifeCareCommunity.bookService(1);
        await endOfLifeCareCommunity.acceptOrder(1);
        await expect(endOfLifeCareCommunity.completeOrder(1)).to.emit(endOfLifeCareCommunity, 'OrderCompleted').withArgs(1);
    });

    it('Should cancel an order successfully', async function () {
        await endOfLifeCareCommunity.registerWorker('WorkerOne');
        await endOfLifeCareCommunity.registerUser('UserOne');
        await endOfLifeCareCommunity.createService('ServiceOne', 100);
        await endOfLifeCareCommunity.bookService(1);
        await expect(endOfLifeCareCommunity.cancelOrder(1)).to.emit(endOfLifeCareCommunity, 'OrderCancelled').withArgs(1);
    });

    it('Should allow rating functionality', async function () {
        await endOfLifeCareCommunity.registerWorker('WorkerOne');
        await endOfLifeCareCommunity.registerUser('UserOne');
        await endOfLifeCareCommunity.createService('ServiceOne', 100);
        await endOfLifeCareCommunity.bookService(1);
        await endOfLifeCareCommunity.acceptOrder(1);
        await endOfLifeCareCommunity.completeOrder(1);
        await expect(endOfLifeCareCommunity.rateWorker(1, 5)).to.emit(endOfLifeCareCommunity, 'WorkerRated').withArgs(1, 5);
    });
});