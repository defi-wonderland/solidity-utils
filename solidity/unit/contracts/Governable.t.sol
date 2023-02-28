// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.8 <0.9.0;

import {Governable, IGovernable} from '../../contracts/Governable.sol';
import {IBaseErrors} from '../../interfaces/IBaseErrors.sol';
import {DSTestPlus} from '../../test/DSTestPlus.sol';

contract GovernableForTest is Governable {
  constructor(address _governor) Governable(_governor) {}
}

abstract contract Base is DSTestPlus {
  address governor = label('governor');
  address pendingGovernor = label('pendingGovernor');
  address user = label('user');

  Governable governable;

  function setUp() public virtual {
    governable = new GovernableForTest(governor);
    label(address(governable), 'Governable');
  }
}

contract Unit_Governable_Constructor is Base {
  function test_RevertZeroAddress() public {
    vm.expectRevert(IBaseErrors.ZeroAddress.selector);

    new GovernableForTest(address(0));
  }

  function test_SetGovernor(address _governor) public {
    vm.assume(_governor != address(0));

    governable = new GovernableForTest(_governor);

    assertEq(governable.governor(), _governor);
  }
}

contract Unit_Governable_SetPendingGovernor is Base {
  event PendingGovernorSet(address _governor, address _pendingGovernor);

  function setUp() public override {
    Base.setUp();

    vm.startPrank(governor);
  }

  function test_RevertOnlyGovernor(address _pendingGovernor) public {
    vm.expectRevert(IGovernable.OnlyGovernor.selector);

    vm.stopPrank();
    vm.prank(user);
    governable.setPendingGovernor(_pendingGovernor);
  }

  function test_RevertZeroAddress() public {
    vm.expectRevert(IBaseErrors.ZeroAddress.selector);

    governable.setPendingGovernor(address(0));
  }

  function test_SetPendingGovernor(address _pendingGovernor) public {
    vm.assume(_pendingGovernor != address(0));

    governable.setPendingGovernor(_pendingGovernor);

    assertEq(governable.pendingGovernor(), _pendingGovernor);
  }

  function test_EmitPendingGovernorSet(address _pendingGovernor) public {
    vm.assume(_pendingGovernor != address(0));

    expectEmitNoIndex();
    emit PendingGovernorSet(governor, _pendingGovernor);

    governable.setPendingGovernor(_pendingGovernor);
  }
}

contract Unit_Governable_AcceptPendingGovernor is Base {
  event PendingGovernorAccepted(address _newGovernor);

  function setUp() public override {
    Base.setUp();

    vm.prank(governor);
    governable.setPendingGovernor(pendingGovernor);

    vm.startPrank(pendingGovernor);
  }

  function test_RevertOnlyPendingGovernor() public {
    vm.expectRevert(IGovernable.OnlyPendingGovernor.selector);

    vm.stopPrank();
    vm.prank(user);
    governable.acceptPendingGovernor();
  }

  function test_SetGovernor() public {
    governable.acceptPendingGovernor();

    assertEq(governable.governor(), pendingGovernor);
  }

  function test_ResetPendingGovernor() public {
    governable.acceptPendingGovernor();

    assertEq(governable.pendingGovernor(), address(0));
  }

  function test_EmitPendingGovernorAccepted() public {
    expectEmitNoIndex();
    emit PendingGovernorAccepted(pendingGovernor);

    governable.acceptPendingGovernor();
  }
}
