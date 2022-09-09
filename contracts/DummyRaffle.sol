// SPDX-License-Identifier: MIT

pragma solidity 0.8.14;

import '@openzeppelin/contracts/access/Ownable.sol';

import {ChainlinkV2VRF} from './ChainlinkV2VRF.sol';

/**
 * THIS CONTRACT IS NOT SECURE
 */
contract DummyRaffle is Ownable {
  event Entry(address entrant, uint256 tickets, uint256 lottery);

  event WinnersSelected(uint256 lotteryId, address[] winners);

  mapping(uint256 => address[]) entriesById;
  mapping(uint256 => address[]) winnersById;
  mapping(uint256 => uint256) lotteryIdToRequestId;

  ChainlinkV2VRF rng;

  constructor(
    address _vrfCoordinator,
    uint64 _subscriptionId,
    bytes32 _keyHash
  ) {
    rng = new ChainlinkV2VRF(_vrfCoordinator, _subscriptionId, _keyHash);
  }

  function getRNGAddress() external view returns (address rngAddress) {
    return address(rng);
  }

  function enter(
    address entrant,
    uint256 lotteryId,
    uint256 tickets
  ) external {
    for (uint256 i = 0; i < tickets; i++) {
      entriesById[lotteryId].push(entrant);
    }
    emit Entry(entrant, tickets, lotteryId);
  }

  function draw(uint256 lotteryId) external onlyOwner {
    uint256 requestId = rng.requestRandomNumbers(3);
    lotteryIdToRequestId[lotteryId] = requestId;
  }

  function setWinners(uint256 lotteryId) external {
    uint256 requestId = lotteryIdToRequestId[lotteryId];
    require(requestId > 0, 'Winners have not been drawn');
    require(rng.isRequestFulfilled(requestId), 'Request must be fulfilled');
    require(winnersById[lotteryId].length == 0, 'Winners have already been set');

    uint256[] memory randomNumbers = rng.getFulfilledRequest(requestId);
    for (uint16 i = 0; i < randomNumbers.length; i++) {
      uint256 winnerIndex = randomNumbers[i] % entriesById[lotteryId].length;
      address winner = entriesById[lotteryId][winnerIndex];
      winnersById[lotteryId].push(winner);
    }

    emit WinnersSelected(lotteryId, winnersById[lotteryId]);
  }

  function getWinners(uint256 lotteryId) external view returns (address[] memory) {
    return winnersById[lotteryId];
  }
}
