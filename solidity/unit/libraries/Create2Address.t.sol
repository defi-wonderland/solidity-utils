// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.8 <0.9.0;

import {Create2Address} from '../../libraries/Create2Address.sol';
import {DSTestPlus} from '../../test/DSTestPlus.sol';

contract Create2AddressForTest {
    function computeAddress(address _factory, bytes32 _salt, bytes32 _initCodeHash)
        external
        pure
        returns (address _pool)
    {
        return Create2Address.computeAddress(_factory, _salt, _initCodeHash);
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
    function test_ComputeAddress(address _factory, bytes32 _salt, bytes32 _initCodeHash) public {
        address _pool = address(uint160(uint256(keccak256(abi.encodePacked(hex'ff', _factory, _salt, _initCodeHash)))));

        assertEq(create2Address.computeAddress(_factory, _salt, _initCodeHash), _pool);
    }
}
