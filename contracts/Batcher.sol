//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.4;

import 'hardhat/console.sol';
import '@openzeppelin/contracts/token/ERC20/ERC20.sol';
import '@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol';

contract Batcher {
  using SafeERC20 for ERC20;

  constructor(ERC20 _depositToken, ERC20 _withdrawToken) {
    depositToken = _depositToken;
    withdrawToken = _withdrawToken;
  }

  ERC20 public depositToken;

  ERC20 public withdrawToken;

  mapping(address => uint256) private _usersDeposits;

  mapping(address => uint256) private _withdrawBalances;

  address[] public depositors;

  function deposit(uint256 amount) public {
    if (_usersDeposits[msg.sender] == 0) {
      depositors.push(msg.sender);
    }
    depositToken.safeTransferFrom(msg.sender, address(this), amount);
    _usersDeposits[msg.sender] += amount;
  }

  function withdrawDeposited(uint256 amount) public {
    require(_usersDeposits[msg.sender] >= amount, 'withdraw amount exceeds deposit');
    depositToken.safeTransfer(msg.sender, amount);
    _usersDeposits[msg.sender] -= amount;
  }

  function withdraw(uint256 amount) public {
    require(_withdrawBalances[msg.sender] >= amount, 'withdraw amount too high');
    withdrawToken.safeTransfer(msg.sender, amount);
    _withdrawBalances[msg.sender] -= amount;
  }

  function _batchAction() private pure returns (bool) {
    //Deposit, withdraw, whatever
    return true;
  }

  function batch() public {
    uint256 depositBalance = depositToken.balanceOf(address(this));
    uint256 prevWithdrawBalance = withdrawToken.balanceOf(address(this));
    _batchAction();
    uint256 newWithdrawBalance = withdrawToken.balanceOf(address(this)) - prevWithdrawBalance;

    for (uint256 i = 0; i < depositors.length; i++) {
      address depositor = depositors[i];
      uint256 depositorDeposit = _usersDeposits[depositor];
      _withdrawBalances[depositor] += (depositorDeposit * newWithdrawBalance) / depositBalance;
      delete _usersDeposits[depositor];
    }
    delete depositors;
  }
}
