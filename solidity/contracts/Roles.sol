// SPDX-License-Identifier: MIT
pragma solidity >=0.8.8 <0.9.0;

import {AccessControl} from '@openzeppelin/contracts/access/AccessControl.sol';
import {IRoles} from '../interfaces/IRoles.sol';

/// @title Roles contract
/// @notice Manages the roles for interactions with a contract
abstract contract Roles is IRoles, AccessControl {
    /// @notice Checks if an account has a particular role
    /// @param  _role The role that the account needs to have
    /// @param  _account The account to check for the role
    function _checkRole(bytes32 _role, address _account) internal view override {
        if (!hasRole(_role, _account)) revert Roles_Unauthorized(_account, _role);
    }
}
