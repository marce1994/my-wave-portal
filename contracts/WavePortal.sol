// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract WavePortal {
    uint totalWaves; // Initialized to 0 by default
    uint private seed;

    // called and returned as a log
    event NewWave(address indexed from, uint timestamp, string message);

    mapping(address => uint) public lastWavedAt;

    struct Wave {
        address waver;
        string message;
        uint timestamp;
    }

    Wave[] waves;

    constructor() payable {
        console.log("I'm a contract, but not very smart");
    }

    // hace wave :v
    function wave(string memory _message) public {
        require(lastWavedAt[msg.sender] + 15 minutes < block.timestamp, "Wait 15m");

        lastWavedAt[msg.sender] = block.timestamp;

        totalWaves++;

        console.log("%s is waved!", msg.sender); // sender is the one who called the funcction

        waves.push(Wave(msg.sender, _message, block.timestamp));

        uint randomNumber = (block.difficulty + block.timestamp + seed) % 100;
        console.log("Random # generated: %s", randomNumber);
        
        emit NewWave(msg.sender, block.timestamp, _message);

        seed = randomNumber; // Setear el nuevo numero como la siguiente semilla... what??

        if(randomNumber < 50){
            console.log("%s won!", msg.sender);
            uint prizeAmount = 0.0001 ether;
            require(prizeAmount <= address(this).balance, "Trying to withdraw more money than the contract has.");
            (bool success,) = (msg.sender).call{value: prizeAmount}("");
            require(success, "Failed to withdraw money from contract.");
        }
    }

    // retorna waves sitio
    function getAllWaves() view public returns (Wave[] memory) {
        return waves;
    }

    // retorna numero de waves total
    function getTotalWaves() view public returns (uint) {
        console.log("We have %d total waves", totalWaves);
        return totalWaves;
    }
}