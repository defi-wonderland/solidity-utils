// SPDX-License-Identifier: MIT
pragma solidity >=0.8.8 <0.9.0;

import {IGovernable} from './IGovernable.sol';
import {IBaseErrors} from './IBaseErrors.sol';

/// @title DustCollector interface
interface IDustCollector is IBaseErrors, IGovernable {
  // EVENTS

  /// @notice Emitted when dust is sent
  /// @param _to The address which wil received the funds
  /// @param _token The token that will be transferred
  /// @param _amount The amount of the token that will be transferred
  event DustSent(address _token, uint256 _amount, address _to);

  // STATE VARIABLES

  /// @return _ethAddress Address used to trigger a native token transfer
  // solhint-disable-next-line func-name-mixedcase
  function ETH_ADDRESS() external view returns (address _ethAddress);

  // FUNCTIONS

  /// @notice Allows an authorized user to transfer the tokens or eth that may have been left in a contract
  /// @param _token The token that will be transferred
  /// @param _amount The amont of the token that will be transferred
  /// @param _to The address that will receive the idle funds
  function sendDust(address _token, uint256 _amount, address _to) external;
}
