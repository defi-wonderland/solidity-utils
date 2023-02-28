// SPDX-License-Identifier: MIT
pragma solidity >=0.8.8 <0.9.0;

import {IGovernable} from './IGovernable.sol';

/// @title Pausable interface
interface IPausable is IGovernable {
  // STATE VARIABLES

  /// @return _paused Whether the contract is paused or not
  function paused() external view returns (bool _paused);

  // EVENTS

  /// @notice Emitted when the contract pause is switched
  /// @param _paused Whether the contract is paused or not
  event PausedSet(bool _paused);

  // ERRORS

  /// @notice Thrown when trying to access a paused contract
  error Paused();

  /// @notice Thrown when governor tries to switch paused to the same state as before
  error NoChangeInPaused();

  // FUNCTIONS

  /// @notice Allows governor to pause or unpause the contract
  /// @param _paused Whether the contract should be paused or not
  function setPaused(bool _paused) external;
}
