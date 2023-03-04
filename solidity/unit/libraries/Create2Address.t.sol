// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.8 <0.9.0;

import {Create2Address} from '../../libraries/Create2Address.sol';
import {DSTestPlus} from '../../test/DSTestPlus.sol';

contract Create2AddressForTest {
  function computeDeterministicAddress(
    address _deployer,
    bytes32 _salt,
    bytes32 _initCodeHash
  ) external pure returns (address _computedAddress) {
    return Create2Address.computeDeterministicAddress(_deployer, _salt, _initCodeHash);
  }
}

abstract contract Base is DSTestPlus {
  Create2AddressForTest create2Address;

  function setUp() public virtual {
    create2Address = new Create2AddressForTest();
    label(address(create2Address), 'Create2Address');
  }
}

contract Unit_Create2Address_ComputeAddress is Base {
  function test_ComputeDeterministicAddress(address _deployer, bytes32 _salt, bytes32 _initCodeHash) public {
    address _computedAddress =
      address(uint160(uint256(keccak256(abi.encodePacked(hex'ff', _deployer, _salt, _initCodeHash)))));

    assertEq(create2Address.computeDeterministicAddress(_deployer, _salt, _initCodeHash), _computedAddress);
  }
}
