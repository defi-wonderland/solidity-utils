# Wonderland Solidity Utils

`solidity-utils` is a utility package for the development of smart contracts written in Solidity. It includes useful contracts, interfaces and libraries, bringing some test tools as well.

### Contracts

- **Dust Collector**: collects small amounts of leftover tokens or ETH (also known as "dust") and transfers them to a designated recipient.

- **Governable**: provides a mechanism for managing a governor role, which has the authority to administrate the contract.

- **OnlyEOA**: validates whether a caller is an externally owned account (EOA) or not.

- **Pausable**: provides pausable functionalities to a given contract.

- **Roles**: manages roles for interactions with a smart contract, leveraging OpenZeppelin's [AccessControl](https://docs.openzeppelin.com/contracts/4.x/access-control).

### Interfaces

- **IBaseErrors**: provides a set of custom error messages that helps to catch and handle errors that may occur during contract execution.

### Libraries

- **Create2Address**: deterministically computes a contract address using the `Create2` opcode.

### Test

- **DSTestPlus**: includes utility functions for measuring gas consumption, labeling addresses, mocking contracts, simulating time, computing a contract address using Create2, and more. It extends the [DSTest](https://github.com/dapphub/ds-test/blob/master/src/test.sol) contract.
