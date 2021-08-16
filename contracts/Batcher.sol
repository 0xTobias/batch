//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.4;

import 'hardhat/console.sol';
import '@openzeppelin/contracts/token/ERC20/ERC20.sol';

contract Batcher {
  constructor(ERC20 _depositToken, ERC20 _withdrawToken) {
    depositToken = _depositToken;
    withdrawToken = _withdrawToken;
  }

  ERC20 public depositToken;

  ERC20 public withdrawToken;

  mapping(address => uint256) public usersDeposits;

  function deposit(uint256 amount) public {
    depositToken.transferFrom(msg.sender, address(this), amount);
    usersDeposits[msg.sender] += amount;
  }
}
