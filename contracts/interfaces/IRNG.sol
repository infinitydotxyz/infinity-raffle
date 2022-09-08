// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

/**
 * @title Random number generator interface
 */
interface RNG {
  /**
   * @notice Emitted when a request for a random number is received
   * @param requestId The indexed ID of the request provided by the random number generator service
   * @param requester The indexed address of the client requesting random numbers
   * @param numRandomNumbers The number of random numbers requested
   */
  event Request(
    uint256 indexed requestId,
    address indexed requester,
    uint32 numRandomNumbers
  );

  /**
   * @notice Emitted when the request for a random number is fulfilled
   * @param requestId The indexed ID of the request provided by the random number generator service
   * @param randomNumbers The random numbers returned by the random number generator
   */
  event RequestFulfilled(
    uint256 indexed requestId,
    uint256[] randomNumbers
  );
  
  /**
   * @param numRandomNumbers The number of random numbers to get
   * @return requestId The ID of the request provided by the random number generator service
   */
  function requestRandomNumbers(uint32 numRandomNumbers) external returns (uint256);

  /**
   * @param requestId The ID of the request returned by `requestRandomNumbers` to check if it has been fulfilled yet
   * @return isFulfilled Whether the request has been fulfilled by the random number generator service yet
   */
  function isRequestFulfilled(uint256 requestId) external view returns (bool isFulfilled);

  /** 
   * @param requestId The Id of the request returned by `requestRandomNumbers` to get the resulting random numbers
   * @return randomNumbers The random numbers generated by the random number generator service
   */
  function getFulfilledRequest(uint256 requestId) external returns (uint256[] memory randomNumbers);
}