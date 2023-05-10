// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import {ERC2771Context} from "@openzeppelin/contracts/metatx/ERC2771Context.sol";
import "@openzeppelin/contracts/proxy/Clones.sol";

interface IAIrtNFT {
    function initialize(string calldata _name, string calldata _symbol, address _admin, address _owner) external;
}

contract AIrtNFTFactory is ERC2771Context {
    address immutable tokenImplementation;

    constructor(address _implementation) ERC2771Context(0xBf175FCC7086b4f9bd59d5EAE8eA67b8f940DE0d) {
        tokenImplementation = _implementation;
    }

    event AIrtNFTCreated(
        address indexed owner,
        address nftContract
    );

    // @dev deploys a AIrtNFT contract
    function createAIrtNFT(string calldata _name, string calldata _symbol, address owner) external returns (address) {
        bytes32 salt = keccak256(abi.encode(_name, _symbol, owner));
        address clone = Clones.cloneDeterministic(tokenImplementation, salt);
        IAIrtNFT(clone).initialize(_name, _symbol, _msgSender(), owner);
        emit AIrtNFTCreated(_msgSender(), clone);
        return clone;
    }

}
