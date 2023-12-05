// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.8 <0.9.0;

import {Roles, IRoles} from '../../contracts/Roles.sol';
import {DSTestPlus} from '../../test/DSTestPlus.sol';

contract RolesForTest is Roles {
  constructor(bytes32 _role, address _account) {
    _grantRole(_role, _account);
  }

  function onlyRoleModifier(bytes32 _role) external onlyRole(_role) {}
}

abstract contract Base is DSTestPlus {
  address admin = label('admin');
  address user = label('user');

  RolesForTest roles;

  bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;

  function setUp() public virtual {
    roles = new RolesForTest(DEFAULT_ADMIN_ROLE, admin);
    label(address(roles), 'Roles');
  }
}

contract Unit_Roles_OnlyRole is Base {
  function setUp() public override {
    Base.setUp();

    vm.startPrank(admin);
  }

  function test_RevertUnauthorized() public {
    vm.expectRevert(abi.encodeWithSelector(IRoles.Unauthorized.selector, user, DEFAULT_ADMIN_ROLE));

    vm.stopPrank();
    vm.prank(user);
    roles.onlyRoleModifier(DEFAULT_ADMIN_ROLE);
  }

  function test_OnlyRole() public {
    roles.onlyRoleModifier(DEFAULT_ADMIN_ROLE);
  }
}
