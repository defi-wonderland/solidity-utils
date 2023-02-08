// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity >=0.8.0;

import 'ds-test/test.sol';
import 'forge-std/Test.sol';
import 'forge-std/Vm.sol';
import 'forge-std/console.sol';

/// @author Inspired by Solmate (https://github.com/transmissions11/solmate/blob/main/src/test/utils/DSTestPlus.sol)
contract DSTestPlus is Test {
    address constant DEAD_ADDRESS = 0xDeaDbeefdEAdbeefdEadbEEFdeadbeEFdEaDbeeF;

    string private checkpointLabel;
    uint256 private checkpointGasLeft = 1; // Start the slot warm.

    bytes32 internal nextAddressSeed = keccak256(abi.encodePacked('address'));

    function startMeasuringGas(string memory _checkpointLabel) internal virtual {
        checkpointLabel = _checkpointLabel;

        checkpointGasLeft = gasleft();
    }

    function stopMeasuringGas() internal virtual {
        uint256 checkpointGasLeft2 = gasleft();

        // Subtract 100 to account for the warm SLOAD in startMeasuringGas.
        uint256 gasDelta = checkpointGasLeft - checkpointGasLeft2 - 100;

        emit log_named_uint(string(abi.encodePacked(checkpointLabel, ' Gas')), gasDelta);
    }

    function assertEqUint128(uint128 a, uint128 b) internal virtual {
        assertEq(uint256(a), uint256(b));
    }

    function assertEqUint96(uint96 a, uint96 b) internal virtual {
        assertEq(uint256(a), uint256(b));
    }

    function assertEqUint64(uint64 a, uint64 b) internal virtual {
        assertEq(uint256(a), uint256(b));
    }

    function assertEqUint32(uint32 a, uint32 b) internal virtual {
        assertEq(uint256(a), uint256(b));
    }

    function min3(uint256 a, uint256 b, uint256 c) internal pure returns (uint256) {
        return a > b ? (b > c ? c : b) : (a > c ? c : a);
    }

    function min2(uint256 a, uint256 b) internal pure returns (uint256) {
        return a > b ? b : a;
    }

    function label(address addy, string memory name) internal returns (address) {
        vm.label(addy, name);
        return addy;
    }

    function label(string memory name) internal returns (address) {
        return label(newAddress(), name);
    }

    function mockContract(address addy, string memory name) internal returns (address) {
        vm.etch(addy, new bytes(0x1));
        return label(addy, name);
    }

    function mockContract(string memory name) internal returns (address) {
        return mockContract(newAddress(), name);
    }

    function advanceTime(uint256 timeToAdvance) internal {
        vm.warp(block.timestamp + timeToAdvance);
    }

    function computeDeterministicAddress(address deployer, bytes memory salt, bytes memory creationCode)
        internal
        pure
        returns (address)
    {
        return address(
            uint160(
                uint256(
                    keccak256(
                        abi.encodePacked(
                            bytes1(0xff), address(deployer), keccak256(salt), keccak256(abi.encodePacked(creationCode))
                        )
                    )
                )
            )
        );
    }

    function newAddress() internal returns (address) {
        address payable nextAddress = payable(address(uint160(uint256(nextAddressSeed))));
        nextAddressSeed = keccak256(abi.encodePacked(nextAddressSeed));
        return nextAddress;
    }

    function expectEmitNoIndex() internal {
        vm.expectEmit(true, true, true, true);
    }
}
