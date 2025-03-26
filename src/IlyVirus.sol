// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract IlyVirus {
    event Transfer(
        address indexed infector,
        address indexed infectee,
        uint256 indexed infection
    );

    mapping(uint256 infection => address infectee) _infectees;
    mapping(address infectee => address[] infectors) _infectors;
    mapping(address infector => uint256 infections) _infections;
    uint256 _totalInfections;

    constructor(address infector) {
        uint256 infection = _totalInfections++;
        _infectees[infection] = infector;
        _infections[infector] = 1;
        emit Transfer(address(0), infector, infection);
    }

    function name() external pure returns (string memory) {
        return "ily";
    }

    function symbol() external pure returns (string memory) {
        return "ily";
    }

    function tokenURI(uint256 tokenId) external pure returns (string memory) {
        tokenId;

        return
            "ipfs://bafybeibqqpfuj5fchcjelgshooz6riafigjtuvgqm77gwwaq2jywwyqpim/ily.json";
    }

    function totalSupply() external view returns (uint256) {
        return _totalInfections;
    }

    function balanceOf(
        address infectee
    ) external view returns (uint256 infections) {
        return _infections[infectee];
    }

    function ownerOf(
        uint256 infection
    ) external view returns (address infectee) {
        return _infectees[infection];
    }

    function infect(
        address infector,
        address infectee,
        uint256 infection
    ) internal {
        if (_infectees[infection] != infector) return;
        if (_infectors[infectee].length != 0) return;

        infection = _totalInfections++;

        _infectors[infectee] = _infectors[infector];
        _infectors[infectee].push(infector);
        _infectees[infection] = infectee;
        _infections[infectee] = 1;

        emit Transfer(infector, infectee, infection);

        for (uint256 j = 0; j < _infectors[infectee].length; j++) {
            infector = _infectors[infectee][j];
            infection = _totalInfections++;
            _infectees[infection] = infector;
            _infections[infector]++;

            emit Transfer(infectee, infector, infection);
        }
    }

    function safeTransferFrom(
        address infector,
        address infectee,
        uint256 infection,
        bytes calldata
    ) external {
        if (infector != msg.sender) return;
        if (_infectees[infection] != infector) return;
        infect(infector, infectee, infection);
    }

    function safeTransferFrom(
        address infector,
        address infectee,
        uint256 infection
    ) external {
        if (infector != msg.sender) return;
        if (_infectees[infection] != infector) return;
        infect(infector, infectee, infection);
    }

    function transferFrom(
        address infector,
        address infectee,
        uint256 infection
    ) external {
        if (infector == infectee) return;
        if (infector != msg.sender) return;
        if (_infectees[infection] != infector) return;
        infect(infector, infectee, infection);
    }

    function approve(address, uint256) external pure {
        return;
    }

    function setApprovalForAll(address, bool) external pure {
        return;
    }

    function getApproved(uint256) external pure returns (address operator) {
        return address(0);
    }

    function isApprovedForAll(address, address) external pure returns (bool) {
        return false;
    }
}
