// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.8 <0.9.0;

import {Pausable, IPausable} from '../../contracts/Pausable.sol';
import {Governable, IGovernable} from '../../contracts/Governable.sol';
import {DSTestPlus} from '../../test/DSTestPlus.sol';

contract PausableForTest is Pausable {
    constructor(address _governor) Governable(_governor) {}

    function notPausedModifier() external notPaused {}
}

abstract contract Base is DSTestPlus {
    address governor = label('governor');
    address user = label('user');

    PausableForTest pausable;

    function setUp() public virtual {
        pausable = new PausableForTest(governor);
        label(address(pausable), 'Pausable');
    }
}

contract Unit_Pausable_SetPaused is Base {
    event PausedSet(bool _paused);

    function setUp() public override {
        Base.setUp();

        vm.startPrank(governor);
    }

    function test_RevertOnlyGovernor(bool _paused) public {
        vm.expectRevert(IGovernable.OnlyGovernor.selector);

        vm.stopPrank();
        vm.prank(user);
        pausable.setPaused(_paused);
    }

    function test_RevertNoChangeInPaused(bool _paused) public {
        vm.assume(_paused == pausable.paused());

        vm.expectRevert(IPausable.NoChangeInPaused.selector);

        pausable.setPaused(_paused);
    }

    function test_SetPaused(bool _paused) public {
        vm.assume(_paused != pausable.paused());

        pausable.setPaused(_paused);

        assertEq(pausable.paused(), _paused);
    }

    function test_EmitPausedSet(bool _paused) public {
        vm.assume(_paused != pausable.paused());

        expectEmitNoIndex();
        emit PausedSet(_paused);

        pausable.setPaused(_paused);
    }
}

contract Unit_Pausable_NotPaused is Base {
    function test_RevertPaused() public {
        vm.prank(governor);
        pausable.setPaused(true);

        vm.expectRevert(IPausable.Paused.selector);

        pausable.notPausedModifier();
    }

    function test_NotPaused() public {
        pausable.notPausedModifier();
    }
}
