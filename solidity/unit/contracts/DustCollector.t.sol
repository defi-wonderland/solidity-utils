// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.8 <0.9.0;

import {DustCollector, IDustCollector, IERC20} from '../../contracts/DustCollector.sol';
import {Governable, IGovernable} from '../../contracts/Governable.sol';
import {IBaseErrors} from '../../interfaces/IBaseErrors.sol';
import {DSTestPlus} from '../../test/DSTestPlus.sol';

contract DustCollectorForTest is DustCollector {
    constructor(address _governor) Governable(_governor) {}
}

abstract contract Base is DSTestPlus {
    address governor = label('governor');
    address user = label('user');

    IERC20 token = IERC20(mockContract('Token'));

    DustCollector dustCollector;

    address constant ETH_ADDRESS = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;

    function setUp() public virtual {
        dustCollector = new DustCollectorForTest(governor);
        label(address(dustCollector), 'DustCollector');
    }
}

contract Unit_DustCollector_Constants is Base {
    function test_ETH_ADDRESS() public {
        assertEq(dustCollector.ETH_ADDRESS(), ETH_ADDRESS);
    }
}

contract Unit_DustCollector_SendDust is Base {
    uint256 initialETHBalance = type(uint256).max;

    event DustSent(address _token, uint256 _amount, address _to);

    function setUp() public override {
        Base.setUp();

        vm.deal(address(dustCollector), initialETHBalance);

        vm.startPrank(governor);
    }

    function test_RevertOnlyGovernor(uint256 _amount) public {
        vm.expectRevert(IGovernable.OnlyGovernor.selector);

        vm.stopPrank();
        vm.prank(user);
        dustCollector.sendDust(ETH_ADDRESS, _amount, user);
    }

    function test_RevertZeroAddress(uint256 _amount) public {
        vm.expectRevert(IBaseErrors.ZeroAddress.selector);

        dustCollector.sendDust(ETH_ADDRESS, _amount, address(0));
    }

    function test_SendETHDust(uint256 _amount) public {
        dustCollector.sendDust(ETH_ADDRESS, _amount, user);

        assertEq(user.balance, _amount);
    }

    function test_SendTokenDust(uint256 _amount) public {
        vm.expectCall(address(token), abi.encodeCall(IERC20.transfer, (user, _amount)));

        dustCollector.sendDust(address(token), _amount, user);
    }

    function test_EmitDustSent(uint256 _amount) public {
        expectEmitNoIndex();
        emit DustSent(ETH_ADDRESS, _amount, user);
        expectEmitNoIndex();
        emit DustSent(address(token), _amount, user);

        dustCollector.sendDust(ETH_ADDRESS, _amount, user);
        dustCollector.sendDust(address(token), _amount, user);
    }
}
