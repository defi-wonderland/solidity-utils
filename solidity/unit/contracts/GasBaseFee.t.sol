// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.8 <0.9.0;

import {GasBaseFee} from '../../contracts/GasBaseFee.sol';
import {DSTestPlus} from '../../test/DSTestPlus.sol';

contract GasBaseFeeForTest is GasBaseFee {
  function gasPrice() external view returns (uint256) {
    return _gasPrice();
  }
}

abstract contract Base is DSTestPlus {
  GasBaseFeeForTest gasBaseFee;

  function setUp() public virtual {
    gasBaseFee = new GasBaseFeeForTest();
    label(address(gasBaseFee), 'GasBaseFee');
  }
}

contract Unit_GasBaseFee_GasPrice is Base {
  function test_BlockBaseFee() public {
    uint256 _blockBaseFee = block.basefee;

    assertEq(gasBaseFee.gasPrice(), _blockBaseFee);
  }
}
