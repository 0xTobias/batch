// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import '@openzeppelin/contracts/token/ERC20/ERC20.sol';
import './ERC20Mock.sol';

contract WrapperMock {
  constructor(ERC20Mock _originalToken, ERC20Mock _wrappedToken) {
    originalToken = _originalToken;
    wrappedToken = _wrappedToken;
  }

  ERC20Mock public originalToken;
  ERC20Mock public wrappedToken;

  function wrap(uint256 amount) public {
    originalToken.transferFrom(msg.sender, address(this), amount);
    wrappedToken.mint(msg.sender, amount);
  }

  function unwrap(uint256 amount) public {
    wrappedToken.burn(msg.sender, amount);
    originalToken.transferFrom(address(this), msg.sender, amount);
  }
}
