// SPDX-License-Identifier: MIT
pragma solidity >=0.8.8 <0.9.0;

/// @title GasBaseFee contract
/// @notice Allows child contracts to override block.basefee
abstract contract GasBaseFee {
  function _gasPrice() internal view virtual returns (uint256) {
    return block.basefee;
  }
}
