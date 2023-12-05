// SPDX-License-Identifier: MIT
pragma solidity >=0.8.8 <0.9.0;

import {Governable} from './Governable.sol';
import {IOnlyEOA} from '../interfaces/IOnlyEOA.sol';

/// @title OnlyEOA contract
/// @notice Validates whether a caller is an externally owned account or not
abstract contract OnlyEOA is IOnlyEOA, Governable {
  /// @inheritdoc IOnlyEOA
  bool public onlyEOA;

  /// @inheritdoc IOnlyEOA
  function setOnlyEOA(bool _onlyEOA) external onlyGovernor {
    _setOnlyEOA(_onlyEOA);
  }

  /// @notice Sets onlyEOA
  /// @param _onlyEOA - the value to set onlyEOA
  function _setOnlyEOA(bool _onlyEOA) internal {
    onlyEOA = _onlyEOA;
    emit OnlyEOASet(_onlyEOA);
  }

  /// @notice Validates whether the caller is EOA or not
  function _validateEOA(address _caller) internal view {
    // solhint-disable-next-line avoid-tx-origin
    if (_caller != tx.origin) revert OnlyEOA();
  }
}
