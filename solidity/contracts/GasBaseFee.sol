// SPDX-License-Identifier: MIT
pragma solidity >=0.8.8 <0.9.0;

/// @title GasBaseFee contract
/// @notice Allows child contracts to override block.basefee
abstract contract GasBaseFee {
  /// @notice Returns the current base fee per gas in wei
  /// @return _baseFee The current base fee per gas in wei
  function _gasPrice() internal view virtual returns (uint256 _baseFee) {
    return block.basefee;
  }
}
