//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.11;

import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import "./TokenVesting.sol";

/**
  Ref: https://github.com/Uniswap/merkle-distributor
 */
contract MerkleDistributor is TokenVesting{
    bytes32 public immutable merkleRoot;

    event Claimed(address account, uint256 amount);

    TokenVesting private tokenVesting;

    constructor(bytes32 merkleRoot_, address token_) {
        require(token_ != address(0x0));
        tokenVesting = new TokenVesting();
        tokenVesting.initializeToken(token_);

        merkleRoot = merkleRoot_;
    }

    function claim(
        address account,
        uint256 amount,
        bytes32[] calldata merkleProof
    ) public {
        // Verify the merkle proof.
        bytes32 node = keccak256(abi.encodePacked(account, amount));

        require(
            MerkleProof.verify(merkleProof, merkleRoot, node),
            "MerkleDistributor: Invalid proof."
        );

        // do your logic accordingly here
        if(tokenVesting.getVestingSchedulesCountByBeneficiary(address) == 0){
            //_start=1651343401 may 1
            tokenVesting.createVestingSchedule(account, 1651343401, uint256 _cliff, uint256 _duration, uint256 _slicePeriodSeconds, true, amount)
        }

        tokenVesting.claim

        emit Claimed(account, amount);
    }
}
