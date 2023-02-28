// SPDX-License-Identifier: MIT
pragma solidity >=0.8.8 <0.9.0;

import {Governable} from './Governable.sol';
import {IPausable} from '../interfaces/IPausable.sol';

/// @title Pausable contract
/// @notice Provides pausable functionalities to a given contract
abstract contract Pausable is IPausable, Governable {
  /// @inheritdoc IPausable
  bool public paused;

  /// @inheritdoc IPausable
  function setPaused(bool _paused) external onlyGovernor {
    _setPaused(_paused);
  }

  function _setPaused(bool _paused) internal {
    if (paused == _paused) revert NoChangeInPaused();
    paused = _paused;
    emit PausedSet(_paused);
  }

  /// @notice Provides pausable logic to the function marked with this modifier
  modifier notPaused() {
    if (paused) revert Paused();
    _;
  }
}
