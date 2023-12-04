// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.8 <0.9.0;

import {OnlyEOA, IOnlyEOA} from '../../contracts/OnlyEOA.sol';
import {Governable, IGovernable} from '../../contracts/Governable.sol';
import {DSTestPlus} from '../../test/DSTestPlus.sol';

contract OnlyEOAForTest is OnlyEOA {
  constructor(address _governor) Governable(_governor) {}

  function validateEOA(address _caller) external view {
    _validateEOA(_caller);
  }
}

abstract contract Base is DSTestPlus {
  address governor = label('governor');
  address eoa = label('eoa');

  OnlyEOAForTest onlyEOA;

  bool constant initialOnlyEOA = false;

  function setUp() public virtual {
    onlyEOA = new OnlyEOAForTest(governor);
    label(address(onlyEOA), 'OnlyEOA');
  }
}

contract Unit_OnlyEOA_StateVariables is Base {
  function test_OnlyEOA() public {
    assertEq(onlyEOA.onlyEOA(), initialOnlyEOA);
  }
}

contract Unit_OnlyEOA_SetOnlyEOA is Base {
  event OnlyEOASet(bool _onlyEOA);

  function setUp() public override {
    Base.setUp();

    vm.startPrank(governor);
  }

  function test_RevertOnlyGovernor(bool _onlyEOA) public {
    vm.expectRevert(IGovernable.OnlyGovernor.selector);

    vm.stopPrank();
    vm.prank(eoa);
    onlyEOA.setOnlyEOA(_onlyEOA);
  }

  function test_SetOnlyEOA(bool _onlyEOA) public {
    onlyEOA.setOnlyEOA(_onlyEOA);

    assertEq(onlyEOA.onlyEOA(), _onlyEOA);
  }

  function test_EmitOnlyEOASet(bool _onlyEOA) public {
    expectEmitNoIndex();
    emit OnlyEOASet(_onlyEOA);

    onlyEOA.setOnlyEOA(_onlyEOA);
  }
}

contract Unit_OnlyEOA_ValidateEOA is Base {
  function setUp() public override {
    Base.setUp();

    vm.startPrank(eoa, eoa);
  }

  function test_RevertOnlyEOA(address _caller) public {
    vm.assume(_caller != eoa);

    vm.expectRevert(IOnlyEOA.OnlyEOA.selector);

    onlyEOA.validateEOA(_caller);
  }

  function test_ValidateEOA() public {
    onlyEOA.validateEOA(eoa);
  }
}
