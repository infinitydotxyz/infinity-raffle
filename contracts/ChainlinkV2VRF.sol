// SPDX-License-Identifier: MIT

pragma solidity 0.8.14;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";
import "@chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol";

import {RNG} from "./interfaces/IRNG.sol";

contract ChainlinkV2VRF is Ownable, VRFConsumerBaseV2, RNG {
    event SubscriptionIdSet(uint64 subscriptionId);
    event KeyHashSet(bytes32 keyHash);

    VRFCoordinatorV2Interface COORDINATOR;
    uint64 subscriptionId;
    bytes32 keyHash;
    uint16 minimumRequestConfirmations = 10;
    uint32 callbackGasLimit = 1_000_000;

    uint16 MAX_RANDOM_NUMBERS = 500;

    mapping(uint256 => uint256[]) randomNumbers;

    constructor(
        address _vrfCoordinator,
        uint64 _subscriptionId,
        bytes32 _keyHash
    ) VRFConsumerBaseV2(_vrfCoordinator) {
        COORDINATOR = VRFCoordinatorV2Interface(_vrfCoordinator);
        _setSubscriptionId(_subscriptionId);
        _setKeyHash(_keyHash);
    }

    function requestRandomNumbers(uint32 numRandomNumbers)
        external
        override
        onlyOwner
        returns (uint256)
    {
        require(
            numRandomNumbers > 0,
            "Must request at least one random number"
        );
        require(
            numRandomNumbers <= MAX_RANDOM_NUMBERS,
            "Exceeded max number of random numbers"
        );
        uint256 requestId = COORDINATOR.requestRandomWords(
            keyHash,
            subscriptionId,
            minimumRequestConfirmations,
            callbackGasLimit,
            numRandomNumbers
        );

        emit Request(requestId, msg.sender, numRandomNumbers);
        return requestId;
    }

    function fulfillRandomWords(uint256 requestId, uint256[] memory randomWords)
        internal
        override
    {
        randomNumbers[requestId] = randomWords;
        emit RequestFulfilled(requestId, randomWords);
    }

    function isRequestFulfilled(uint256 requestId)
        external
        view
        override
        returns (bool isFulfilled)
    {
        return randomNumbers[requestId].length > 0;
    }

    function getFulfilledRequest(uint256 requestId)
        external
        view
        override
        returns (uint256[] memory randomWords)
    {
        return randomNumbers[requestId];
    }

    function _setSubscriptionId(uint64 _subscriptionId) internal {
        subscriptionId = _subscriptionId;
        emit SubscriptionIdSet(subscriptionId);
    }

    function _setKeyHash(bytes32 _keyHash) internal {
        keyHash = _keyHash;
        emit KeyHashSet(keyHash);
    }
}
