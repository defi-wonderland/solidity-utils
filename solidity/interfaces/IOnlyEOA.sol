// SPDX-License-Identifier: MIT
pragma solidity >=0.8.8 <0.9.0;

/// @title OnlyEOA interface
interface IOnlyEOA {
  // STATE VARIABLES

  /// @return _onlyEOA Whether the caller is required to be an EOA or not
  function onlyEOA() external view returns (bool _onlyEOA);

  // EVENTS

  /// @notice Emitted when onlyEOA is set
  event OnlyEOASet(bool _onlyEOA);

  // ERRORS

  /// @notice Thrown when the caller is not tx.origin
  error OnlyEOA();

  // FUNCTIONS

  /// @notice Allows governor to set the onlyEOA condition
  /// @param _onlyEOA Whether the caller is required to be an EOA or not
  function setOnlyEOA(bool _onlyEOA) external;
}
