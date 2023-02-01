// SPDX-License-Identifier: MIT
pragma solidity >=0.8.8 <0.9.0;

import {IAccessControl} from '@openzeppelin/contracts/access/IAccessControl.sol';

/// @title Roles interface
interface IRoles is IAccessControl {
    // ERRORS

    /// @notice Thrown when the caller of the function is not an authorized role
    error Unauthorized(address _account, bytes32 _role);
}
